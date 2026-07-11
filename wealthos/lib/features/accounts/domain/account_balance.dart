import '../../../core/money/money.dart';
import 'account.dart';
import 'account_type.dart';

/// The three distinct balance concepts for an account, computed once in the
/// domain so widgets never re-derive them with ad-hoc `abs()` calls.
///
/// * [signedBalanceMinor] — internal signed value on a single number line:
///   assets positive, a liability's debt negative.
/// * [displayBalanceMinor] — what the user sees: assets keep their sign; a
///   liability shows its outstanding debt as a positive figure.
/// * [netWorthContributionMinor] — the account's contribution to net worth,
///   which is always the signed balance.
class AccountBalance {
  const AccountBalance({
    required this.classification,
    required this.currencyCode,
    required this.signedBalanceMinor,
  });

  final AccountClassification classification;
  final String currencyCode;
  final int signedBalanceMinor;

  bool get _isLiability => classification == AccountClassification.liability;

  /// Net-worth contribution == signed balance.
  int get netWorthContributionMinor => signedBalanceMinor;

  /// User-facing amount: liabilities display their debt as positive.
  int get displayBalanceMinor =>
      _isLiability ? -signedBalanceMinor : signedBalanceMinor;

  Money get signed =>
      Money(amountMinor: signedBalanceMinor, currencyCode: currencyCode);

  Money get display =>
      Money(amountMinor: displayBalanceMinor, currencyCode: currencyCode);

  Money get netWorthContribution =>
      Money(amountMinor: netWorthContributionMinor, currencyCode: currencyCode);

  /// Whether the display balance represents a "bad" position (a liability with
  /// debt, or an asset that is overdrawn). Used only for optional coloring.
  bool get isNegativePosition =>
      _isLiability ? signedBalanceMinor < 0 : signedBalanceMinor < 0;

  static AccountBalance fromSigned(Account account, int signedBalanceMinor) =>
      AccountBalance(
        classification: account.classification,
        currencyCode: account.currencyCode,
        signedBalanceMinor: signedBalanceMinor,
      );

  /// Converts a user-entered opening amount (always positive/intuitive) into
  /// the signed opening balance stored in the database. A liability's
  /// outstanding balance of 30,000 is stored as -30,000; assets store as-is.
  static int signedOpeningBalance({
    required AccountClassification classification,
    required int enteredDisplayMinor,
  }) => classification == AccountClassification.liability
      ? -enteredDisplayMinor
      : enteredDisplayMinor;
}
