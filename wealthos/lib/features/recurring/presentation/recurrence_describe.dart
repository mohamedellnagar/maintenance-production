import 'package:intl/intl.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_type.dart';

/// Localized short weekday name for an ISO weekday (1=Mon..7=Sun).
String weekdayName(String locale, int weekday) =>
    DateFormat.E(locale).format(DateTime(2024, 1, weekday));

String _ordinalLabel(AppLocalizations l, int ordinal) => switch (ordinal) {
  1 => l.ordinalFirst,
  2 => l.ordinalSecond,
  3 => l.ordinalThird,
  4 => l.ordinalFourth,
  -1 => l.ordinalLast,
  _ => l.ordinalFirst,
};

/// Builds a human-readable recurrence description in the current language.
String describeRecurrence(
  AppLocalizations l,
  String locale,
  RecurringRule rule,
) {
  switch (rule.frequency) {
    case RecurrenceFrequency.daily:
      return rule.intervalValue == 1
          ? l.recurrenceDaily
          : l.recurrenceEveryNDays(rule.intervalValue);
    case RecurrenceFrequency.customInterval:
      return l.recurrenceEveryNDays(rule.intervalValue);
    case RecurrenceFrequency.weekly:
      final days = (rule.weekdays.toList()..sort())
          .map((w) => weekdayName(locale, w))
          .join(', ');
      return rule.intervalValue == 1
          ? l.recurrenceWeeklyOn(days)
          : l.recurrenceEveryNWeeksOn(rule.intervalValue, days);
    case RecurrenceFrequency.monthly:
      if (rule.monthlyWeekOrdinal != null && rule.monthlyWeekday != null) {
        return l.recurrenceMonthlyOrdinalText(
          _ordinalLabel(l, rule.monthlyWeekOrdinal!),
          weekdayName(locale, rule.monthlyWeekday!),
        );
      }
      return l.recurrenceMonthlyDayText(rule.monthlyDay ?? rule.startDate.day);
    case RecurrenceFrequency.yearly:
      final month = rule.yearlyMonth ?? rule.startDate.month;
      final day = rule.yearlyDay ?? rule.startDate.day;
      final monthName = DateFormat.MMMM(locale).format(DateTime(2000, month));
      return l.recurrenceYearlyText('$day $monthName');
  }
}
