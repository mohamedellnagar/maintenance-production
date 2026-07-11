import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/recurring/domain/recurrence_calculator.dart';
import 'package:wealthos/features/recurring/domain/recurrence_pattern.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';

List<String> _iso(List<LocalDate> dates) =>
    dates.map((d) => d.toString()).toList();

void main() {
  group('daily', () {
    test('every day between two dates', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(frequency: RecurrenceFrequency.daily),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 1, 4),
      );
      expect(_iso(result), [
        '2026-01-01',
        '2026-01-02',
        '2026-01-03',
        '2026-01-04',
      ]);
    });
  });

  group('customInterval', () {
    test('every 3 days from the start', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.customInterval,
          intervalValue: 3,
        ),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 1, 10),
      );
      expect(_iso(result), [
        '2026-01-01',
        '2026-01-04',
        '2026-01-07',
        '2026-01-10',
      ]);
    });
  });

  group('weekly', () {
    test('multiple weekdays, single week interval', () {
      // Start Mon 2026-01-05. Mondays(1) and Thursdays(4).
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.weekly,
          weekdays: {1, 4},
        ),
        start: const LocalDate(2026, 1, 5),
        from: const LocalDate(2026, 1, 5),
        to: const LocalDate(2026, 1, 18),
      );
      expect(_iso(result), [
        '2026-01-05', // Mon
        '2026-01-08', // Thu
        '2026-01-12', // Mon
        '2026-01-15', // Thu
      ]);
    });

    test('every 2 weeks skips the intermediate week', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.weekly,
          intervalValue: 2,
          weekdays: {1},
        ),
        start: const LocalDate(2026, 1, 5),
        from: const LocalDate(2026, 1, 5),
        to: const LocalDate(2026, 2, 2),
      );
      expect(_iso(result), ['2026-01-05', '2026-01-19', '2026-02-02']);
    });
  });

  group('monthly by day-of-month', () {
    test('same day each month', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.monthly,
          monthlyDay: 15,
        ),
        start: const LocalDate(2026, 1, 15),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 3, 31),
      );
      expect(_iso(result), ['2026-01-15', '2026-02-15', '2026-03-15']);
    });

    test(
      'day 31 clamps to the last day of shorter months, never spills over',
      () {
        final result = RecurrenceCalculator.occurrences(
          pattern: const RecurrencePattern(
            frequency: RecurrenceFrequency.monthly,
            monthlyDay: 31,
          ),
          start: const LocalDate(2026, 1, 31),
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 4, 30),
        );
        // Feb → 28 (2026 not leap), Apr → 30. No March 3rd spill from Feb.
        expect(_iso(result), [
          '2026-01-31',
          '2026-02-28',
          '2026-03-31',
          '2026-04-30',
        ]);
      },
    );

    test('day 30 clamps to Feb 29 in a leap year', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.monthly,
          monthlyDay: 30,
        ),
        start: const LocalDate(2024, 1, 30),
        from: const LocalDate(2024, 2, 1),
        to: const LocalDate(2024, 2, 29),
      );
      expect(_iso(result), ['2024-02-29']);
    });
  });

  group('monthly by ordinal weekday', () {
    test('last Friday of each month', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.monthly,
          monthlyWeekOrdinal: -1,
          monthlyWeekday: 5, // Friday
        ),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 3, 31),
      );
      expect(_iso(result), ['2026-01-30', '2026-02-27', '2026-03-27']);
    });

    test('first Monday of each month', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.monthly,
          monthlyWeekOrdinal: 1,
          monthlyWeekday: 1,
        ),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 3, 31),
      );
      expect(_iso(result), ['2026-01-05', '2026-02-02', '2026-03-02']);
    });

    test('a 5th occurrence is skipped in months that lack it', () {
      // 5th Monday exists only in some months.
      final date = RecurrenceCalculator.ordinalWeekdayDate(2026, 2, 5, 1);
      expect(date, isNull);
    });
  });

  group('yearly', () {
    test('same month/day each year', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.yearly,
          yearlyMonth: 6,
          yearlyDay: 10,
        ),
        start: const LocalDate(2024, 6, 10),
        from: const LocalDate(2024, 1, 1),
        to: const LocalDate(2026, 12, 31),
      );
      expect(_iso(result), ['2024-06-10', '2025-06-10', '2026-06-10']);
    });

    test('Feb 29 yearly falls on 29 in leap years and 28 otherwise', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.yearly,
          yearlyMonth: 2,
          yearlyDay: 29,
        ),
        start: const LocalDate(2024, 2, 29),
        from: const LocalDate(2024, 1, 1),
        to: const LocalDate(2028, 12, 31),
      );
      expect(_iso(result), [
        '2024-02-29', // leap
        '2025-02-28', // clamped
        '2026-02-28', // clamped
        '2027-02-28', // clamped
        '2028-02-29', // leap
      ]);
    });
  });

  group('endDate and maxOccurrences', () {
    test('endDate caps the window', () {
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(frequency: RecurrenceFrequency.daily),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 1),
        to: const LocalDate(2026, 1, 31),
        endDate: const LocalDate(2026, 1, 3),
      );
      expect(_iso(result), ['2026-01-01', '2026-01-02', '2026-01-03']);
    });

    test('maxOccurrences counts from the first occurrence, not the window', () {
      // Max 2 total; window starts after the first, so only the 2nd shows.
      final result = RecurrenceCalculator.occurrences(
        pattern: const RecurrencePattern(frequency: RecurrenceFrequency.daily),
        start: const LocalDate(2026, 1, 1),
        from: const LocalDate(2026, 1, 2),
        to: const LocalDate(2026, 1, 31),
        maxOccurrences: 2,
      );
      expect(_iso(result), ['2026-01-02']);
    });
  });

  group('nextOccurrence', () {
    test('returns the first matching date on or after the anchor', () {
      final next = RecurrenceCalculator.nextOccurrence(
        pattern: const RecurrencePattern(
          frequency: RecurrenceFrequency.monthly,
          monthlyDay: 1,
        ),
        start: const LocalDate(2026, 1, 1),
        onOrAfter: const LocalDate(2026, 1, 2),
      );
      expect(next.toString(), '2026-02-01');
    });

    test('returns null once the rule has ended', () {
      final next = RecurrenceCalculator.nextOccurrence(
        pattern: const RecurrencePattern(frequency: RecurrenceFrequency.daily),
        start: const LocalDate(2026, 1, 1),
        onOrAfter: const LocalDate(2026, 2, 1),
        endDate: const LocalDate(2026, 1, 10),
      );
      expect(next, isNull);
    });

    test('respects maxOccurrences', () {
      final next = RecurrenceCalculator.nextOccurrence(
        pattern: const RecurrencePattern(frequency: RecurrenceFrequency.daily),
        start: const LocalDate(2026, 1, 1),
        onOrAfter: const LocalDate(2026, 1, 5),
        maxOccurrences: 3,
      );
      // Only 3 occurrences exist (Jan 1-3); nothing on/after Jan 5.
      expect(next, isNull);
    });
  });
}
