import '../../features/accounts/domain/account_type.dart';
import '../../features/transactions/domain/transaction_type.dart';
import 'generated/app_localizations.dart';

/// Localized display labels for domain enums, keeping enum types free of UI text.
extension AccountTypeLabel on AccountType {
  String label(AppLocalizations l) => switch (this) {
    AccountType.cash => l.accountTypeCash,
    AccountType.bank => l.accountTypeBank,
    AccountType.wallet => l.accountTypeWallet,
    AccountType.creditCard => l.accountTypeCreditCard,
    AccountType.investment => l.accountTypeInvestment,
    AccountType.asset => l.accountTypeAsset,
    AccountType.loan => l.accountTypeLoan,
    AccountType.other => l.accountTypeOther,
  };
}

extension AccountClassificationLabel on AccountClassification {
  String label(AppLocalizations l) => switch (this) {
    AccountClassification.asset => l.classificationAsset,
    AccountClassification.liability => l.classificationLiability,
  };
}

extension TransactionTypeLabel on TransactionType {
  String label(AppLocalizations l) => switch (this) {
    TransactionType.income => l.transactionTypeIncome,
    TransactionType.expense => l.transactionTypeExpense,
    TransactionType.transfer => l.transactionTypeTransfer,
    TransactionType.adjustment => l.transactionTypeAdjustment,
  };
}
