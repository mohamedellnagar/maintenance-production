import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/errors/failure.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/recurring/domain/recurring_rule_input.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';

RecurringRuleInput _base({
  RecurringType type = RecurringType.expense,
  int amountMinor = 1000,
  RecurrenceFrequency frequency = RecurrenceFrequency.monthly,
  int intervalValue = 1,
  Set<int> weekdays = const {},
  int? monthlyDay = 1,
  int? monthlyWeekOrdinal,
  int? monthlyWeekday,
  int? yearlyMonth,
  int? yearlyDay,
  LocalDate? endDate,
  int? maxOccurrences,
  int reminderDaysBefore = 0,
  String? accountId = 'a',
  String? destinationAccountId,
  String? categoryId = 'c',
}) => RecurringRuleInput(
  name: 'Rule',
  type: type,
  amountMinor: amountMinor,
  currencyCode: 'AED',
  frequency: frequency,
  intervalValue: intervalValue,
  weekdays: weekdays,
  monthlyDay: monthlyDay,
  monthlyWeekOrdinal: monthlyWeekOrdinal,
  monthlyWeekday: monthlyWeekday,
  yearlyMonth: yearlyMonth,
  yearlyDay: yearlyDay,
  startDate: const LocalDate(2026, 1, 1),
  endDate: endDate,
  maxOccurrences: maxOccurrences,
  reminderDaysBefore: reminderDaysBefore,
  accountId: accountId,
  destinationAccountId: destinationAccountId,
  categoryId: categoryId,
);

String? _code(RecurringRuleInput input) {
  final f = RecurringRuleValidator.validate(input);
  return f == null ? null : (f as dynamic).code as String;
}

void main() {
  test('a valid monthly expense passes', () {
    expect(RecurringRuleValidator.validate(_base()), isNull);
  });

  test('empty name is rejected', () {
    final input = RecurringRuleInput(
      name: '  ',
      type: RecurringType.expense,
      amountMinor: 1000,
      currencyCode: 'AED',
      frequency: RecurrenceFrequency.daily,
      startDate: const LocalDate(2026, 1, 1),
      accountId: 'a',
      categoryId: 'c',
    );
    expect(_code(input), FailureCodes.required);
  });

  test('non-positive amount is rejected', () {
    expect(_code(_base(amountMinor: 0)), FailureCodes.amountMustBePositive);
  });

  test('interval below 1 is rejected', () {
    expect(
      _code(_base(intervalValue: 0)),
      FailureCodes.recurringIntervalInvalid,
    );
  });

  test('negative reminder is rejected', () {
    expect(
      _code(_base(reminderDaysBefore: -1)),
      FailureCodes.recurringReminderInvalid,
    );
  });

  test('non-positive maxOccurrences is rejected', () {
    expect(_code(_base(maxOccurrences: 0)), FailureCodes.recurringMaxInvalid);
  });

  test('end date before start is rejected', () {
    expect(
      _code(_base(endDate: const LocalDate(2025, 12, 1))),
      FailureCodes.recurringEndBeforeStart,
    );
  });

  test('expense without a category is rejected', () {
    expect(_code(_base(categoryId: null)), FailureCodes.categoryRequired);
  });

  test('weekly without weekdays is rejected', () {
    expect(
      _code(_base(frequency: RecurrenceFrequency.weekly, monthlyDay: null)),
      FailureCodes.recurringWeekdayRequired,
    );
  });

  test('monthly with both day and ordinal is rejected', () {
    expect(
      _code(_base(monthlyDay: 1, monthlyWeekOrdinal: 1, monthlyWeekday: 1)),
      FailureCodes.recurringInvalidSchedule,
    );
  });

  test('monthly by ordinal (last Friday) passes', () {
    expect(
      RecurringRuleValidator.validate(
        _base(monthlyDay: null, monthlyWeekOrdinal: -1, monthlyWeekday: 5),
      ),
      isNull,
    );
  });

  test('yearly without month/day is rejected', () {
    expect(
      _code(_base(frequency: RecurrenceFrequency.yearly, monthlyDay: null)),
      FailureCodes.recurringInvalidSchedule,
    );
  });

  test('transfer with a category is rejected', () {
    expect(
      _code(
        _base(
          type: RecurringType.transfer,
          destinationAccountId: 'b',
          categoryId: 'c',
        ),
      ),
      FailureCodes.categoryNotAllowed,
    );
  });

  test('transfer to the same account is rejected', () {
    expect(
      _code(
        _base(
          type: RecurringType.transfer,
          accountId: 'a',
          destinationAccountId: 'a',
          categoryId: null,
        ),
      ),
      FailureCodes.sameAccountTransfer,
    );
  });

  test('liability payment requires a destination', () {
    expect(
      _code(
        _base(
          type: RecurringType.liabilityPayment,
          destinationAccountId: null,
          categoryId: null,
        ),
      ),
      FailureCodes.destinationRequired,
    );
  });
}
