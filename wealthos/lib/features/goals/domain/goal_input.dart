import '../../../core/errors/failure.dart';
import '../../../core/time/local_date.dart';
import 'goal_type.dart';

/// Data to create or update a financial goal. Structural validation lives in
/// [GoalValidator]; account existence/classification/currency are checked in
/// the repository.
class GoalInput {
  const GoalInput({
    required this.name,
    required this.type,
    required this.targetAmountMinor,
    required this.currencyCode,
    required this.priority,
    this.targetDate,
    this.linkedLiabilityAccountId,
    this.notes,
  });

  final String name;
  final GoalType type;
  final int targetAmountMinor;
  final String currencyCode;
  final GoalPriority priority;
  final LocalDate? targetDate;
  final String? linkedLiabilityAccountId;
  final String? notes;
}

abstract final class GoalValidator {
  const GoalValidator._();

  static Failure? validate(GoalInput input) {
    if (input.name.trim().isEmpty) {
      return const ValidationFailure(FailureCodes.required);
    }
    if (input.targetAmountMinor <= 0) {
      return const ValidationFailure(FailureCodes.goalTargetInvalid);
    }
    // Only debt-payoff goals may link a liability account.
    if (input.linkedLiabilityAccountId != null &&
        input.type != GoalType.debtPayoff) {
      return const ValidationFailure(FailureCodes.goalLiabilityNotAllowed);
    }
    return null;
  }
}
