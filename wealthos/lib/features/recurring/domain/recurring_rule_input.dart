import '../../../core/errors/failure.dart';
import '../../../core/time/local_date.dart';
import 'recurring_type.dart';

/// Data to create or update a recurring rule. Structural validation lives in
/// [RecurringRuleValidator]; account/category existence, archived state,
/// classification and currency are checked in the repository.
class RecurringRuleInput {
  const RecurringRuleInput({
    required this.name,
    required this.type,
    required this.amountMinor,
    required this.currencyCode,
    required this.frequency,
    required this.startDate,
    this.intervalValue = 1,
    this.weekdays = const <int>{},
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
    this.autoCreateTransaction = false,
    this.reminderDaysBefore = 0,
    this.notes,
  });

  final String name;
  final RecurringType type;
  final int amountMinor;
  final String currencyCode;
  final RecurrenceFrequency frequency;
  final int intervalValue;
  final Set<int> weekdays;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
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
}

abstract final class RecurringRuleValidator {
  const RecurringRuleValidator._();

  static Failure? validate(RecurringRuleInput input) {
    if (input.name.trim().isEmpty) {
      return const ValidationFailure(FailureCodes.required);
    }
    if (input.amountMinor <= 0) {
      return const ValidationFailure(FailureCodes.amountMustBePositive);
    }
    if (input.intervalValue < 1) {
      return const ValidationFailure(FailureCodes.recurringIntervalInvalid);
    }
    if (input.reminderDaysBefore < 0) {
      return const ValidationFailure(FailureCodes.recurringReminderInvalid);
    }
    if (input.maxOccurrences != null && input.maxOccurrences! <= 0) {
      return const ValidationFailure(FailureCodes.recurringMaxInvalid);
    }
    if (input.endDate != null && input.endDate!.isBefore(input.startDate)) {
      return const ValidationFailure(FailureCodes.recurringEndBeforeStart);
    }

    // Type-specific account/category presence.
    switch (input.type) {
      case RecurringType.income:
      case RecurringType.expense:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.accountRequired);
        }
        if (_isBlank(input.categoryId)) {
          return const ValidationFailure(FailureCodes.categoryRequired);
        }
      case RecurringType.transfer:
      case RecurringType.liabilityPayment:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.accountRequired);
        }
        if (_isBlank(input.destinationAccountId)) {
          return const ValidationFailure(FailureCodes.destinationRequired);
        }
        if (input.accountId == input.destinationAccountId) {
          return const ValidationFailure(FailureCodes.sameAccountTransfer);
        }
        if (!_isBlank(input.categoryId)) {
          return const ValidationFailure(FailureCodes.categoryNotAllowed);
        }
    }

    // Schedule completeness.
    final scheduleFailure = _validateSchedule(input);
    if (scheduleFailure != null) return scheduleFailure;
    return null;
  }

  static Failure? _validateSchedule(RecurringRuleInput input) {
    switch (input.frequency) {
      case RecurrenceFrequency.daily:
      case RecurrenceFrequency.customInterval:
        return null;
      case RecurrenceFrequency.weekly:
        if (input.weekdays.isEmpty) {
          return const ValidationFailure(FailureCodes.recurringWeekdayRequired);
        }
        if (input.weekdays.any((d) => d < 1 || d > 7)) {
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        return null;
      case RecurrenceFrequency.monthly:
        final byDay = input.monthlyDay != null;
        final byOrdinal =
            input.monthlyWeekOrdinal != null && input.monthlyWeekday != null;
        if (byDay == byOrdinal) {
          // Exactly one of the two modes must be provided.
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        if (byDay && (input.monthlyDay! < 1 || input.monthlyDay! > 31)) {
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        if (byOrdinal &&
            (![1, 2, 3, 4, -1].contains(input.monthlyWeekOrdinal) ||
                input.monthlyWeekday! < 1 ||
                input.monthlyWeekday! > 7)) {
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        return null;
      case RecurrenceFrequency.yearly:
        final month = input.yearlyMonth;
        final day = input.yearlyDay;
        if (month == null || day == null) {
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        if (month < 1 || month > 12 || day < 1 || day > 31) {
          return const ValidationFailure(FailureCodes.recurringInvalidSchedule);
        }
        return null;
    }
  }

  static bool _isBlank(String? v) => v == null || v.trim().isEmpty;
}
