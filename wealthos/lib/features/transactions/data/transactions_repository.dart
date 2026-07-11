import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/result.dart';
import '../domain/new_transaction_input.dart';
import '../domain/transaction.dart';
import '../domain/transaction_type.dart';

/// Persists and reads transactions, enforcing validation and running transfers
/// atomically. Financial rows are soft-deleted, never hard-deleted.
///
/// Pure structural rules live in [TransactionValidator]; rules that depend on
/// other tables (account/category existence, archived state, currency and
/// category-type matching) are enforced here inside the same database
/// transaction so a violation rolls the whole write back.
class TransactionsRepository {
  TransactionsRepository(this._db, {Uuid? uuid, DateTime Function()? clock})
    : _uuid = uuid ?? const Uuid(),
      _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final Uuid _uuid;
  final DateTime Function() _now;

  Future<Result<Transaction>> create(NewTransactionInput input) async {
    final validation = TransactionValidator.validate(input);
    if (validation != null) return Result.failure(validation);

    final now = _now();
    final id = _uuid.v4();
    try {
      await _db.transaction(() async {
        final ctx = await _validateContext(input);
        if (ctx != null) throw _ContextFailure(ctx);
        await _db
            .into(_db.transactionsTable)
            .insert(_companion(id: id, input: input, createdAt: now, now: now));
      });
    } on _ContextFailure catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success(await _requireById(id));
  }

  /// Atomically updates an existing (non-deleted) transaction. Re-validates all
  /// fields (including after a type change) so no stale rights survive.
  Future<Result<Transaction>> update(
    String id,
    NewTransactionInput input,
  ) async {
    final validation = TransactionValidator.validate(input);
    if (validation != null) return Result.failure(validation);

    final now = _now();
    try {
      await _db.transaction(() async {
        final existing =
            await (_db.select(_db.transactionsTable)
                  ..where((t) => t.id.equals(id))
                  ..where((t) => t.deletedAt.isNull()))
                .getSingleOrNull();
        if (existing == null) {
          throw const _ContextFailure(
            NotFoundFailure(FailureCodes.transactionNotFound),
          );
        }
        final ctx = await _validateContext(input);
        if (ctx != null) throw _ContextFailure(ctx);
        await (_db.update(
          _db.transactionsTable,
        )..where((t) => t.id.equals(id))).write(
          TransactionsTableCompanion(
            transactionType: Value(input.type.name),
            accountId: Value(input.accountId),
            destinationAccountId: Value(input.destinationAccountId),
            categoryId: Value(input.categoryId),
            amountMinor: Value(input.amountMinor),
            currencyCode: Value(input.currencyCode),
            transactionDate: Value(input.date),
            note: Value(input.note),
            adjustmentReason: Value(input.adjustmentReason),
            updatedAt: Value(now),
          ),
        );
      });
    } on _ContextFailure catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success(await _requireById(id));
  }

  /// Marks a transaction as deleted without removing its row. Idempotent: a
  /// second delete of an already-deleted row is a no-op success.
  Future<Result<void>> softDelete(String id) async {
    final now = _now();
    final updated =
        await (_db.update(_db.transactionsTable)
              ..where((t) => t.id.equals(id))
              ..where((t) => t.deletedAt.isNull()))
            .write(
              TransactionsTableCompanion(
                deletedAt: Value(now),
                updatedAt: Value(now),
              ),
            );
    if (updated == 0) {
      // Either the row does not exist or it is already deleted; treat an
      // already-deleted row as an idempotent success.
      final exists = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (exists == null) {
        return const Result.failure(
          NotFoundFailure(FailureCodes.transactionNotFound),
        );
      }
    }
    return const Result.success(null);
  }

