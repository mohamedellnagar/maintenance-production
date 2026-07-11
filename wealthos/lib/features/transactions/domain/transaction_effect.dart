import 'transaction.dart';
import 'transaction_type.dart';

/// Pure functions describing how a transaction moves money. These are the
/// single source of truth for balance math and are unit-tested exhaustively.
abstract final class TransactionEffect {
  const TransactionEffect._();

  /// The signed change this transaction applies to [accountId]'s balance,
  /// in minor units. Returns 0 if the transaction does not touch that account
  /// or has been soft-deleted.
  ///
  /// Convention (single number line, assets positive / liabilities negative):
  /// * income     → +amount on [Transaction.accountId]
  /// * expense    → -amount on [Transaction.accountId]
  /// * transfer   → -amount on source, +amount on destination
  /// * adjustment → +amount (already signed) on [Transaction.accountId]
  ///
  /// For a liability account (stored negative), an income therefore *reduces*
  /// what is owed and an expense *increases* it — the documented rule for the
  /// income-on-liability case.
  static int deltaFor(Transaction tx, String accountId) {
    if (tx.isDeleted) return 0;
    switch (tx.type) {
      case TransactionType.income:
        return tx.accountId == accountId ? tx.amountMinor : 0;
      case TransactionType.expense:
        return tx.accountId == accountId ? -tx.amountMinor : 0;
      case TransactionType.transfer:
        if (tx.accountId == accountId) return -tx.amountMinor;
        if (tx.destinationAccountId == accountId) return tx.amountMinor;
        return 0;
      case TransactionType.adjustment:
        // amountMinor is already a signed delta for adjustments.
        return tx.accountId == accountId ? tx.amountMinor : 0;
    }
  }
}
