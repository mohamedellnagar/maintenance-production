import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/errors/result.dart';
import '../data/budgets_repository.dart';
import '../domain/budget.dart';
import '../domain/budget_calculator.dart';
import '../domain/budget_item.dart';
import '../domain/budget_item_input.dart';
import 'budgets_providers.dart';

final budgetControllerProvider = Provider<BudgetController>(
  (ref) => BudgetController(ref),
);

/// Thin imperative facade over [BudgetsRepository]; keeps DB calls out of
/// widgets.
class BudgetController {
  BudgetController(this._ref);
  final Ref _ref;

  BudgetsRepository get _repo => _ref.read(budgetsRepositoryProvider);

  Future<Result<Budget>> createEmpty(int year, int month) =>
      _repo.createEmptyBudget(year, month, _ref.read(baseCurrencyProvider));

  Future<Result<({Budget budget, int skipped})>> copyPrevious(
    int year,
    int month,
  ) => _repo.copyPreviousMonth(year, month, _ref.read(baseCurrencyProvider));

  Future<Result<BudgetItem>> addItem(String budgetId, BudgetItemInput input) =>
      _repo.createItem(budgetId, input);

  Future<Result<BudgetItem>> updateItem(String id, BudgetItemInput input) =>
      _repo.updateItem(id, input);

  Future<Result<void>> deleteItem(String id) => _repo.deleteItem(id);

  Future<Result<Budget>> reopen(String budgetId) => _repo.reopenMonth(budgetId);

  /// Closes [budget], carrying forward the positive remaining of the selected
  /// expense items only.
  Future<Result<Budget>> closeMonth({
    required Budget budget,
    required List<ExpenseItemResult> selectedRolloverItems,
    required BudgetSummary summary,
  }) {
    final rollovers = <RolloverSelection>[
      for (final e in selectedRolloverItems)
        if (e.remainingMinor > 0)
          (sourceItemId: e.item.id, amountMinor: e.remainingMinor),
    ];
    return _repo.closeMonth(
      budget.id,
      rollovers: rollovers,
      snapshotExpenseMinor: summary.totalActualExpenseMinor,
      snapshotIncomeMinor: summary.actualIncomeMinor,
    );
  }
}
