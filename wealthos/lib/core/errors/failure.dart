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
  // Budgeting.
  static const String budgetAssignedNegative =
      'validation.budget_assigned_negative';
  static const String budgetCategoryRequired = 'validation.budget_category';
  static const String budgetLiabilityRequired = 'validation.budget_liability';
  static const String budgetNotLiability = 'validation.budget_not_liability';
  static const String budgetDuplicateItem = 'validation.budget_duplicate_item';
  static const String budgetHierarchyConflict =
      'validation.budget_hierarchy_conflict';
  static const String budgetExists = 'validation.budget_exists';
  static const String budgetClosed = 'validation.budget_closed';
  static const String budgetItemLinkedRollover =
      'validation.budget_item_linked_rollover';
  static const String budgetNotFound = 'error.budget_not_found';
  static const String budgetItemNotFound = 'error.budget_item_not_found';
  // Recurring.
  static const String recurringWeekdayRequired =
      'validation.recurring_weekday_required';
  static const String recurringInvalidSchedule =
      'validation.recurring_invalid_schedule';
  static const String recurringEndBeforeStart =
      'validation.recurring_end_before_start';
  static const String recurringMaxInvalid = 'validation.recurring_max_invalid';
  static const String recurringReminderInvalid =
      'validation.recurring_reminder_invalid';
  static const String recurringIntervalInvalid =
      'validation.recurring_interval_invalid';
  static const String recurringNotLiability =
      'validation.recurring_not_liability';
  static const String occurrenceAlreadyPosted =
      'validation.occurrence_already_posted';
  static const String occurrenceNotOpen = 'validation.occurrence_not_open';
  static const String ruleNotFound = 'error.rule_not_found';
  static const String occurrenceNotFound = 'error.occurrence_not_found';
  static const String database = 'error.database';
  static const String unexpected = 'error.unexpected';
}
