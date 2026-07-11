import '../../../core/time/local_date.dart';
import 'recurrence_pattern.dart';
import 'recurring_type.dart';

/// Pure recurrence math. Given a [RecurrencePattern] anchored at a start date,
/// it decides which calendar dates are occurrences and generates them within a
/// window, honouring end date and max-occurrences. Exhaustively unit-tested.
abstract final class RecurrenceCalculator {
  const RecurrenceCalculator._();

  /// The date of the [ordinal]-th [weekday] in [year]/[month]; `ordinal == -1`
  /// means the *last* such weekday. Returns null if it does not exist (e.g. a
  /// 5th Monday in a month that has only four).
  static LocalDate? ordinalWeekdayDate(
    int year,
    int month,
    int ordinal,
    int weekday,
  ) {
    final daysInMonth = LocalDate.daysInMonthOf(year, month);
    if (ordinal == -1) {
      final last = LocalDate(year, month, daysInMonth);
      final diff = (last.weekday - weekday + 7) % 7;
      return last.addDays(-diff);
    }
    final first = LocalDate(year, month, 1);
    final firstDiff = (weekday - first.weekday + 7) % 7;
    final day = 1 + firstDiff + (ordinal - 1) * 7;
    if (day < 1 || day > daysInMonth) return null;
    return LocalDate(year, month, day);
  }

  /// Effective day-of-month, clamped to the month's last day.
  static int effectiveMonthlyDay(int year, int month, int monthlyDay) {
    final last = LocalDate.daysInMonthOf(year, month);
    return monthlyDay > last ? last : monthlyDay;
  }

  static LocalDate _weekStart(LocalDate date) =>
      date.addDays(-(date.weekday - 1));

  /// Whether [date] is an occurrence of [pattern] anchored at [start].
  static bool matches(
    RecurrencePattern pattern,
    LocalDate start,
    LocalDate date,
  ) {
    if (date.isBefore(start)) return false;
    final interval = pattern.intervalValue < 1 ? 1 : pattern.intervalValue;
    switch (pattern.frequency) {
      case RecurrenceFrequency.daily:
      case RecurrenceFrequency.customInterval:
        return (date.epochDay - start.epochDay) % interval == 0;
      case RecurrenceFrequency.weekly:
        if (!pattern.weekdays.contains(date.weekday)) return false;
        final weeks =
            (_weekStart(date).epochDay - _weekStart(start).epochDay) ~/ 7;
        return weeks >= 0 && weeks % interval == 0;
      case RecurrenceFrequency.monthly:
        final months =
            (date.year - start.year) * 12 + (date.month - start.month);
        if (months < 0 || months % interval != 0) return false;
        if (pattern.isMonthlyByOrdinal) {
          final target = ordinalWeekdayDate(
            date.year,
            date.month,
            pattern.monthlyWeekOrdinal!,
            pattern.monthlyWeekday!,
          );
          return target != null && target == date;
        }
        final day = effectiveMonthlyDay(
          date.year,
          date.month,
          pattern.monthlyDay ?? start.day,
        );
        return date.day == day;
      case RecurrenceFrequency.yearly:
        final years = date.year - start.year;
        if (years < 0 || years % interval != 0) return false;
        final targetMonth = pattern.yearlyMonth ?? start.month;
        if (date.month != targetMonth) return false;
        final lastDay = LocalDate.daysInMonthOf(date.year, targetMonth);
        final targetDay = (pattern.yearlyDay ?? start.day);
        final effectiveDay = targetDay > lastDay ? lastDay : targetDay;
        return date.day == effectiveDay;
    }
  }

  /// All occurrences in `[from, to]` (inclusive), respecting [endDate] and
  /// [maxOccurrences] (counted from the very first occurrence).
  static List<LocalDate> occurrences({
    required RecurrencePattern pattern,
    required LocalDate start,
    required LocalDate from,
    required LocalDate to,
    LocalDate? endDate,
    int? maxOccurrences,
    int hardCap = 1000,
  }) {
    final result = <LocalDate>[];
    final upper = (endDate != null && endDate.isBefore(to)) ? endDate : to;
    var count = 0;
    var cursor = start;
    var iterations = 0;
    while (cursor.isSameOrBefore(upper)) {
      if (matches(pattern, start, cursor)) {
        if (maxOccurrences != null && count >= maxOccurrences) break;
        count++;
        if (cursor.isSameOrAfter(from)) {
          result.add(cursor);
          if (result.length >= hardCap) break;
        }
      }
      cursor = cursor.addDays(1);
      if (++iterations > 800000) break; // safety (> 2000 years)
    }
    return result;
  }

  /// The first occurrence on or after [onOrAfter], or null if the rule has
  /// ended / reached its max before then.
  static LocalDate? nextOccurrence({
    required RecurrencePattern pattern,
    required LocalDate start,
    required LocalDate onOrAfter,
    LocalDate? endDate,
    int? maxOccurrences,
  }) {
    final limit = onOrAfter.addDays(366 * 8);
    var count = 0;
    var cursor = start;
    var iterations = 0;
    while (endDate == null || cursor.isSameOrBefore(endDate)) {
      if (cursor.isAfter(limit)) return null;
      if (matches(pattern, start, cursor)) {
        if (maxOccurrences != null && count >= maxOccurrences) return null;
        count++;
        if (cursor.isSameOrAfter(onOrAfter)) return cursor;
      }
      cursor = cursor.addDays(1);
      if (++iterations > 800000) return null;
    }
    return null;
  }
}
