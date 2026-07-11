import '../../../core/errors/failure.dart';
import 'transaction_type.dart';

/// Data required to record a new transaction. Validated by
/// [TransactionValidator] before it reaches the database.
class NewTransactionInput {
  const NewTransactionInput({
    required this.type,
    required this.amountMinor,
    required this.currencyCode,
    required this.date,
    this.accountId,
    this.destinationAccountId,
    this.categoryId,
    this.note,
    this.adjustmentReason,
  });

  final TransactionType type;

  /// Positive magnitude for income/expense/transfer; signed for adjustment.
  final int amountMinor;
  final String currencyCode;
  final DateTime date;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
  final String? note;
  final String? adjustmentReason;
}

/// Pure, database-independent validation of a [NewTransactionInput].
///
/// Mirrors the SQL CHECK constraints so users get friendly messages instead of
/// raw constraint violations. Returns `null` when the input is valid.
abstract final class TransactionValidator {
  const TransactionValidator._();

  static Failure? validate(NewTransactionInput input) {
    // Amount rules.
    if (input.type.allowsSignedAmount) {
      if (input.amountMinor == 0) {
        return const ValidationFailure(FailureCodes.amountMustBePositive);
      }
    } else if (input.amountMinor <= 0) {
      return const ValidationFailure(FailureCodes.amountMustBePositive);
    }

    // A category is only meaningful on cash-flow (income/expense) transactions.
    if (!input.type.isCashFlow && !_isBlank(input.categoryId)) {
      return const ValidationFailure(FailureCodes.categoryNotAllowed);
    }

    switch (input.type) {
      case TransactionType.income:
      case TransactionType.expense:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.accountRequired);
        }
      case TransactionType.transfer:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.accountRequired);
        }
        if (_isBlank(input.destinationAccountId)) {
          return const ValidationFailure(FailureCodes.destinationRequired);
        }
        if (input.accountId == input.destinationAccountId) {
          return const ValidationFailure(FailureCodes.sameAccountTransfer);
        }
      case TransactionType.adjustment:
        if (_isBlank(input.accountId)) {
          return const ValidationFailure(FailureCodes.accountRequired);
        }
        if (_isBlank(input.adjustmentReason)) {
          return const ValidationFailure(FailureCodes.adjustmentReasonRequired);
        }
    }
    return null;
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
