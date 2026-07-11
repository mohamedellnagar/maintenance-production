/// Accounting classification of an account. Drives net-worth grouping.
enum AccountClassification {
  asset,
  liability;

  static AccountClassification fromName(String value) =>
      AccountClassification.values.firstWhere((e) => e.name == value);
}

/// Concrete kind of account the user holds.
enum AccountType {
  cash,
  bank,
  wallet,
  creditCard,
  investment,
  asset,
  loan,
  other;

  static AccountType fromName(String value) =>
      AccountType.values.firstWhere((e) => e.name == value);

  /// The default accounting classification for this type.
  ///
  /// `other` has no inherent classification — the user must choose — so it
  /// falls back to [AccountClassification.asset] and the UI forces a choice.
  AccountClassification get defaultClassification => switch (this) {
    AccountType.cash => AccountClassification.asset,
    AccountType.bank => AccountClassification.asset,
    AccountType.wallet => AccountClassification.asset,
    AccountType.investment => AccountClassification.asset,
    AccountType.asset => AccountClassification.asset,
    AccountType.creditCard => AccountClassification.liability,
    AccountType.loan => AccountClassification.liability,
    AccountType.other => AccountClassification.asset,
  };

  /// Whether the user is allowed to pick the classification for this type.
  /// Only `other` is free-form; the rest are fixed.
  bool get classificationIsUserSelectable => this == AccountType.other;
}
