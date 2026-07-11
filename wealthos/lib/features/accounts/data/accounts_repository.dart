import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/result.dart';
import '../domain/account.dart';
import '../domain/account_type.dart';

/// Data needed to open a new account.
class NewAccountInput {
  const NewAccountInput({
    required this.name,
    required this.type,
    required this.classification,
    required this.currencyCode,
    this.openingBalanceMinor = 0,
    this.institutionName,
    this.accountNumberLast4,
    this.icon,
  });

  final String name;
  final AccountType type;
  final AccountClassification classification;
  final String currencyCode;
  final int openingBalanceMinor;
  final String? institutionName;
  final String? accountNumberLast4;
  final String? icon;
}

/// Reads and writes [Account]s, enforcing the current-phase invariants
/// (single base currency, non-empty name).
class AccountsRepository {
  AccountsRepository(this._db, {Uuid? uuid, DateTime Function()? clock})
    : _uuid = uuid ?? const Uuid(),
      _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final Uuid _uuid;
  final DateTime Function() _now;

  Future<Result<Account>> create(NewAccountInput input) async {
    final name = input.name.trim();
    if (name.isEmpty) {
      return const Result.failure(ValidationFailure(FailureCodes.required));
    }

    // In this phase every account must use the base currency.
    final settings = await _db.managers.appSettingsTable.getSingleOrNull();
    final baseCurrency = settings?.baseCurrency;
    if (baseCurrency != null && input.currencyCode != baseCurrency) {
      return const Result.failure(
        ValidationFailure(FailureCodes.currencyMismatch),
      );
    }

    final now = _now();
    final maxOrder = await _maxDisplayOrder();
    final id = _uuid.v4();
    final companion = AccountsTableCompanion.insert(
      id: id,
      name: name,
      accountType: input.type.name,
      classification: input.classification.name,
      currencyCode: input.currencyCode,
      openingBalanceMinor: Value(input.openingBalanceMinor),
      institutionName: Value(input.institutionName),
      accountNumberLast4: Value(input.accountNumberLast4),
      icon: Value(input.icon),
      displayOrder: Value(maxOrder + 1),
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.accountsTable).insert(companion);
    final row = await (_db.select(
      _db.accountsTable,
    )..where((t) => t.id.equals(id))).getSingle();
    return Result.success(_toDomain(row));
  }

  Future<Account?> getById(String id) async {
    final row = await (_db.select(
      _db.accountsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<List<Account>> getAll({bool includeArchived = false}) async {
    final query = _db.select(_db.accountsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  /// Streams all non-archived accounts, ordered by [Account.displayOrder].
  Stream<List<Account>> watchAll({bool includeArchived = false}) {
    final query = _db.select(_db.accountsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Result<void>> setArchived(String id, {required bool archived}) async {
    final updated =
        await (_db.update(
          _db.accountsTable,
        )..where((t) => t.id.equals(id))).write(
          AccountsTableCompanion(
            isArchived: Value(archived),
            updatedAt: Value(_now()),
          ),
        );
    if (updated == 0) {
      return const Result.failure(
        NotFoundFailure(FailureCodes.accountNotFound),
      );
    }
    return const Result.success(null);
  }

  Future<int> _maxDisplayOrder() async {
    final maxExpr = _db.accountsTable.displayOrder.max();
    final query = _db.selectOnly(_db.accountsTable)..addColumns([maxExpr]);
    final row = await query.getSingleOrNull();
    return row?.read(maxExpr) ?? 0;
  }

  Account _toDomain(AccountsTableData row) => Account(
    id: row.id,
    name: row.name,
    type: AccountType.fromName(row.accountType),
    classification: AccountClassification.fromName(row.classification),
    currencyCode: row.currencyCode,
    openingBalanceMinor: row.openingBalanceMinor,
    institutionName: row.institutionName,
    accountNumberLast4: row.accountNumberLast4,
    icon: row.icon,
    displayOrder: row.displayOrder,
    isArchived: row.isArchived,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
