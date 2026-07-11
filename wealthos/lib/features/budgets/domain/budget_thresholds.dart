/// Central, tunable thresholds for budget status and in-app insights. Kept out
/// of widgets so the numbers live in one place.
abstract final class BudgetThresholds {
  /// Usage ratio at/above which an expense item is "near its limit".
  static const double nearLimitRatio = 0.8;

  /// Usage ratio at/above which an insight about high consumption is raised.
  static const double highConsumptionRatio = 0.8;
}
