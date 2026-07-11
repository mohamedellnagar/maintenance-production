import '../../accounts/domain/account_type.dart';
import 'transaction_type.dart';

/// The human-meaningful operation a transaction represents, derived from its
/// type and the classification of the account(s) involved.
///
/// The database still stores only the four [TransactionType]s; this classifier
/// keeps the storage model small while giving the UI clear, non-misleading
/// labels for liability operations (credit-card purchases, repayments, loan
/// draw-downs, …).
enum TransactionSemantic {
  income,
  expense,
  liabilityCharge, // expense booked against a liability (card purchase, interest)
  transfer, // asset ↔ asset
  liabilityRepayment, // money moved into a liability → debt goes down
  liabilityDrawdown, // money moved out of a liability → cash up, debt up
  adjustment,
}

abstract final class TransactionSemanticClassifier {
  const TransactionSemanticClassifier._();

  /// Classifies a transaction. [sourceClassification] is the classification of
  /// the [Transaction.accountId]; [destinationClassification] is required only
  /// for transfers.
  static TransactionSemantic classify({
    required TransactionType type,
    AccountClassification? sourceClassification,
    AccountClassification? destinationClassification,
  }) {
    switch (type) {
      case TransactionType.income:
        // Income into a liability reduces what is owed.
        return sourceClassification == AccountClassification.liability
            ? TransactionSemantic.liabilityRepayment
            : TransactionSemantic.income;
      case TransactionType.expense:
        return sourceClassification == AccountClassification.liability
            ? TransactionSemantic.liabilityCharge
            : TransactionSemantic.expense;
      case TransactionType.transfer:
        final srcLiability =
            sourceClassification == AccountClassification.liability;
        final dstLiability =
            destinationClassification == AccountClassification.liability;
        if (!srcLiability && dstLiability) {
          return TransactionSemantic.liabilityRepayment;
        }
        if (srcLiability && !dstLiability) {
          return TransactionSemantic.liabilityDrawdown;
        }
        return TransactionSemantic.transfer;
      case TransactionType.adjustment:
        return TransactionSemantic.adjustment;
    }
  }
}
