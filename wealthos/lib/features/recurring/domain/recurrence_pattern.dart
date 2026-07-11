import 'recurring_type.dart';

/// A pure description of *when* a rule repeats, independent of the money/account
/// fields. Consumed by [RecurrenceCalculator].
class RecurrencePattern {
  const RecurrencePattern({
    required this.frequency,
    this.intervalValue = 1,
    this.weekdays = const <int>{},
    this.monthlyDay,
    this.monthlyWeekOrdinal,
    this.monthlyWeekday,
    this.yearlyMonth,
    this.yearlyDay,
  });

  final RecurrenceFrequency frequency;

  /// Every N days (daily/customInterval), N weeks (weekly), N months (monthly)
  /// or N years (yearly). Always >= 1.
  final int intervalValue;

  /// Selected ISO weekdays (1=Mon..7=Sun) for weekly rules.
  final Set<int> weekdays;

  /// Monthly by day-of-month (e.g. 15). Clamped to the month's last day.
  final int? monthlyDay;

  /// Monthly by ordinal weekday: 1..4 for first–fourth, -1 for last.
  final int? monthlyWeekOrdinal;

  /// Monthly by ordinal weekday: which weekday (1=Mon..7=Sun).
  final int? monthlyWeekday;

  final int? yearlyMonth;
  final int? yearlyDay;

  bool get isMonthlyByOrdinal =>
      frequency == RecurrenceFrequency.monthly &&
      monthlyWeekOrdinal != null &&
      monthlyWeekday != null;
}