  /// Restores a soft-deleted transaction (the same row, not a new one).
  Future<Result<void>> restore(String id) async {
    final now = _now();
    final updated =
        await (_db.update(
          _db.transactionsTable,
        )..where((t) => t.id.equals(id))).write(
          TransactionsTableCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(now),
          ),
        );
    if (updated == 0) {
      return const Result.failure(
        NotFoundFailure(FailureCodes.transactionNotFound),
      );
    }
    return const Result.success(null);
  }

  Future<Transaction?> getById(String id) async {
    final row = await (_db.select(
      _db.transactionsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Streams a single transaction by id (including soft-deleted ones, so the
  /// details screen can show a restored/deleted state reactively).
  Stream<Transaction?> watchById(String id) {
    return (_db.select(_db.transactionsTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  /// All non-deleted transactions, newest first.
  Future<List<Transaction>> getAll() async {
    final rows = await _orderedNonDeleted().get();
    return rows.map(_toDomain).toList();
  }

  Stream<List<Transaction>> watchAll({int? limit}) {
    final query = _orderedNonDeleted();
    if (limit != null) query.limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// Non-deleted transactions touching [accountId] as source or destination.
  Stream<List<Transaction>> watchForAccount(String accountId) {
    return (_db.select(_db.transactionsTable)
          ..where((t) => t.deletedAt.isNull())
          ..where(
            (t) =>
                t.accountId.equals(accountId) |
                t.destinationAccountId.equals(accountId),
          )
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  // --- internals ---

  SimpleSelectStatement<$TransactionsTableTable, TransactionsTableData>
  _orderedNonDeleted() => _db.select(_db.transactionsTable)
    ..where((t) => t.deletedAt.isNull())
    ..orderBy([
      (t) =>
          OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);

  TransactionsTableCompanion _companion({
    required String id,
    required NewTransactionInput input,
    required DateTime createdAt,
    required DateTime now,
  }) => TransactionsTableCompanion.insert(
    id: id,
    transactionType: input.type.name,
    accountId: Value(input.accountId),
    destinationAccountId: Value(input.destinationAccountId),
    categoryId: Value(input.categoryId),
    amountMinor: input.amountMinor,
    currencyCode: input.currencyCode,
    transactionDate: input.date,
    note: Value(input.note),
    adjustmentReason: Value(input.adjustmentReason),
    createdAt: createdAt,
    updatedAt: now,
  );

  /// Cross-table integrity checks. Returns a [Failure] to roll the enclosing
  /// database transaction back, or null when everything is consistent.
  Future<Failure?> _validateContext(NewTransactionInput input) async {
    final settings = await _db.managers.appSettingsTable.getSingleOrNull();
    final baseCurrency = settings?.baseCurrency;
    if (baseCurrency != null && input.currencyCode != baseCurrency) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }

    final sourceFailure = await _checkAccount(input.accountId, input);
    if (sourceFailure != null) return sourceFailure;

    if (input.type == TransactionType.transfer) {
      final destFailure = await _checkAccount(
        input.destinationAccountId,
        input,
      );
      if (destFailure != null) return destFailure;
    }

    if (input.categoryId != null) {
      final category = await (_db.select(
        _db.categoriesTable,
      )..where((c) => c.id.equals(input.categoryId!))).getSingleOrNull();
      if (category == null) {
        return const NotFoundFailure(FailureCodes.categoryNotFound);
      }
      if (category.isArchived) {
        return const ValidationFailure(FailureCodes.categoryArchived);
      }
      final expected = input.type == TransactionType.income
          ? 'income'
          : 'expense';
      if (category.categoryType != expected) {
        return const ValidationFailure(FailureCodes.categoryTypeMismatch);
      }
    }
    return null;
  }

  Future<Failure?> _checkAccount(
    String? accountId,
    NewTransactionInput input,
  ) async {
    if (accountId == null) return null;
    final account = await (_db.select(
      _db.accountsTable,
    )..where((a) => a.id.equals(accountId))).getSingleOrNull();
    if (account == null) {
      return const NotFoundFailure(FailureCodes.accountNotFound);
    }
    if (account.isArchived) {
      return const ValidationFailure(FailureCodes.accountArchived);
    }
    if (account.currencyCode != input.currencyCode) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }
    return null;
  }

  Future<Transaction> _requireById(String id) async {
    final row = await (_db.select(
      _db.transactionsTable,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toDomain(row);
  }

  Transaction _toDomain(TransactionsTableData row) => Transaction(
    id: row.id,
    type: TransactionType.fromName(row.transactionType),
    amountMinor: row.amountMinor,
    currencyCode: row.currencyCode,
    date: row.transactionDate,
    accountId: row.accountId,
    destinationAccountId: row.destinationAccountId,
    categoryId: row.categoryId,
    note: row.note,
    adjustmentReason: row.adjustmentReason,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
  );
}

class _ContextFailure implements Exception {
  const _ContextFailure(this.failure);
  final Failure failure;
}
