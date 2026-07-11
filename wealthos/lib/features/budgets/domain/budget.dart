/// Lifecycle status of a monthly budget.
enum BudgetStatus {
  draft,
  active,
  closed;

  static BudgetStatus fromName(String value) => BudgetStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => BudgetStatus.active,
  );

  bool get isClosed => this == BudgetStatus.closed;
}

/// A monthly budget for a single `(year, month, currencyCode)`.
class Budget {
  const Budget({
    required this.id,
    required this.year,
    required this.month,
    required this.currencyCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.closedSnapshotExpenseMinor,
    this.closedSnapshotIncomeMinor,
  });

  final String id;
  final int year;
  final int month; // 1..12
  final String currencyCode;
  final BudgetStatus status;
  final String? notes;

  /// Actual expense / income totals captured when the month was closed (null
  /// while open). Used to flag that a closed month's results later changed.
  final int? closedSnapshotExpenseMinor;
  final int? closedSnapshotIncomeMinor;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Inclusive local start of the month.
  DateTime get monthStart => DateTime(year, month, 1);

  /// Exclusive local start of the next month. Using `month + 1` lets Dart roll
  /// December→January and handles leap-year February automatically.
  DateTime get monthEndExclusive => DateTime(year, month + 1, 1);

  /// Whether [date] falls inside this budget's month (half-open interval).
  bool containsDate(DateTime date) =>
      !date.isBefore(monthStart) && date.isBefore(monthEndExclusive);

  /// The (year, month) of the following month.
  ({int year, int month}) get nextMonth =>
      month == 12 ? (year: year + 1, month: 1) : (year: year, month: month + 1);

  /// The (year, month) of the preceding month.
  ({int year, int month}) get previousMonth =>
      month == 1 ? (year: year - 1, month: 12) : (year: year, month: month - 1);
}
