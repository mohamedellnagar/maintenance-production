import '../../../core/money/money.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_effect.dart';
import 'account.dart';
import 'account_balance.dart';

/// Computes account balances from source data (opening balance + transactions).
///
/// The current balance is never stored as an independently mutable value; it is
/// always derived here. A cached balance may be layered on later behind this
/// same interface if performance requires it.
abstract final class BalanceCalculator {
  const BalanceCalculator._();

  /// The signed balance of [account] in minor units.
  ///
  /// Soft-deleted transactions and transactions that do not touch the account
  /// contribute zero (handled by [TransactionEffect.deltaFor]). When
  /// [excludeTransactionId] is given, that transaction is skipped — used when
  /// editing an adjustment so the account's balance excludes the row being
  /// changed.
  static int signedBalanceMinor(
    Account account,
    Iterable<Transaction> transactions, {
    String? excludeTransactionId,
  }) {
    var total = account.openingBalanceMinor;
    for (final tx in transactions) {
      if (excludeTransactionId != null && tx.id == excludeTransactionId) {
        continue;
      }
      total += TransactionEffect.deltaFor(tx, account.id);
    }
    return total;
  }

  /// The signed balance as [Money] (assets positive, liability debt negative).
  static Money balanceOf(Account account, Iterable<Transaction> transactions) =>
      Money(
        amountMinor: signedBalanceMinor(account, transactions),
        currencyCode: account.currencyCode,
      );

  /// The full [AccountBalance] (signed / display / net-worth) for [account].
  static AccountBalance forAccount(
    Account account,
    Iterable<Transaction> transactions, {
    String? excludeTransactionId,
  }) => AccountBalance.fromSigned(
    account,
    signedBalanceMinor(
      account,
      transactions,
      excludeTransactionId: excludeTransactionId,
    ),
  );
}
