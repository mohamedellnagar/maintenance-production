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
class TransactionsRepository {
  TransactionsRepository(this._db, {Uuid? uuid, DateTime Function()? clock})
    : _uuid = uuid ?? const Uuid(),
      _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final Uuid _uuid;
  final DateTime Function() _now;

  Future<Result<Transaction>> create(NewTransactionInput input) async {
    final validation = TransactionValidator.validate(input);
    if (validation != null) {
      return Result.failure(validation);
    }

    final now = _now();
    final id = _uuid.v4();

    try {
      // A single DB transaction guarantees a transfer's source debit and
      // destination credit either both land or neither does. Account-existence
      // checks happen inside it so a bad reference rolls everything back.
      await _db.transaction(() async {
        await _assertAccountExists(input.accountId);
        if (input.type == TransactionType.transfer) {
          await _assertAccountExists(input.destinationAccountId);
        }
        await _db
            .into(_db.transactionsTable)
            .insert(
              TransactionsTableCompanion.insert(
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
                createdAt: now,
                updatedAt: now,
              ),
            );
      });
    } on _AccountMissing {
      return const Result.failure(
        NotFoundFailure(FailureCodes.accountNotFound),
      );
    }

    final row = await (_db.select(
      _db.transactionsTable,
    )..where((t) => t.id.equals(id))).getSingle();
    return Result.success(_toDomain(row));
  }

  /// Marks a transaction as deleted without removing its row.
  Future<Result<void>> softDelete(String id) async {
    final updated =
        await (_db.update(_db.transactionsTable)
              ..where((t) => t.id.equals(id))
              ..where((t) => t.deletedAt.isNull()))
            .write(
              TransactionsTableCompanion(
                deletedAt: Value(_now()),
                updatedAt: Value(_now()),
              ),
            );
    if (updated == 0) {
      return const Result.failure(UnexpectedFailure(FailureCodes.unexpected));
    }
    return const Result.success(null);
  }

  /// All non-deleted transactions, newest first.
  Future<List<Transaction>> getAll() async {
    final rows =
        await (_db.select(_db.transactionsTable)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.transactionDate,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map(_toDomain).toList();
  }

  Stream<List<Transaction>> watchAll({int? limit}) {
    final query = _db.select(_db.transactionsTable)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm(
          expression: t.transactionDate,
          mode: OrderingMode.desc,
        ),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
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

  Future<void> _assertAccountExists(String? id) async {
    if (id == null) return;
    final exists = await (_db.select(
      _db.accountsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (exists == null) throw const _AccountMissing();
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

class _AccountMissing implements Exception {
  const _AccountMissing();
}
