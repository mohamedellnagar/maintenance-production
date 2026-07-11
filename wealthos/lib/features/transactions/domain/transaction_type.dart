/// Kind of financial movement recorded by a transaction.
enum TransactionType {
  income,
  expense,
  transfer,
  adjustment;

  static TransactionType fromName(String value) =>
      TransactionType.values.firstWhere((e) => e.name == value);

  /// Whether this type participates in cash-flow reports (income/expense).
  /// Transfers move money between the user's own accounts and adjustments are
  /// corrections, so neither counts as cash flow.
  bool get isCashFlow =>
      this == TransactionType.income || this == TransactionType.expense;

  bool get requiresDestination => this == TransactionType.transfer;
  bool get requiresAdjustmentReason => this == TransactionType.adjustment;

  /// Adjustments may carry a signed amount (positive or negative correction);
  /// all other types store a strictly positive magnitude.
  bool get allowsSignedAmount => this == TransactionType.adjustment;
}
