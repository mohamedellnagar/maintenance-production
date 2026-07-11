/// A traceable record of money carried from one month's budget item to the
/// next. Created only by the close-month flow, never automatically.
class BudgetRollover {
  const BudgetRollover({
    required this.id,
    required this.fromBudgetId,
    required this.toBudgetId,
    required this.sourceBudgetItemId,
    required this.amountMinor,
    required this.createdAt,
    this.targetBudgetItemId,
  });

  final String id;
  final String fromBudgetId;
  final String toBudgetId;
  final String sourceBudgetItemId;
  final String? targetBudgetItemId;
  final int amountMinor;
  final DateTime createdAt;
}
