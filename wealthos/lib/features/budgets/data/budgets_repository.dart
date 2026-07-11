import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/result.dart';
import '../domain/budget.dart';
import '../domain/budget_item.dart';
import '../domain/budget_item_input.dart';
import '../domain/budget_rollover.dart';

/// One expense item's surplus selected to carry into the next month.
typedef RolloverSelection = ({String sourceItemId, int amountMinor});

/// Reads and writes budgets, budget items and rollovers, enforcing the V1
/// invariants (one budget per month, category-type/archived/duplicate/hierarchy
/// rules, closed-month read-only) inside database transactions.
class BudgetsRepository {
  BudgetsRepository(this._db, {Uuid? uuid, DateTime Function()? clock})
    : _uuid = uuid ?? const Uuid(),
      _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final Uuid _uuid;
  final DateTime Function() _now;

  // --- budgets ---

  Stream<Budget?> watchBudget(int year, int month, String currencyCode) {
    return (_db.select(_db.budgetsTable)..where(
          (b) =>
              b.year.equals(year) &
              b.month.equals(month) &
              b.currencyCode.equals(currencyCode),
        ))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _budget(row));
  }

  Future<Budget?> getBudget(int year, int month, String currencyCode) async {
    final row =
        await (_db.select(_db.budgetsTable)..where(
              (b) =>
                  b.year.equals(year) &
                  b.month.equals(month) &
                  b.currencyCode.equals(currencyCode),
            ))
            .getSingleOrNull();
    return row == null ? null : _budget(row);
  }

  Stream<Budget?> watchBudgetById(String id) =>
      (_db.select(_db.budgetsTable)..where((b) => b.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _budget(row));

  Future<Budget?> getBudgetById(String id) async {
    final row = await (_db.select(
      _db.budgetsTable,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
    return row == null ? null : _budget(row);
  }

  Future<Result<Budget>> createEmptyBudget(
    int year,
    int month,
    String currencyCode,
  ) async {
    final failure = await _validateNewBudget(year, month, currencyCode);
    if (failure != null) return Result.failure(failure);
    final budget = await _insertBudget(year, month, currencyCode);
    return Result.success(budget);
  }

  /// Copies the previous month's items (assigned amounts only, no actuals, no
  /// rollovers). Items whose category/account is archived are skipped; the
  /// skipped count is returned so the UI can inform the user.
  Future<Result<({Budget budget, int skipped})>> copyPreviousMonth(
    int year,
    int month,
    String currencyCode,
  ) async {
    final failure = await _validateNewBudget(year, month, currencyCode);
    if (failure != null) return Result.failure(failure);

    final prev = month == 1
        ? (year: year - 1, month: 12)
        : (year: year, month: month - 1);
    final previous = await getBudget(prev.year, prev.month, currencyCode);
    if (previous == null) {
      return const Result.failure(NotFoundFailure(FailureCodes.budgetNotFound));
    }

    late Budget budget;
    var skipped = 0;
    await _db.transaction(() async {
      budget = await _insertBudget(year, month, currencyCode);
      final items =
          await (_db.select(_db.budgetItemsTable)
                ..where((i) => i.budgetId.equals(previous.id))
                ..orderBy([(i) => OrderingTerm(expression: i.displayOrder)]))
              .get();
      for (final item in items) {
        if (await _isArchivedReference(item.categoryId, item.accountId)) {
          skipped++;
          continue;
        }
        await _db
            .into(_db.budgetItemsTable)
            .insert(
              _itemCompanion(
                id: _uuid.v4(),
                budgetId: budget.id,
                input: BudgetItemInput(
                  type: BudgetItemType.fromName(item.itemType),
                  assignedAmountMinor: item.assignedAmountMinor,
                  categoryId: item.categoryId,
                  accountId: item.accountId,
                  customName: item.customName,
                  rolloverEnabled: item.rolloverEnabled,
                  notes: item.notes,
                ),
                displayOrder: item.displayOrder,
                now: _now(),
              ),
            );
      }
    });
    return Result.success((budget: budget, skipped: skipped));
  }

  Future<Result<Budget>> reopenMonth(String budgetId) async {
    final now = _now();
    final updated =
        await (_db.update(
          _db.budgetsTable,
        )..where((b) => b.id.equals(budgetId))).write(
          BudgetsTableCompanion(
            status: Value(BudgetStatus.active.name),
            closedSnapshotExpenseMinor: const Value(null),
            closedSnapshotIncomeMinor: const Value(null),
            updatedAt: Value(now),
          ),
        );
    if (updated == 0) {
      return const Result.failure(NotFoundFailure(FailureCodes.budgetNotFound));
    }
    return Result.success((await getBudgetById(budgetId))!);
  }

  /// Closes [budgetId] atomically: snapshots the actual totals, carries each
  /// selected expense surplus into a linked item in the next month's budget
  /// (creating that budget if needed), records each rollover, and marks the
  /// month closed.
  Future<Result<Budget>> closeMonth(
    String budgetId, {
    required List<RolloverSelection> rollovers,
    required int snapshotExpenseMinor,
    required int snapshotIncomeMinor,
  }) async {
    try {
      await _db.transaction(() async {
        final budgetRow = await (_db.select(
          _db.budgetsTable,
        )..where((b) => b.id.equals(budgetId))).getSingleOrNull();
        if (budgetRow == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.budgetNotFound));
        }
        final budget = _budget(budgetRow);
        final next = budget.nextMonth;
        var target = await getBudget(
          next.year,
          next.month,
          budget.currencyCode,
        );
        target ??= await _insertBudget(
          next.year,
          next.month,
          budget.currencyCode,
        );

        for (final selection in rollovers) {
          if (selection.amountMinor <= 0) continue;
          final source =
              await (_db.select(_db.budgetItemsTable)
                    ..where((i) => i.id.equals(selection.sourceItemId)))
                  .getSingleOrNull();
          if (source == null || source.categoryId == null) continue;
          final targetItemId = await _ensureTargetExpenseItem(
            target.id,
            source.categoryId!,
          );
          await _db
              .into(_db.budgetRolloversTable)
              .insert(
                BudgetRolloversTableCompanion.insert(
                  id: _uuid.v4(),
                  fromBudgetId: budgetId,
                  toBudgetId: target.id,
                  sourceBudgetItemId: selection.sourceItemId,
                  targetBudgetItemId: Value(targetItemId),
                  amountMinor: selection.amountMinor,
                  createdAt: _now(),
                ),
              );
        }

        await (_db.update(
          _db.budgetsTable,
        )..where((b) => b.id.equals(budgetId))).write(
          BudgetsTableCompanion(
            status: Value(BudgetStatus.closed.name),
            closedSnapshotExpenseMinor: Value(snapshotExpenseMinor),
            closedSnapshotIncomeMinor: Value(snapshotIncomeMinor),
            updatedAt: Value(_now()),
          ),
        );
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await getBudgetById(budgetId))!);
  }

  // --- items ---

  Stream<List<BudgetItem>> watchItems(String budgetId) {
    return (_db.select(_db.budgetItemsTable)
          ..where((i) => i.budgetId.equals(budgetId))
          ..orderBy([(i) => OrderingTerm(expression: i.displayOrder)]))
        .watch()
        .map((rows) => rows.map(_item).toList());
  }

  Stream<BudgetItem?> watchItemById(String id) =>
      (_db.select(_db.budgetItemsTable)..where((i) => i.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _item(row));

  Future<Result<BudgetItem>> createItem(
    String budgetId,
    BudgetItemInput input,
  ) async {
    final structural = BudgetItemValidator.validate(input);
    if (structural != null) return Result.failure(structural);

    final id = _uuid.v4();
    try {
      await _db.transaction(() async {
        final budget = await getBudgetById(budgetId);
        if (budget == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.budgetNotFound));
        }
        if (budget.status.isClosed) {
          throw const _Failed(ValidationFailure(FailureCodes.budgetClosed));
        }
        final ctx = await _validateItemContext(budget, input);
        if (ctx != null) throw _Failed(ctx);
        final order = await _nextDisplayOrder(budgetId);
        await _db
            .into(_db.budgetItemsTable)
            .insert(
              _itemCompanion(
                id: id,
                budgetId: budgetId,
                input: input,
                displayOrder: order,
                now: _now(),
              ),
            );
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await _getItem(id))!);
  }

  Future<Result<BudgetItem>> updateItem(
    String id,
    BudgetItemInput input,
  ) async {
    final structural = BudgetItemValidator.validate(input);
    if (structural != null) return Result.failure(structural);

    try {
      await _db.transaction(() async {
        final existing = await _getItem(id);
        if (existing == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.budgetItemNotFound));
        }
        final budget = await getBudgetById(existing.budgetId);
        if (budget == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.budgetNotFound));
        }
        if (budget.status.isClosed) {
          throw const _Failed(ValidationFailure(FailureCodes.budgetClosed));
        }
        final ctx = await _validateItemContext(
          budget,
          input,
          excludeItemId: id,
        );
        if (ctx != null) throw _Failed(ctx);
        await (_db.update(
          _db.budgetItemsTable,
        )..where((i) => i.id.equals(id))).write(
          BudgetItemsTableCompanion(
            itemType: Value(input.type.name),
            categoryId: Value(input.categoryId),
            accountId: Value(input.accountId),
            customName: Value(input.customName),
            assignedAmountMinor: Value(input.assignedAmountMinor),
            rolloverEnabled: Value(input.rolloverEnabled),
            notes: Value(input.notes),
            updatedAt: Value(_now()),
          ),
        );
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await _getItem(id))!);
  }

  Future<Result<void>> deleteItem(String id) async {
    try {
      await _db.transaction(() async {
        final item = await _getItem(id);
        if (item == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.budgetItemNotFound));
        }
        final budget = await getBudgetById(item.budgetId);
        if (budget != null && budget.status.isClosed) {
          throw const _Failed(ValidationFailure(FailureCodes.budgetClosed));
        }
        final linked =
            await (_db.select(_db.budgetRolloversTable)..where(
                  (r) =>
                      r.sourceBudgetItemId.equals(id) |
                      r.targetBudgetItemId.equals(id),
                ))
                .getSingleOrNull();
        if (linked != null) {
          throw const _Failed(
            ValidationFailure(FailureCodes.budgetItemLinkedRollover),
          );
        }
        await (_db.delete(
          _db.budgetItemsTable,
        )..where((i) => i.id.equals(id))).go();
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return const Result.success(null);
  }

  // --- rollovers ---

  Stream<List<BudgetRollover>> watchIncomingRollovers(String budgetId) =>
      (_db.select(_db.budgetRolloversTable)
            ..where((r) => r.toBudgetId.equals(budgetId)))
          .watch()
          .map((rows) => rows.map(_rollover).toList());

  Stream<List<BudgetRollover>> watchRolloversForItem(String itemId) =>
      (_db.select(_db.budgetRolloversTable)..where(
            (r) =>
                r.sourceBudgetItemId.equals(itemId) |
                r.targetBudgetItemId.equals(itemId),
          ))
          .watch()
          .map((rows) => rows.map(_rollover).toList());

  // --- internals ---

  Future<Failure?> _validateNewBudget(
    int year,
    int month,
    String currencyCode,
  ) async {
    if (month < 1 || month > 12) {
      return const ValidationFailure(FailureCodes.unexpected);
    }
    final settings = await _db.managers.appSettingsTable.getSingleOrNull();
    final base = settings?.baseCurrency;
    if (base != null && currencyCode != base) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }
    final existing = await getBudget(year, month, currencyCode);
    if (existing != null) {
      return const ValidationFailure(FailureCodes.budgetExists);
    }
    return null;
  }

  Future<Budget> _insertBudget(int year, int month, String currencyCode) async {
    final now = _now();
    final id = _uuid.v4();
    await _db
        .into(_db.budgetsTable)
        .insert(
          BudgetsTableCompanion.insert(
            id: id,
            year: year,
            month: month,
            currencyCode: currencyCode,
            status: Value(BudgetStatus.active.name),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getBudgetById(id))!;
  }

  Future<Failure?> _validateItemContext(
    Budget budget,
    BudgetItemInput input, {
    String? excludeItemId,
  }) async {
    // Category rules (expense / incomePlan).
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
      final expected = input.type == BudgetItemType.incomePlan
          ? 'income'
          : 'expense';
      if (category.categoryType != expected) {
        return const ValidationFailure(FailureCodes.categoryTypeMismatch);
      }
    }

    // Liability account rules (debtPayment).
    if (input.accountId != null) {
      final account = await (_db.select(
        _db.accountsTable,
      )..where((a) => a.id.equals(input.accountId!))).getSingleOrNull();
      if (account == null) {
        return const NotFoundFailure(FailureCodes.accountNotFound);
      }
      if (account.isArchived) {
        return const ValidationFailure(FailureCodes.accountArchived);
      }
      if (input.type == BudgetItemType.debtPayment &&
          account.classification != 'liability') {
        return const ValidationFailure(FailureCodes.budgetNotLiability);
      }
    }

    // Duplicate + hierarchy prevention within the same budget.
    final siblings = await (_db.select(
      _db.budgetItemsTable,
    )..where((i) => i.budgetId.equals(budget.id))).get();
    for (final sibling in siblings) {
      if (sibling.id == excludeItemId) continue;
      if (input.categoryId != null && sibling.categoryId == input.categoryId) {
        return const ValidationFailure(FailureCodes.budgetDuplicateItem);
      }
      if (input.accountId != null && sibling.accountId == input.accountId) {
        return const ValidationFailure(FailureCodes.budgetDuplicateItem);
      }
    }
    if (input.type == BudgetItemType.expense && input.categoryId != null) {
      final conflict = await _hasHierarchyConflict(
        budget.id,
        input.categoryId!,
        excludeItemId,
      );
      if (conflict) {
        return const ValidationFailure(FailureCodes.budgetHierarchyConflict);
      }
    }
    return null;
  }

  /// True if [categoryId] is an ancestor or descendant of any existing expense
  /// item's category in [budgetId].
  Future<bool> _hasHierarchyConflict(
    String budgetId,
    String categoryId,
    String? excludeItemId,
  ) async {
    final categories = await _db.select(_db.categoriesTable).get();
    final parentOf = {for (final c in categories) c.id: c.parentId};
    final ancestors = _ancestorsOf(categoryId, parentOf);
    final items =
        await (_db.select(_db.budgetItemsTable)..where(
              (i) =>
                  i.budgetId.equals(budgetId) &
                  i.itemType.equals(BudgetItemType.expense.name),
            ))
            .get();
    for (final item in items) {
      if (item.id == excludeItemId || item.categoryId == null) continue;
      final other = item.categoryId!;
      if (ancestors.contains(other)) return true; // other is our ancestor
      if (_ancestorsOf(other, parentOf).contains(categoryId)) {
        return true; // other is our descendant
      }
    }
    return false;
  }

  Set<String> _ancestorsOf(String id, Map<String, String?> parentOf) {
    final result = <String>{};
    var current = parentOf[id];
    while (current != null && result.add(current)) {
      current = parentOf[current];
    }
    return result;
  }

  Future<bool> _isArchivedReference(
    String? categoryId,
    String? accountId,
  ) async {
    if (categoryId != null) {
      final c = await (_db.select(
        _db.categoriesTable,
      )..where((t) => t.id.equals(categoryId))).getSingleOrNull();
      if (c == null || c.isArchived) return true;
    }
    if (accountId != null) {
      final a = await (_db.select(
        _db.accountsTable,
      )..where((t) => t.id.equals(accountId))).getSingleOrNull();
      if (a == null || a.isArchived) return true;
    }
    return false;
  }

  /// Finds an existing expense item for [categoryId] in [budgetId], or creates
  /// one (assigned 0, rollover enabled) to receive a carried amount.
  Future<String> _ensureTargetExpenseItem(
    String budgetId,
    String categoryId,
  ) async {
    final existing =
        await (_db.select(_db.budgetItemsTable)..where(
              (i) =>
                  i.budgetId.equals(budgetId) & i.categoryId.equals(categoryId),
            ))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    final id = _uuid.v4();
    final order = await _nextDisplayOrder(budgetId);
    await _db
        .into(_db.budgetItemsTable)
        .insert(
          _itemCompanion(
            id: id,
            budgetId: budgetId,
            input: BudgetItemInput(
              type: BudgetItemType.expense,
              assignedAmountMinor: 0,
              categoryId: categoryId,
              rolloverEnabled: true,
            ),
            displayOrder: order,
            now: _now(),
          ),
        );
    return id;
  }

  Future<int> _nextDisplayOrder(String budgetId) async {
    final maxExpr = _db.budgetItemsTable.displayOrder.max();
    final query = _db.selectOnly(_db.budgetItemsTable)
      ..addColumns([maxExpr])
      ..where(_db.budgetItemsTable.budgetId.equals(budgetId));
    final row = await query.getSingleOrNull();
    return (row?.read(maxExpr) ?? -1) + 1;
  }

  Future<BudgetItem?> _getItem(String id) async {
    final row = await (_db.select(
      _db.budgetItemsTable,
    )..where((i) => i.id.equals(id))).getSingleOrNull();
    return row == null ? null : _item(row);
  }

  BudgetItemsTableCompanion _itemCompanion({
    required String id,
    required String budgetId,
    required BudgetItemInput input,
    required int displayOrder,
    required DateTime now,
  }) => BudgetItemsTableCompanion.insert(
    id: id,
    budgetId: budgetId,
    itemType: input.type.name,
    categoryId: Value(input.categoryId),
    accountId: Value(input.accountId),
    customName: Value(input.customName),
    assignedAmountMinor: input.assignedAmountMinor,
    rolloverEnabled: Value(input.rolloverEnabled),
    displayOrder: Value(displayOrder),
    notes: Value(input.notes),
    createdAt: now,
    updatedAt: now,
  );

  Budget _budget(BudgetsTableData row) => Budget(
    id: row.id,
    year: row.year,
    month: row.month,
    currencyCode: row.currencyCode,
    status: BudgetStatus.fromName(row.status),
    notes: row.notes,
    closedSnapshotExpenseMinor: row.closedSnapshotExpenseMinor,
    closedSnapshotIncomeMinor: row.closedSnapshotIncomeMinor,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  BudgetItem _item(BudgetItemsTableData row) => BudgetItem(
    id: row.id,
    budgetId: row.budgetId,
    type: BudgetItemType.fromName(row.itemType),
    categoryId: row.categoryId,
    accountId: row.accountId,
    customName: row.customName,
    assignedAmountMinor: row.assignedAmountMinor,
    rolloverEnabled: row.rolloverEnabled,
    displayOrder: row.displayOrder,
    notes: row.notes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  BudgetRollover _rollover(BudgetRolloversTableData row) => BudgetRollover(
    id: row.id,
    fromBudgetId: row.fromBudgetId,
    toBudgetId: row.toBudgetId,
    sourceBudgetItemId: row.sourceBudgetItemId,
    targetBudgetItemId: row.targetBudgetItemId,
    amountMinor: row.amountMinor,
    createdAt: row.createdAt,
  );

  /// Exposes the closed-month snapshot totals for insight comparison.
  Future<({int? expense, int? income})> closedSnapshot(String budgetId) async {
    final row = await (_db.select(
      _db.budgetsTable,
    )..where((b) => b.id.equals(budgetId))).getSingleOrNull();
    return (
      expense: row?.closedSnapshotExpenseMinor,
      income: row?.closedSnapshotIncomeMinor,
    );
  }
}

class _Failed implements Exception {
  const _Failed(this.failure);
  final Failure failure;
}
