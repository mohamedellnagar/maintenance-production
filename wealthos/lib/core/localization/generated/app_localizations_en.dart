// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WealthOS';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDone => 'Done';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonNote => 'Note';

  @override
  String get commonDate => 'Date';

  @override
  String get commonAll => 'All';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonUndo => 'Undo';

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageSubtitle =>
      'You can change this later in Settings.';

  @override
  String get onboardingCurrencyTitle => 'Base currency';

  @override
  String get onboardingCurrencySubtitle =>
      'All your accounts use this currency for now.';

  @override
  String get onboardingAccountTitle => 'Add your first account';

  @override
  String get onboardingAccountSubtitle =>
      'Give it a name and an optional opening balance.';

  @override
  String get onboardingFinish => 'Get started';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardWelcome => 'Welcome back';

  @override
  String get dashboardNetWorth => 'Net Worth';

  @override
  String get dashboardTotalAssets => 'Total Assets';

  @override
  String get dashboardTotalLiabilities => 'Total Liabilities';

  @override
  String get dashboardMonthlyIncome => 'Income this month';

  @override
  String get dashboardMonthlyExpense => 'Expenses this month';

  @override
  String get dashboardRecentTransactions => 'Recent transactions';

  @override
  String get dashboardViewAll => 'View all';

  @override
  String get dashboardEmptyTitle => 'Start tracking your wealth';

  @override
  String get dashboardEmptyMessage =>
      'Add your first transaction to see your balances and net worth here.';

  @override
  String get dashboardNoTransactions => 'No transactions yet.';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsAdd => 'Add account';

  @override
  String get accountsEmptyTitle => 'No accounts yet';

  @override
  String get accountsEmptyMessage =>
      'Add a cash, bank or wallet account to get started.';

  @override
  String get accountsCurrentBalance => 'Current balance';

  @override
  String get accountsOpeningBalance => 'Opening balance';

  @override
  String get accountsName => 'Account name';

  @override
  String get accountsType => 'Account type';

  @override
  String get accountsClassification => 'Classification';

  @override
  String get accountsInstitution => 'Institution (optional)';

  @override
  String get accountsLast4 => 'Last 4 digits (optional)';

  @override
  String get accountsArchive => 'Archive account';

  @override
  String get accountsUnarchive => 'Unarchive account';

  @override
  String get accountsArchived => 'Archived';

  @override
  String get accountsArchiveWarning =>
      'Archiving hides this account from lists. Its transactions and balances are kept. You can unarchive it any time.';

  @override
  String get accountsRecentActivity => 'Recent activity';

  @override
  String get accountsOwedAmount => 'Amount owed';

  @override
  String get accountsOutstandingBalance => 'Outstanding balance';

  @override
  String get classificationAsset => 'Asset';

  @override
  String get classificationLiability => 'Liability';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeWallet => 'Wallet';

  @override
  String get accountTypeCreditCard => 'Credit card';

  @override
  String get accountTypeInvestment => 'Investment';

  @override
  String get accountTypeAsset => 'Asset';

  @override
  String get accountTypeLoan => 'Loan';

  @override
  String get accountTypeOther => 'Other';

  @override
  String get transactionAdd => 'Add transaction';

  @override
  String get transactionTypeIncome => 'Income';

  @override
  String get transactionTypeExpense => 'Expense';

  @override
  String get transactionTypeTransfer => 'Transfer';

  @override
  String get transactionTypeAdjustment => 'Adjustment';

  @override
  String get transactionAccount => 'Account';

  @override
  String get transactionFromAccount => 'From account';

  @override
  String get transactionToAccount => 'To account';

  @override
  String get transactionCategory => 'Category';

  @override
  String get transactionSelectAccount => 'Select an account';

  @override
  String get transactionSelectCategory => 'Select a category';

  @override
  String get transactionAdjustmentReason => 'Reason for adjustment';

  @override
  String get transactionAdjustmentHint =>
      'Enter the real balance; we compute the correction. Adjustments are excluded from cash-flow reports.';

  @override
  String get transactionSaved => 'Transaction saved';

  @override
  String get transactionEdit => 'Edit transaction';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get transactionActualBalance => 'Actual balance';

  @override
  String get transactionCalculatedBalance => 'Current calculated balance';

  @override
  String get transactionDifference => 'Difference';

  @override
  String get transactionDetailsTitle => 'Transaction details';

  @override
  String get transactionStatusActive => 'Active';

  @override
  String get transactionStatusDeleted => 'Deleted';

  @override
  String get transactionEffect => 'Effect on accounts';

  @override
  String get transactionCreatedAt => 'Created';

  @override
  String get transactionUpdatedAt => 'Last updated';

  @override
  String get transactionDelete => 'Delete transaction';

  @override
  String get transactionDeleteConfirm =>
      'Delete this transaction? Balances will update. You can undo this.';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionRestore => 'Restore';

  @override
  String get transactionRestored => 'Transaction restored';

  @override
  String get semanticLiabilityCharge => 'Charge to liability';

  @override
  String get semanticLiabilityRepayment => 'Repayment';

  @override
  String get semanticLiabilityDrawdown => 'Liability draw-down';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Base currency';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsBiometricLock => 'Biometric lock';

  @override
  String get settingsBiometricSubtitle =>
      'Require Face ID or fingerprint to open the app.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get navDashboard => 'Home';

  @override
  String get navBudget => 'Budget';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetStatusDraft => 'Draft';

  @override
  String get budgetStatusActive => 'Active';

  @override
  String get budgetStatusClosed => 'Closed';

  @override
  String get budgetExpectedIncome => 'Expected income';

  @override
  String get budgetActualIncome => 'Actual income';

  @override
  String get budgetTotalAssigned => 'Total assigned';

  @override
  String get budgetAvailableToAssign => 'Available to assign';

  @override
  String get budgetActualExpense => 'Actual expense';

  @override
  String get budgetTotalRemaining => 'Total remaining';

  @override
  String get budgetOverspentCount => 'Overspent categories';

  @override
  String get budgetSectionIncomePlan => 'Income plan';

  @override
  String get budgetSectionExpense => 'Expenses';

  @override
  String get budgetSectionSavings => 'Savings';

  @override
  String get budgetSectionDebt => 'Debt payments';

  @override
  String get budgetItemAssigned => 'Assigned';

  @override
  String get budgetItemActual => 'Actual';

  @override
  String get budgetItemRemaining => 'Remaining';

  @override
  String get budgetItemOverspentBy => 'Overspent by';

  @override
  String get budgetItemPlanned => 'Planned';

  @override
  String get budgetItemVariance => 'Variance';

  @override
  String get budgetItemRolloverIn => 'Rolled in';

  @override
  String get budgetItemRolloverOut => 'Rolled out';

  @override
  String budgetItemUsage(int percent) {
    return '$percent% used';
  }

  @override
  String get budgetStatusNotStarted => 'Not started';

  @override
  String get budgetStatusOnTrack => 'On track';

  @override
  String get budgetStatusNearLimit => 'Near limit';

  @override
  String get budgetStatusOverspent => 'Overspent';

  @override
  String get budgetEmptyTitle => 'No budget for this month';

  @override
  String get budgetEmptyMessage =>
      'Create a monthly budget to plan your income and spending.';

  @override
  String get budgetCreateEmpty => 'Create empty budget';

  @override
  String get budgetCopyPrevious => 'Copy previous month';

  @override
  String get budgetCreateTitle => 'Create budget';

  @override
  String budgetCopiedSkipped(int count) {
    return '$count item(s) were skipped because their category or account is archived.';
  }

  @override
  String get budgetAddItem => 'Add item';

  @override
  String get budgetItemTypeExpense => 'Expense';

  @override
  String get budgetItemTypeSaving => 'Saving';

  @override
  String get budgetItemTypeDebt => 'Debt payment';

  @override
  String get budgetItemTypeIncome => 'Income plan';

  @override
  String get budgetItemName => 'Name';

  @override
  String get budgetAssignedAmount => 'Assigned amount';

  @override
  String get budgetExpectedAmount => 'Expected amount';

  @override
  String get budgetPlannedPayment => 'Planned payment';

  @override
  String get budgetRolloverEnabled => 'Roll over unused amount';

  @override
  String get budgetItemNotes => 'Notes';

  @override
  String get budgetSelectExpenseCategory => 'Expense category';

  @override
  String get budgetSelectIncomeCategory => 'Income category';

  @override
  String get budgetSelectLiability => 'Liability account';

  @override
  String get budgetItemDetailsTitle => 'Budget item';

  @override
  String get budgetContributingTransactions => 'Contributing transactions';

  @override
  String get budgetNoContributions => 'No contributing transactions yet.';

  @override
  String get budgetCloseMonth => 'Close month';

  @override
  String get budgetCloseTitle => 'Close this month';

  @override
  String get budgetCloseReview =>
      'Review the month, then choose which surpluses to carry forward.';

  @override
  String get budgetCloseSelectRollover => 'Carry forward';

  @override
  String get budgetCloseConfirm => 'Close month';

  @override
  String get budgetClosedBanner =>
      'This month is closed. Its results still reflect the latest transactions.';

  @override
  String get budgetReopen => 'Reopen month';

  @override
  String get budgetReopenConfirm => 'Reopen this closed month for editing?';

  @override
  String get budgetReadOnly =>
      'Budget items are read-only while the month is closed.';

  @override
  String get budgetDeleteItem => 'Delete item';

  @override
  String get budgetDeleteItemConfirm => 'Delete this budget item?';

  @override
  String get budgetItemSaved => 'Budget item saved';

  @override
  String get budgetSummaryCardTitle => 'This month\'s budget';

  @override
  String get budgetOpen => 'Open budget';

  @override
  String get budgetCreateCta => 'Create a budget for this month';

  @override
  String get budgetSavingPlanOnly =>
      'Planned (savings are shown as a plan only in this version).';

  @override
  String insightOverspent(String category) {
    return 'Over budget: $category';
  }

  @override
  String insightHighConsumption(String category) {
    return '80%+ used: $category';
  }

  @override
  String get insightNegativeAvailable =>
      'You have assigned more than your expected income.';

  @override
  String get insightIncomeBelowExpected =>
      'Actual income is below the expected amount.';

  @override
  String get insightClosedMonthChanged =>
      'A closed month\'s results changed after closing.';

  @override
  String get lockTitle => 'WealthOS is locked';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockReason => 'Authenticate to open WealthOS';

  @override
  String get errorRequired => 'This field is required.';

  @override
  String get errorInvalidAmount => 'Enter a valid amount.';

  @override
  String get errorAmountPositive => 'Amount must be greater than zero.';

  @override
  String get errorCurrencyMismatch =>
      'All accounts must use the base currency in this version.';

  @override
  String get errorSameAccountTransfer =>
      'Source and destination must be different accounts.';

  @override
  String get errorAccountRequired => 'Please choose an account.';

  @override
  String get errorDestinationRequired => 'Please choose a destination account.';

  @override
  String get errorCategoryRequired => 'Please choose a category.';

  @override
  String get errorAdjustmentReasonRequired =>
      'Please give a reason for the adjustment.';

  @override
  String get errorCategoryNotAllowed =>
      'A category can only be set on income or expense.';

  @override
  String get errorCategoryTypeMismatch =>
      'The category does not match the transaction type.';

  @override
  String get errorAccountArchived =>
      'This account is archived and cannot be used.';

  @override
  String get errorCategoryArchived =>
      'This category is archived and cannot be used.';

  @override
  String get errorAdjustmentNoChange =>
      'The balance is unchanged; no adjustment is needed.';

  @override
  String get errorAccountNotFound => 'Account not found.';

  @override
  String get errorCategoryNotFound => 'Category not found.';

  @override
  String get errorTransactionNotFound => 'Transaction not found.';

  @override
  String get errorBudgetAssignedNegative =>
      'The assigned amount cannot be negative.';

  @override
  String get errorBudgetCategoryRequired => 'Please choose a category.';

  @override
  String get errorBudgetLiabilityRequired =>
      'Please choose a liability account.';

  @override
  String get errorBudgetNotLiability =>
      'A debt payment must use a liability account.';

  @override
  String get errorBudgetDuplicateItem =>
      'This category or account already has a budget item.';

  @override
  String get errorBudgetHierarchyConflict =>
      'A parent or child category is already budgeted.';

  @override
  String get errorBudgetExists => 'A budget already exists for this month.';

  @override
  String get errorBudgetClosed =>
      'The month is closed. Reopen it to make changes.';

  @override
  String get errorBudgetItemLinkedRollover =>
      'This item has a linked roll-over and cannot be deleted.';

  @override
  String get errorBudgetNotFound => 'Budget not found.';

  @override
  String get errorBudgetItemNotFound => 'Budget item not found.';

  @override
  String get errorDatabase => 'A database error occurred.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';
}
