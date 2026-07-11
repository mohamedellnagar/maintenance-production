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
      'Adjustments correct a balance and are excluded from cash-flow reports.';

  @override
  String get transactionSaved => 'Transaction saved';

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
  String get errorAccountNotFound => 'Account not found.';

  @override
  String get errorDatabase => 'A database error occurred.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';
}
