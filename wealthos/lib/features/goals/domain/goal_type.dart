/// The kind of financial goal. In V1 the type only drives the icon and default
/// copy — except [debtPayoff], which may link a liability account.
enum GoalType {
  emergencyFund,
  home,
  car,
  travel,
  education,
  wedding,
  retirement,
  debtPayoff,
  purchase,
  custom;

  static GoalType fromName(String value) =>
      GoalType.values.firstWhere((e) => e.name == value);

  /// Only debt-payoff goals may reference a liability account.
  bool get supportsLiabilityLink => this == GoalType.debtPayoff;
}

/// Ordering / insight weight of a goal. Never moves money automatically.
enum GoalPriority {
  low,
  medium,
  high,
  critical;

  static GoalPriority fromName(String value) =>
      GoalPriority.values.firstWhere((e) => e.name == value);

  /// Higher = more urgent, for descending sort.
  int get weight => switch (this) {
    GoalPriority.low => 0,
    GoalPriority.medium => 1,
    GoalPriority.high => 2,
    GoalPriority.critical => 3,
  };
}

/// Lifecycle state of a goal.
enum GoalStatus {
  draft,
  active,
  paused,
  completed,
  cancelled,
  archived;

  static GoalStatus fromName(String value) =>
      GoalStatus.values.firstWhere((e) => e.name == value);

  /// Only active goals accept new contributions.
  bool get acceptsContributions => this == GoalStatus.active;

  /// Draft goals are excluded from the active-goals summary.
  bool get countsInSummary =>
      this == GoalStatus.active || this == GoalStatus.paused;

  bool get isTerminal =>
      this == GoalStatus.completed ||
      this == GoalStatus.cancelled ||
      this == GoalStatus.archived;
}

/// A single fund-ledger movement type. Every entry stores a positive amount;
/// the direction is carried by the type (adjustments add [AdjustmentDirection]).
enum GoalFundEntryType {
  contribution,
  withdrawal,
  transferIn,
  transferOut,
  adjustment;

  static GoalFundEntryType fromName(String value) =>
      GoalFundEntryType.values.firstWhere((e) => e.name == value);

  /// Whether this type increases the fund (adjustments resolve via direction).
  bool get increasesByType =>
      this == GoalFundEntryType.contribution ||
      this == GoalFundEntryType.transferIn;

  bool get decreasesByType =>
      this == GoalFundEntryType.withdrawal ||
      this == GoalFundEntryType.transferOut;
}

/// Direction of an [GoalFundEntryType.adjustment] entry.
enum AdjustmentDirection {
  increase,
  decrease;

  static AdjustmentDirection fromName(String value) =>
      AdjustmentDirection.values.firstWhere((e) => e.name == value);
}

/// Derived on-track assessment of a goal (never expressed by color alone).
enum GoalTrackStatus {
  completed,
  noTargetDate,
  noContributionHistory,
  ahead,
  onTrack,
  behind,
}
