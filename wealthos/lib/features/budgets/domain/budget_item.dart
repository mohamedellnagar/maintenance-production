/// Kind of budget line item.
enum BudgetItemType {
  /// Planned spending, tied to an expense category.
  expense,

  /// Planned money set aside (no category/account in V1).
  saving,

  /// Planned payment toward a liability account.
  debtPayment,

  /// Expected income for the month, tied to an income category.
  incomePlan;

  static BudgetItemType fromName(String value) =>
      BudgetItemType.values.firstWhere((e) => e.name == value);

  bool get requiresExpenseCategory => this == BudgetItemType.expense;
  bool get requiresIncomeCategory => this == BudgetItemType.incomePlan;
  bool get requiresLiabilityAccount => this == BudgetItemType.debtPayment;
  bool get usesCategory =>
      this == BudgetItemType.expense || this == BudgetItemType.incomePlan;

  /// Only expense items count toward assignment and support rollover.
  bool get countsTowardAssigned =>
      this == BudgetItemType.expense ||
      this == BudgetItemType.saving ||
      this == BudgetItemType.debtPayment;

  bool get supportsRollover => this == BudgetItemType.expense;
}

/// A single line in a budget.
class BudgetItem {
  const BudgetItem({
    required this.id,
    required this.budgetId,
    required this.type,
    required this.assignedAmountMinor,
    required this.rolloverEnabled,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.accountId,
    this.customName,
    this.notes,
  });

  final String id;
  final String budgetId;
  final BudgetItemType type;
  final String? categoryId;
  final String? accountId;
  final String? customName;
  final int assignedAmountMinor;
  final bool rolloverEnabled;
  final int displayOrder;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
