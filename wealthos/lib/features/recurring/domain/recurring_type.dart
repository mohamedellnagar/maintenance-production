/// The kind of financial event a recurring rule schedules.
enum RecurringType {
  income,
  expense,
  transfer,
  liabilityPayment;

  static RecurringType fromName(String value) =>
      RecurringType.values.firstWhere((e) => e.name == value);

  bool get needsDestination =>
      this == RecurringType.transfer || this == RecurringType.liabilityPayment;
  bool get usesCategory =>
      this == RecurringType.income || this == RecurringType.expense;
  bool get isIncome => this == RecurringType.income;
  bool get isExpense => this == RecurringType.expense;
}

/// How often a rule repeats.
enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
  customInterval;

  static RecurrenceFrequency fromName(String value) =>
      RecurrenceFrequency.values.firstWhere((e) => e.name == value);
}

/// Stored occurrence status. `due` and `overdue` are *not* stored; they are
/// derived from the effective due date, and `paid` is only shown while the
/// linked transaction is alive (see [OccurrenceStatus] / display status).
enum OccurrenceStatus {
  scheduled,
  paid,
  skipped,
  cancelled;

  static OccurrenceStatus fromName(String value) =>
      OccurrenceStatus.values.firstWhere((e) => e.name == value);
}

/// The status shown to the user (derived), including the transient due/overdue.
enum OccurrenceDisplayStatus {
  scheduled,
  due,
  overdue,
  paid,
  skipped,
  cancelled,
}
