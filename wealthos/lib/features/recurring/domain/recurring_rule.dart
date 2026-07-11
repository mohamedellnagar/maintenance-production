import '../../../core/time/local_date.dart';
import 'recurrence_pattern.dart';
import 'recurring_type.dart';

/// A persisted recurring rule: what repeats, for how much, on what schedule.
class RecurringRule {
  const RecurringRule({
    required this.id,
    required this.name,
    required this.type,
    required this.amountMinor,
    required this.currencyCode,
    required this.frequency,
    required this.intervalValue,
    required this.weekdays,
    required this.startDate,
    required this.autoCreateTransaction,
    required this.reminderDaysBefore,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.accountId,
    this.destinationAccountId,
    this.categoryId,
    this.monthlyDay,
    this.monthlyWeekOrdinal,
    this.monthlyWeekday,
    this.yearlyMonth,
    this.yearlyDay,
    this.endDate,
    this.maxOccurrences,
    this.notes,
    this.lastGeneratedThrough,
  });

  final String id;
  final String name;
  final RecurringType type;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
  final int amountMinor;
  final String currencyCode;
  final RecurrenceFrequency frequency;
  final int intervalValue;
  final Set<int> weekdays;
  final int? monthlyDay;
  final int? monthlyWeekOrdinal;
  final int? monthlyWeekday;
  final int? yearlyMonth;
  final int? yearlyDay;
  final LocalDate startDate;
  final LocalDate? endDate;
  final int? maxOccurrences;
  final bool autoCreateTransaction;
  final int reminderDaysBefore;
  final String? notes;
  final bool isActive;
  final LocalDate? lastGeneratedThrough;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecurrencePattern get pattern => RecurrencePattern(
    frequency: frequency,
    intervalValue: intervalValue,
    weekdays: weekdays,
    monthlyDay: monthlyDay,
    monthlyWeekOrdinal: monthlyWeekOrdinal,
    monthlyWeekday: monthlyWeekday,
    yearlyMonth: yearlyMonth,
    yearlyDay: yearlyDay,
  );
}
