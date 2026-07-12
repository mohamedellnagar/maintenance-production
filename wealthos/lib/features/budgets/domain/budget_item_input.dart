import '../../../core/errors/failure.dart';
import 'budget_item.dart';

/// Data to create or update a budget item. Structural validation only; rules
/// that need other tables (category type, archived, duplicates, hierarchy) are
/// enforced in the repository.
class BudgetItemInput {
  const BudgetItemInput({
    required this.type,
    required this.assignedAmountMinor,
    this.categoryId,
    this.accountId,
    this.customName,
    this.rolloverEnabled = false,
    this.notes,
    this.linkedGoalId,
  });

  final BudgetItemType type;
  final int assignedAmountMinor;
  final String? categoryId;
  final String? accountId;
  final String? customName;
  final bool rolloverEnabled;
  final String? notes;
  final String? linkedGoalId;
}

abstract final class BudgetItemValidator {
  const BudgetItemValidator._();

  static Failure? validate(BudgetItemInput input) {
    if (input.assignedAmountMinor < 0) {
      return const ValidationFailure(FailureCodes.budgetAssignedNegative);
    }
    switch (input.type) {
      case BudgetItemType.expense:
      case BudgetItemType.incomePlan:
        if (_isBlank(input.categoryId)) {
          return const ValidationFailure(FailureCodes.budgetCategoryRequired);
        }
      case BudgetItemType.debtPayment:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.budgetLiabilityRequired);
        }
      case BudgetItemType.saving:
        break;
    }
    return null;
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
