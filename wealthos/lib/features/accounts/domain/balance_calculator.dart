import '../../../core/money/money.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_effect.dart';
import 'account.dart';

/// Computes account balances from source data (opening balance + transactions).
///
/// The current balance is never stored as an independently mutable value; it is
/// always derived here. A cached balance may be layered on later behind this
/// same interface if performance requires it.
abstract final class BalanceCalculator {
  const BalanceCalculator._();

  /// Balance of [account] given all [transactions] in the system.
  ///
  /// Soft-deleted transactions and transactions that do not touch the account
  /// contribute zero (handled by [TransactionEffect.deltaFor]).
  static Money balanceOf(Account account, Iterable<Transaction> transactions) {
    var total = account.openingBalanceMinor;
    for (final tx in transactions) {
      total += TransactionEffect.deltaFor(tx, account.id);
    }
    return Money(amountMinor: total, currencyCode: account.currencyCode);
  }
}
