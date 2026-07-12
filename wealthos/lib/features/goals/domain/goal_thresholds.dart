/// Central tuning constants for goal progress assessment. Kept out of widgets
/// so the on-track logic has a single, testable source.
abstract final class GoalThresholds {
  const GoalThresholds._();

  /// Number of trailing months averaged to project completion.
  static const int projectionWindowMonths = 3;

  /// Average contribution at or above `required * aheadRatio` reads as ahead.
  static const double aheadRatio = 1.1;

  /// Average contribution below `required * behindRatio` reads as behind.
  static const double behindRatio = 0.9;

  /// A goal is "close to done" at or above this funded fraction (insight).
  static const double nearCompletionRatio = 0.9;

  /// Days without any contribution before the "stalled" insight fires.
  static const int staleContributionDays = 45;

  /// A target date within this many days with large remaining raises a warning.
  static const int deadlineSoonDays = 30;
}
