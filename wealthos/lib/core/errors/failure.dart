/// Domain-level failures surfaced to the application/presentation layers.
///
/// Each failure carries a stable [code] (used for localization lookup) and an
/// optional developer-facing [message]. User-facing text is resolved from the
/// [code] in the presentation layer so no English/Arabic strings leak into
/// business logic.
sealed class Failure {
  const Failure(this.code, [this.message]);

  final String code;
  final String? message;

  @override
  String toString() =>
      '$runtimeType($code)${message == null ? '' : ': $message'}';
}

/// A validation rule was violated (bad user input, broken invariant).
class ValidationFailure extends Failure {
  const ValidationFailure(super.code, [super.message]);
}

/// The requested entity does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.code, [super.message]);
}

/// A database or persistence error occurred.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.code, [super.message]);
}

/// An unexpected error that does not fit the categories above.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.code, [super.message]);
}

/// Canonical failure codes. Kept as constants so callers and the localization
/// layer agree on the exact strings.
abstract final class FailureCodes {
  static const String required = 'validation.required';
  static const String invalidAmount = 'validation.invalid_amount';
  static const String amountMustBePositive = 'validation.amount_positive';
  static const String currencyMismatch = 'validation.currency_mismatch';
  static const String sameAccountTransfer = 'validation.same_account_transfer';
  static const String accountRequired = 'validation.account_required';
  static const String destinationRequired = 'validation.destination_required';
  static const String categoryRequired = 'validation.category_required';
  static const String adjustmentReasonRequired =
      'validation.adjustment_reason_required';
  static const String categoryNotAllowed = 'validation.category_not_allowed';
  static const String categoryTypeMismatch =
      'validation.category_type_mismatch';
  static const String accountArchived = 'validation.account_archived';
  static const String categoryArchived = 'validation.category_archived';
  static const String adjustmentNoChange = 'validation.adjustment_no_change';
  static const String accountNotFound = 'error.account_not_found';
  static const String categoryNotFound = 'error.category_not_found';
  static const String transactionNotFound = 'error.transaction_not_found';
  static const String database = 'error.database';
  static const String unexpected = 'error.unexpected';
}
