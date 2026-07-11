import 'budget.dart';
import 'budget_calculator.dart';

enum BudgetInsightType {
  overspent,
  highConsumption,
  negativeAvailableToAssign,
  incomeBelowExpected,
  closedMonthChanged,
}

enum InsightSeverity { info, warning }

/// A single in-app insight. Carries only structured data; the message is
/// localized in the presentation layer.
class BudgetInsight {
  const BudgetInsight({
    required this.type,
    required this.severity,
    this.categoryId,
    this.count,
  });

  final BudgetInsightType type;
  final InsightSeverity severity;
  final String? categoryId;
  final int? count;
}

abstract final class BudgetInsightBuilder {
  const BudgetInsightBuilder._();

  /// Builds the insight list for a month. [closedSnapshotExpenseMinor] /
  /// [closedSnapshotIncomeMinor] are the totals captured when the month was
  /// closed; a live total that no longer matches raises a "results changed"
  /// insight.
  static List<BudgetInsight> build({
    required Budget budget,
    required BudgetSummary summary,
    required List<ExpenseItemResult> expenses,
    int? closedSnapshotExpenseMinor,
    int? closedSnapshotIncomeMinor,
  }) {
    final insights = <BudgetInsight>[];

    for (final e in expenses) {
      if (e.overspent) {
        insights.add(
          BudgetInsight(
            type: BudgetInsightType.overspent,
            severity: InsightSeverity.warning,
            categoryId: e.item.categoryId,
          ),
        );
      } else if (e.usageRatio >= 0.8) {
        insights.add(
          BudgetInsight(
            type: BudgetInsightType.highConsumption,
            severity: InsightSeverity.info,
            categoryId: e.item.categoryId,
          ),
        );
      }
    }

    if (summary.availableToAssignMinor < 0) {
      insights.add(
        const BudgetInsight(
          type: BudgetInsightType.negativeAvailableToAssign,
          severity: InsightSeverity.warning,
        ),
      );
    }

    if (summary.expectedIncomeMinor > 0 &&
        summary.actualIncomeMinor < summary.expectedIncomeMinor) {
      insights.add(
        const BudgetInsight(
          type: BudgetInsightType.incomeBelowExpected,
          severity: InsightSeverity.info,
        ),
      );
    }

    if (budget.status.isClosed &&
        closedSnapshotExpenseMinor != null &&
        closedSnapshotIncomeMinor != null &&
        (closedSnapshotExpenseMinor != summary.totalActualExpenseMinor ||
            closedSnapshotIncomeMinor != summary.actualIncomeMinor)) {
      insights.add(
        const BudgetInsight(
          type: BudgetInsightType.closedMonthChanged,
          severity: InsightSeverity.warning,
        ),
      );
    }

    return insights;
  }
}
