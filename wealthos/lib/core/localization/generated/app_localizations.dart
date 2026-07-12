import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'WealthOS'**
  String get appName;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// No description provided for @commonNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get commonNote;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get onboardingLanguageSubtitle;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'All your accounts use this currency for now.'**
  String get onboardingCurrencySubtitle;

  /// No description provided for @onboardingAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first account'**
  String get onboardingAccountTitle;

  /// No description provided for @onboardingAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give it a name and an optional opening balance.'**
  String get onboardingAccountSubtitle;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingFinish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get dashboardWelcome;

  /// No description provided for @dashboardNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Net Worth'**
  String get dashboardNetWorth;

  /// No description provided for @dashboardTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get dashboardTotalAssets;

  /// No description provided for @dashboardTotalLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Total Liabilities'**
  String get dashboardTotalLiabilities;

  /// No description provided for @dashboardMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Income this month'**
  String get dashboardMonthlyIncome;

  /// No description provided for @dashboardMonthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses this month'**
  String get dashboardMonthlyExpense;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get dashboardRecentTransactions;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your wealth'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction to see your balances and net worth here.'**
  String get dashboardEmptyMessage;

  /// No description provided for @dashboardNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get dashboardNoTransactions;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @accountsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get accountsAdd;

  /// No description provided for @accountsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get accountsEmptyTitle;

  /// No description provided for @accountsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a cash, bank or wallet account to get started.'**
  String get accountsEmptyMessage;

  /// No description provided for @accountsCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get accountsCurrentBalance;

  /// No description provided for @accountsOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get accountsOpeningBalance;

  /// No description provided for @accountsName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountsName;

  /// No description provided for @accountsType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get accountsType;

  /// No description provided for @accountsClassification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get accountsClassification;

  /// No description provided for @accountsInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution (optional)'**
  String get accountsInstitution;

  /// No description provided for @accountsLast4.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits (optional)'**
  String get accountsLast4;

  /// No description provided for @accountsArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive account'**
  String get accountsArchive;

  /// No description provided for @accountsUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive account'**
  String get accountsUnarchive;

  /// No description provided for @accountsArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get accountsArchived;

  /// No description provided for @accountsArchiveWarning.
  ///
  /// In en, this message translates to:
  /// **'Archiving hides this account from lists. Its transactions and balances are kept. You can unarchive it any time.'**
  String get accountsArchiveWarning;

  /// No description provided for @accountsRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get accountsRecentActivity;

  /// No description provided for @accountsOwedAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount owed'**
  String get accountsOwedAmount;

  /// No description provided for @accountsOutstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance'**
  String get accountsOutstandingBalance;

  /// No description provided for @classificationAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get classificationAsset;

  /// No description provided for @classificationLiability.
  ///
  /// In en, this message translates to:
  /// **'Liability'**
  String get classificationLiability;

  /// No description provided for @accountTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountTypeCash;

  /// No description provided for @accountTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountTypeBank;

  /// No description provided for @accountTypeWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get accountTypeWallet;

  /// No description provided for @accountTypeCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get accountTypeCreditCard;

  /// No description provided for @accountTypeInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get accountTypeInvestment;

  /// No description provided for @accountTypeAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get accountTypeAsset;

  /// No description provided for @accountTypeLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get accountTypeLoan;

  /// No description provided for @accountTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get accountTypeOther;

  /// No description provided for @transactionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get transactionAdd;

  /// No description provided for @transactionTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionTypeIncome;

  /// No description provided for @transactionTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionTypeExpense;

  /// No description provided for @transactionTypeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transactionTypeTransfer;

  /// No description provided for @transactionTypeAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get transactionTypeAdjustment;

  /// No description provided for @transactionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get transactionAccount;

  /// No description provided for @transactionFromAccount.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get transactionFromAccount;

  /// No description provided for @transactionToAccount.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get transactionToAccount;

  /// No description provided for @transactionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCategory;

  /// No description provided for @transactionSelectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select an account'**
  String get transactionSelectAccount;

  /// No description provided for @transactionSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get transactionSelectCategory;

  /// No description provided for @transactionAdjustmentReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for adjustment'**
  String get transactionAdjustmentReason;

  /// No description provided for @transactionAdjustmentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the real balance; we compute the correction. Adjustments are excluded from cash-flow reports.'**
  String get transactionAdjustmentHint;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionSaved;

  /// No description provided for @transactionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get transactionEdit;

  /// No description provided for @transactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// No description provided for @transactionActualBalance.
  ///
  /// In en, this message translates to:
  /// **'Actual balance'**
  String get transactionActualBalance;

  /// No description provided for @transactionCalculatedBalance.
  ///
  /// In en, this message translates to:
  /// **'Current calculated balance'**
  String get transactionCalculatedBalance;

  /// No description provided for @transactionDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get transactionDifference;

  /// No description provided for @transactionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetailsTitle;

  /// No description provided for @transactionStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get transactionStatusActive;

  /// No description provided for @transactionStatusDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get transactionStatusDeleted;

  /// No description provided for @transactionEffect.
  ///
  /// In en, this message translates to:
  /// **'Effect on accounts'**
  String get transactionEffect;

  /// No description provided for @transactionCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get transactionCreatedAt;

  /// No description provided for @transactionUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get transactionUpdatedAt;

  /// No description provided for @transactionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get transactionDelete;

  /// No description provided for @transactionDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction? Balances will update. You can undo this.'**
  String get transactionDeleteConfirm;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get transactionRestore;

  /// No description provided for @transactionRestored.
  ///
  /// In en, this message translates to:
  /// **'Transaction restored'**
  String get transactionRestored;

  /// No description provided for @semanticLiabilityCharge.
  ///
  /// In en, this message translates to:
  /// **'Charge to liability'**
  String get semanticLiabilityCharge;

  /// No description provided for @semanticLiabilityRepayment.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get semanticLiabilityRepayment;

  /// No description provided for @semanticLiabilityDrawdown.
  ///
  /// In en, this message translates to:
  /// **'Liability draw-down'**
  String get semanticLiabilityDrawdown;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get settingsCurrency;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get settingsBiometricLock;

  /// No description provided for @settingsBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require Face ID or fingerprint to open the app.'**
  String get settingsBiometricSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get navRecurring;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreSectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get moreSectionTools;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringTitle;

  /// No description provided for @recurringDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get recurringDueToday;

  /// No description provided for @recurringOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get recurringOverdue;

  /// No description provided for @recurringUpcoming7.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get recurringUpcoming7;

  /// No description provided for @recurringUpcoming30.
  ///
  /// In en, this message translates to:
  /// **'Next 30 days'**
  String get recurringUpcoming30;

  /// No description provided for @recurringActiveRules.
  ///
  /// In en, this message translates to:
  /// **'Active rules'**
  String get recurringActiveRules;

  /// No description provided for @recurringPlannedIncome.
  ///
  /// In en, this message translates to:
  /// **'Planned income (upcoming)'**
  String get recurringPlannedIncome;

  /// No description provided for @recurringPlannedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Planned expenses & payments (upcoming)'**
  String get recurringPlannedExpenses;

  /// No description provided for @recurringPlannedNote.
  ///
  /// In en, this message translates to:
  /// **'Scheduled — not actual cash flow.'**
  String get recurringPlannedNote;

  /// No description provided for @recurringEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recurring items yet'**
  String get recurringEmptyTitle;

  /// No description provided for @recurringEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a rule for salaries, rent, subscriptions or loan payments.'**
  String get recurringEmptyMessage;

  /// No description provided for @recurringAddRule.
  ///
  /// In en, this message translates to:
  /// **'Add recurring'**
  String get recurringAddRule;

  /// No description provided for @recurringNoOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled here.'**
  String get recurringNoOccurrences;

  /// No description provided for @recurringTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get recurringTypeIncome;

  /// No description provided for @recurringTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get recurringTypeExpense;

  /// No description provided for @recurringTypeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get recurringTypeTransfer;

  /// No description provided for @recurringTypeLiabilityPayment.
  ///
  /// In en, this message translates to:
  /// **'Debt payment'**
  String get recurringTypeLiabilityPayment;

  /// No description provided for @recurringFreqDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurringFreqDaily;

  /// No description provided for @recurringFreqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringFreqWeekly;

  /// No description provided for @recurringFreqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringFreqMonthly;

  /// No description provided for @recurringFreqYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurringFreqYearly;

  /// No description provided for @recurringFreqCustomInterval.
  ///
  /// In en, this message translates to:
  /// **'Every N days'**
  String get recurringFreqCustomInterval;

  /// No description provided for @occStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get occStatusScheduled;

  /// No description provided for @occStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get occStatusDue;

  /// No description provided for @occStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get occStatusOverdue;

  /// No description provided for @occStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get occStatusPaid;

  /// No description provided for @occStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get occStatusSkipped;

  /// No description provided for @occStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get occStatusCancelled;

  /// No description provided for @recurringName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get recurringName;

  /// No description provided for @recurringAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringAmount;

  /// No description provided for @recurringType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get recurringType;

  /// No description provided for @recurringSourceAccount.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get recurringSourceAccount;

  /// No description provided for @recurringDestinationAccount.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get recurringDestinationAccount;

  /// No description provided for @recurringCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get recurringCategory;

  /// No description provided for @recurringFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get recurringFrequency;

  /// No description provided for @recurringInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get recurringInterval;

  /// No description provided for @recurringWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Days of the week'**
  String get recurringWeekdays;

  /// No description provided for @recurringMonthlyMode.
  ///
  /// In en, this message translates to:
  /// **'Monthly on'**
  String get recurringMonthlyMode;

  /// No description provided for @recurringMonthlyByDay.
  ///
  /// In en, this message translates to:
  /// **'A day of the month'**
  String get recurringMonthlyByDay;

  /// No description provided for @recurringMonthlyByWeekday.
  ///
  /// In en, this message translates to:
  /// **'A weekday'**
  String get recurringMonthlyByWeekday;

  /// No description provided for @recurringMonthlyDay.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get recurringMonthlyDay;

  /// No description provided for @recurringOrdinal.
  ///
  /// In en, this message translates to:
  /// **'Which'**
  String get recurringOrdinal;

  /// No description provided for @recurringWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get recurringWeekday;

  /// No description provided for @recurringYearlyMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get recurringYearlyMonth;

  /// No description provided for @recurringYearlyDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get recurringYearlyDay;

  /// No description provided for @recurringStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get recurringStartDate;

  /// No description provided for @recurringEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get recurringEndDate;

  /// No description provided for @recurringMaxOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Max occurrences'**
  String get recurringMaxOccurrences;

  /// No description provided for @recurringReminderDays.
  ///
  /// In en, this message translates to:
  /// **'Remind days before'**
  String get recurringReminderDays;

  /// No description provided for @recurringAutoCreate.
  ///
  /// In en, this message translates to:
  /// **'Create automatically when due'**
  String get recurringAutoCreate;

  /// No description provided for @recurringNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get recurringNotes;

  /// No description provided for @recurringSelectAsset.
  ///
  /// In en, this message translates to:
  /// **'Choose an asset account'**
  String get recurringSelectAsset;

  /// No description provided for @recurringSelectLiability.
  ///
  /// In en, this message translates to:
  /// **'Choose a liability account'**
  String get recurringSelectLiability;

  /// No description provided for @recurringSaved.
  ///
  /// In en, this message translates to:
  /// **'Recurring rule saved'**
  String get recurringSaved;

  /// No description provided for @recurringRuleDetails.
  ///
  /// In en, this message translates to:
  /// **'Recurring rule'**
  String get recurringRuleDetails;

  /// No description provided for @recurringNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get recurringNextDue;

  /// No description provided for @recurringCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get recurringCompletedCount;

  /// No description provided for @recurringOverdueCount.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get recurringOverdueCount;

  /// No description provided for @recurringRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recurringRecentTransactions;

  /// No description provided for @recurringPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get recurringPause;

  /// No description provided for @recurringResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get recurringResume;

  /// No description provided for @recurringEnd.
  ///
  /// In en, this message translates to:
  /// **'End rule'**
  String get recurringEnd;

  /// No description provided for @recurringEndConfirm.
  ///
  /// In en, this message translates to:
  /// **'End this rule? Future occurrences stop; history is kept.'**
  String get recurringEndConfirm;

  /// No description provided for @recurringDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this rule? Only possible when nothing has been posted.'**
  String get recurringDeleteConfirm;

  /// No description provided for @recurringPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get recurringPaused;

  /// No description provided for @recurringActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get recurringActive;

  /// No description provided for @recurringEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get recurringEnded;

  /// No description provided for @recurringArchivedWarning.
  ///
  /// In en, this message translates to:
  /// **'This rule uses an archived account or category.'**
  String get recurringArchivedWarning;

  /// No description provided for @ordinalFirst.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get ordinalFirst;

  /// No description provided for @ordinalSecond.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get ordinalSecond;

  /// No description provided for @ordinalThird.
  ///
  /// In en, this message translates to:
  /// **'Third'**
  String get ordinalThird;

  /// No description provided for @ordinalFourth.
  ///
  /// In en, this message translates to:
  /// **'Fourth'**
  String get ordinalFourth;

  /// No description provided for @ordinalLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get ordinalLast;

  /// No description provided for @occurrenceDetails.
  ///
  /// In en, this message translates to:
  /// **'Occurrence'**
  String get occurrenceDetails;

  /// No description provided for @occExpectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Expected amount'**
  String get occExpectedAmount;

  /// No description provided for @occOriginalDate.
  ///
  /// In en, this message translates to:
  /// **'Original date'**
  String get occOriginalDate;

  /// No description provided for @occSnoozedDate.
  ///
  /// In en, this message translates to:
  /// **'Snoozed to'**
  String get occSnoozedDate;

  /// No description provided for @occMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get occMarkPaid;

  /// No description provided for @occMarkReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark as received'**
  String get occMarkReceived;

  /// No description provided for @occSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get occSnooze;

  /// No description provided for @occSnooze1Week.
  ///
  /// In en, this message translates to:
  /// **'Snooze 1 week'**
  String get occSnooze1Week;

  /// No description provided for @occSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get occSkip;

  /// No description provided for @occSkipConfirm.
  ///
  /// In en, this message translates to:
  /// **'Skip only this occurrence? The schedule continues.'**
  String get occSkipConfirm;

  /// No description provided for @occSkipReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get occSkipReason;

  /// No description provided for @occLinkedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Linked transaction'**
  String get occLinkedTransaction;

  /// No description provided for @occPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted to a transaction'**
  String get occPosted;

  /// No description provided for @occSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Occurrence snoozed'**
  String get occSnoozed;

  /// No description provided for @occSkippedMsg.
  ///
  /// In en, this message translates to:
  /// **'Occurrence skipped'**
  String get occSkippedMsg;

  /// No description provided for @occEditBeforePosting.
  ///
  /// In en, this message translates to:
  /// **'Edit before posting'**
  String get occEditBeforePosting;

  /// No description provided for @recurrenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get recurrenceDaily;

  /// No description provided for @recurrenceEveryNDays.
  ///
  /// In en, this message translates to:
  /// **'Every {count} days'**
  String recurrenceEveryNDays(int count);

  /// No description provided for @recurrenceWeeklyOn.
  ///
  /// In en, this message translates to:
  /// **'Weekly on {days}'**
  String recurrenceWeeklyOn(String days);

  /// No description provided for @recurrenceEveryNWeeksOn.
  ///
  /// In en, this message translates to:
  /// **'Every {count} weeks on {days}'**
  String recurrenceEveryNWeeksOn(int count, String days);

  /// No description provided for @recurrenceMonthlyDayText.
  ///
  /// In en, this message translates to:
  /// **'Monthly on day {day}'**
  String recurrenceMonthlyDayText(int day);

  /// No description provided for @recurrenceMonthlyOrdinalText.
  ///
  /// In en, this message translates to:
  /// **'Monthly on the {ordinal} {weekday}'**
  String recurrenceMonthlyOrdinalText(String ordinal, String weekday);

  /// No description provided for @recurrenceYearlyText.
  ///
  /// In en, this message translates to:
  /// **'Yearly on {date}'**
  String recurrenceYearlyText(String date);

  /// No description provided for @dashboardUpcomingBills.
  ///
  /// In en, this message translates to:
  /// **'Upcoming bills'**
  String get dashboardUpcomingBills;

  /// No description provided for @recurringViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get recurringViewAll;

  /// No description provided for @recurringNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bills.'**
  String get recurringNoUpcoming;

  /// No description provided for @budgetUpcomingRecurring.
  ///
  /// In en, this message translates to:
  /// **'Upcoming recurring'**
  String get budgetUpcomingRecurring;

  /// No description provided for @budgetUpcomingRecurringNote.
  ///
  /// In en, this message translates to:
  /// **'Planned, not yet posted. Does not affect actual spending or balances.'**
  String get budgetUpcomingRecurringNote;

  /// No description provided for @settingsAutoCreateRecurring.
  ///
  /// In en, this message translates to:
  /// **'Auto-create recurring transactions'**
  String get settingsAutoCreateRecurring;

  /// No description provided for @settingsAutoCreateRecurringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When a rule is due, post it automatically. Off by default.'**
  String get settingsAutoCreateRecurringSubtitle;

  /// No description provided for @insightBillOverdue.
  ///
  /// In en, this message translates to:
  /// **'You have an overdue bill.'**
  String get insightBillOverdue;

  /// No description provided for @insightMultipleDueToday.
  ///
  /// In en, this message translates to:
  /// **'More than one bill is due today.'**
  String get insightMultipleDueToday;

  /// No description provided for @insightIncomeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Expected income is due soon.'**
  String get insightIncomeUpcoming;

  /// No description provided for @insightAutoCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'A recurring auto-post could not be created.'**
  String get insightAutoCreateFailed;

  /// No description provided for @insightRecurringArchived.
  ///
  /// In en, this message translates to:
  /// **'A recurring rule uses an archived account or category.'**
  String get insightRecurringArchived;

  /// No description provided for @insightManyUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Several recurring occurrences are unpaid.'**
  String get insightManyUnpaid;

  /// No description provided for @budgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetTitle;

  /// No description provided for @budgetStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get budgetStatusDraft;

  /// No description provided for @budgetStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get budgetStatusActive;

  /// No description provided for @budgetStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get budgetStatusClosed;

  /// No description provided for @budgetExpectedIncome.
  ///
  /// In en, this message translates to:
  /// **'Expected income'**
  String get budgetExpectedIncome;

  /// No description provided for @budgetActualIncome.
  ///
  /// In en, this message translates to:
  /// **'Actual income'**
  String get budgetActualIncome;

  /// No description provided for @budgetTotalAssigned.
  ///
  /// In en, this message translates to:
  /// **'Total assigned'**
  String get budgetTotalAssigned;

  /// No description provided for @budgetAvailableToAssign.
  ///
  /// In en, this message translates to:
  /// **'Available to assign'**
  String get budgetAvailableToAssign;

  /// No description provided for @budgetActualExpense.
  ///
  /// In en, this message translates to:
  /// **'Actual expense'**
  String get budgetActualExpense;

  /// No description provided for @budgetTotalRemaining.
  ///
  /// In en, this message translates to:
  /// **'Total remaining'**
  String get budgetTotalRemaining;

  /// No description provided for @budgetOverspentCount.
  ///
  /// In en, this message translates to:
  /// **'Overspent categories'**
  String get budgetOverspentCount;

  /// No description provided for @budgetSectionIncomePlan.
  ///
  /// In en, this message translates to:
  /// **'Income plan'**
  String get budgetSectionIncomePlan;

  /// No description provided for @budgetSectionExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get budgetSectionExpense;

  /// No description provided for @budgetSectionSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get budgetSectionSavings;

  /// No description provided for @budgetSectionDebt.
  ///
  /// In en, this message translates to:
  /// **'Debt payments'**
  String get budgetSectionDebt;

  /// No description provided for @budgetItemAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get budgetItemAssigned;

  /// No description provided for @budgetItemActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get budgetItemActual;

  /// No description provided for @budgetItemRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budgetItemRemaining;

  /// No description provided for @budgetItemOverspentBy.
  ///
  /// In en, this message translates to:
  /// **'Overspent by'**
  String get budgetItemOverspentBy;

  /// No description provided for @budgetItemPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get budgetItemPlanned;

  /// No description provided for @budgetItemVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get budgetItemVariance;

  /// No description provided for @budgetItemRolloverIn.
  ///
  /// In en, this message translates to:
  /// **'Rolled in'**
  String get budgetItemRolloverIn;

  /// No description provided for @budgetItemRolloverOut.
  ///
  /// In en, this message translates to:
  /// **'Rolled out'**
  String get budgetItemRolloverOut;

  /// No description provided for @budgetItemUsage.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String budgetItemUsage(int percent);

  /// No description provided for @budgetStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get budgetStatusNotStarted;

  /// No description provided for @budgetStatusOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get budgetStatusOnTrack;

  /// No description provided for @budgetStatusNearLimit.
  ///
  /// In en, this message translates to:
  /// **'Near limit'**
  String get budgetStatusNearLimit;

  /// No description provided for @budgetStatusOverspent.
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get budgetStatusOverspent;

  /// No description provided for @budgetEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No budget for this month'**
  String get budgetEmptyTitle;

  /// No description provided for @budgetEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a monthly budget to plan your income and spending.'**
  String get budgetEmptyMessage;

  /// No description provided for @budgetCreateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Create empty budget'**
  String get budgetCreateEmpty;

  /// No description provided for @budgetCopyPrevious.
  ///
  /// In en, this message translates to:
  /// **'Copy previous month'**
  String get budgetCopyPrevious;

  /// No description provided for @budgetCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create budget'**
  String get budgetCreateTitle;

  /// No description provided for @budgetCopiedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) were skipped because their category or account is archived.'**
  String budgetCopiedSkipped(int count);

  /// No description provided for @budgetAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get budgetAddItem;

  /// No description provided for @budgetItemTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get budgetItemTypeExpense;

  /// No description provided for @budgetItemTypeSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get budgetItemTypeSaving;

  /// No description provided for @budgetItemTypeDebt.
  ///
  /// In en, this message translates to:
  /// **'Debt payment'**
  String get budgetItemTypeDebt;

  /// No description provided for @budgetItemTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income plan'**
  String get budgetItemTypeIncome;

  /// No description provided for @budgetItemName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get budgetItemName;

  /// No description provided for @budgetAssignedAmount.
  ///
  /// In en, this message translates to:
  /// **'Assigned amount'**
  String get budgetAssignedAmount;

  /// No description provided for @budgetExpectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Expected amount'**
  String get budgetExpectedAmount;

  /// No description provided for @budgetPlannedPayment.
  ///
  /// In en, this message translates to:
  /// **'Planned payment'**
  String get budgetPlannedPayment;

  /// No description provided for @budgetRolloverEnabled.
  ///
  /// In en, this message translates to:
  /// **'Roll over unused amount'**
  String get budgetRolloverEnabled;

  /// No description provided for @budgetItemNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get budgetItemNotes;

  /// No description provided for @budgetSelectExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense category'**
  String get budgetSelectExpenseCategory;

  /// No description provided for @budgetSelectIncomeCategory.
  ///
  /// In en, this message translates to:
  /// **'Income category'**
  String get budgetSelectIncomeCategory;

  /// No description provided for @budgetSelectLiability.
  ///
  /// In en, this message translates to:
  /// **'Liability account'**
  String get budgetSelectLiability;

  /// No description provided for @budgetItemDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget item'**
  String get budgetItemDetailsTitle;

  /// No description provided for @budgetContributingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Contributing transactions'**
  String get budgetContributingTransactions;

  /// No description provided for @budgetNoContributions.
  ///
  /// In en, this message translates to:
  /// **'No contributing transactions yet.'**
  String get budgetNoContributions;

  /// No description provided for @budgetCloseMonth.
  ///
  /// In en, this message translates to:
  /// **'Close month'**
  String get budgetCloseMonth;

  /// No description provided for @budgetCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close this month'**
  String get budgetCloseTitle;

  /// No description provided for @budgetCloseReview.
  ///
  /// In en, this message translates to:
  /// **'Review the month, then choose which surpluses to carry forward.'**
  String get budgetCloseReview;

  /// No description provided for @budgetCloseSelectRollover.
  ///
  /// In en, this message translates to:
  /// **'Carry forward'**
  String get budgetCloseSelectRollover;

  /// No description provided for @budgetCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close month'**
  String get budgetCloseConfirm;

  /// No description provided for @budgetClosedBanner.
  ///
  /// In en, this message translates to:
  /// **'This month is closed. Its results still reflect the latest transactions.'**
  String get budgetClosedBanner;

  /// No description provided for @budgetReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen month'**
  String get budgetReopen;

  /// No description provided for @budgetReopenConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reopen this closed month for editing?'**
  String get budgetReopenConfirm;

  /// No description provided for @budgetReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Budget items are read-only while the month is closed.'**
  String get budgetReadOnly;

  /// No description provided for @budgetDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get budgetDeleteItem;

  /// No description provided for @budgetDeleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this budget item?'**
  String get budgetDeleteItemConfirm;

  /// No description provided for @budgetItemSaved.
  ///
  /// In en, this message translates to:
  /// **'Budget item saved'**
  String get budgetItemSaved;

  /// No description provided for @budgetSummaryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'This month\'s budget'**
  String get budgetSummaryCardTitle;

  /// No description provided for @budgetOpen.
  ///
  /// In en, this message translates to:
  /// **'Open budget'**
  String get budgetOpen;

  /// No description provided for @budgetCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create a budget for this month'**
  String get budgetCreateCta;

  /// No description provided for @budgetSavingPlanOnly.
  ///
  /// In en, this message translates to:
  /// **'Planned (savings are shown as a plan only in this version).'**
  String get budgetSavingPlanOnly;

  /// No description provided for @insightOverspent.
  ///
  /// In en, this message translates to:
  /// **'Over budget: {category}'**
  String insightOverspent(String category);

  /// No description provided for @insightHighConsumption.
  ///
  /// In en, this message translates to:
  /// **'80%+ used: {category}'**
  String insightHighConsumption(String category);

  /// No description provided for @insightNegativeAvailable.
  ///
  /// In en, this message translates to:
  /// **'You have assigned more than your expected income.'**
  String get insightNegativeAvailable;

  /// No description provided for @insightIncomeBelowExpected.
  ///
  /// In en, this message translates to:
  /// **'Actual income is below the expected amount.'**
  String get insightIncomeBelowExpected;

  /// No description provided for @insightClosedMonthChanged.
  ///
  /// In en, this message translates to:
  /// **'A closed month\'s results changed after closing.'**
  String get insightClosedMonthChanged;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'WealthOS is locked'**
  String get lockTitle;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @lockReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to open WealthOS'**
  String get lockReason;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get errorRequired;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get errorInvalidAmount;

  /// No description provided for @errorAmountPositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get errorAmountPositive;

  /// No description provided for @errorCurrencyMismatch.
  ///
  /// In en, this message translates to:
  /// **'All accounts must use the base currency in this version.'**
  String get errorCurrencyMismatch;

  /// No description provided for @errorSameAccountTransfer.
  ///
  /// In en, this message translates to:
  /// **'Source and destination must be different accounts.'**
  String get errorSameAccountTransfer;

  /// No description provided for @errorAccountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose an account.'**
  String get errorAccountRequired;

  /// No description provided for @errorDestinationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a destination account.'**
  String get errorDestinationRequired;

  /// No description provided for @errorCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a category.'**
  String get errorCategoryRequired;

  /// No description provided for @errorAdjustmentReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please give a reason for the adjustment.'**
  String get errorAdjustmentReasonRequired;

  /// No description provided for @errorCategoryNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'A category can only be set on income or expense.'**
  String get errorCategoryNotAllowed;

  /// No description provided for @errorCategoryTypeMismatch.
  ///
  /// In en, this message translates to:
  /// **'The category does not match the transaction type.'**
  String get errorCategoryTypeMismatch;

  /// No description provided for @errorAccountArchived.
  ///
  /// In en, this message translates to:
  /// **'This account is archived and cannot be used.'**
  String get errorAccountArchived;

  /// No description provided for @errorCategoryArchived.
  ///
  /// In en, this message translates to:
  /// **'This category is archived and cannot be used.'**
  String get errorCategoryArchived;

  /// No description provided for @errorAdjustmentNoChange.
  ///
  /// In en, this message translates to:
  /// **'The balance is unchanged; no adjustment is needed.'**
  String get errorAdjustmentNoChange;

  /// No description provided for @errorAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get errorAccountNotFound;

  /// No description provided for @errorCategoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get errorCategoryNotFound;

  /// No description provided for @errorTransactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get errorTransactionNotFound;

  /// No description provided for @errorBudgetAssignedNegative.
  ///
  /// In en, this message translates to:
  /// **'The assigned amount cannot be negative.'**
  String get errorBudgetAssignedNegative;

  /// No description provided for @errorBudgetCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a category.'**
  String get errorBudgetCategoryRequired;

  /// No description provided for @errorBudgetLiabilityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a liability account.'**
  String get errorBudgetLiabilityRequired;

  /// No description provided for @errorBudgetNotLiability.
  ///
  /// In en, this message translates to:
  /// **'A debt payment must use a liability account.'**
  String get errorBudgetNotLiability;

  /// No description provided for @errorBudgetDuplicateItem.
  ///
  /// In en, this message translates to:
  /// **'This category or account already has a budget item.'**
  String get errorBudgetDuplicateItem;

  /// No description provided for @errorBudgetHierarchyConflict.
  ///
  /// In en, this message translates to:
  /// **'A parent or child category is already budgeted.'**
  String get errorBudgetHierarchyConflict;

  /// No description provided for @errorBudgetExists.
  ///
  /// In en, this message translates to:
  /// **'A budget already exists for this month.'**
  String get errorBudgetExists;

  /// No description provided for @errorBudgetClosed.
  ///
  /// In en, this message translates to:
  /// **'The month is closed. Reopen it to make changes.'**
  String get errorBudgetClosed;

  /// No description provided for @errorBudgetItemLinkedRollover.
  ///
  /// In en, this message translates to:
  /// **'This item has a linked roll-over and cannot be deleted.'**
  String get errorBudgetItemLinkedRollover;

  /// No description provided for @errorBudgetNotFound.
  ///
  /// In en, this message translates to:
  /// **'Budget not found.'**
  String get errorBudgetNotFound;

  /// No description provided for @errorBudgetItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Budget item not found.'**
  String get errorBudgetItemNotFound;

  /// No description provided for @errorRecurringWeekdayRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one weekday.'**
  String get errorRecurringWeekdayRequired;

  /// No description provided for @errorRecurringInvalidSchedule.
  ///
  /// In en, this message translates to:
  /// **'The schedule is incomplete or invalid.'**
  String get errorRecurringInvalidSchedule;

  /// No description provided for @errorRecurringEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end date cannot be before the start date.'**
  String get errorRecurringEndBeforeStart;

  /// No description provided for @errorRecurringMaxInvalid.
  ///
  /// In en, this message translates to:
  /// **'Max occurrences must be greater than zero.'**
  String get errorRecurringMaxInvalid;

  /// No description provided for @errorRecurringReminderInvalid.
  ///
  /// In en, this message translates to:
  /// **'Reminder days cannot be negative.'**
  String get errorRecurringReminderInvalid;

  /// No description provided for @errorRecurringIntervalInvalid.
  ///
  /// In en, this message translates to:
  /// **'The interval must be at least 1.'**
  String get errorRecurringIntervalInvalid;

  /// No description provided for @errorRecurringNotLiability.
  ///
  /// In en, this message translates to:
  /// **'A debt payment must go from an asset to a liability account.'**
  String get errorRecurringNotLiability;

  /// No description provided for @errorOccurrenceAlreadyPosted.
  ///
  /// In en, this message translates to:
  /// **'This occurrence is already posted.'**
  String get errorOccurrenceAlreadyPosted;

  /// No description provided for @errorOccurrenceNotOpen.
  ///
  /// In en, this message translates to:
  /// **'This occurrence cannot be posted.'**
  String get errorOccurrenceNotOpen;

  /// No description provided for @errorRuleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recurring rule not found.'**
  String get errorRuleNotFound;

  /// No description provided for @errorOccurrenceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Occurrence not found.'**
  String get errorOccurrenceNotFound;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsTitle;

  /// No description provided for @goalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No goals yet'**
  String get goalsEmptyTitle;

  /// No description provided for @goalsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a goal to start saving toward what matters.'**
  String get goalsEmptyMessage;

  /// No description provided for @goalAdd.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalAdd;

  /// No description provided for @goalsSummaryTotalTarget.
  ///
  /// In en, this message translates to:
  /// **'Total target'**
  String get goalsSummaryTotalTarget;

  /// No description provided for @goalsSummaryAllocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get goalsSummaryAllocated;

  /// No description provided for @goalsSummaryRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get goalsSummaryRemaining;

  /// No description provided for @goalsSummaryUnallocated.
  ///
  /// In en, this message translates to:
  /// **'Unallocated'**
  String get goalsSummaryUnallocated;

  /// No description provided for @goalsSummaryActive.
  ///
  /// In en, this message translates to:
  /// **'Active goals'**
  String get goalsSummaryActive;

  /// No description provided for @goalsSummaryBehind.
  ///
  /// In en, this message translates to:
  /// **'Behind plan'**
  String get goalsSummaryBehind;

  /// No description provided for @goalsSummaryNearest.
  ///
  /// In en, this message translates to:
  /// **'Closest to done'**
  String get goalsSummaryNearest;

  /// No description provided for @goalsShortfallWarning.
  ///
  /// In en, this message translates to:
  /// **'Allocated funds now exceed your eligible liquid balance.'**
  String get goalsShortfallWarning;

  /// No description provided for @goalsShortfallNote.
  ///
  /// In en, this message translates to:
  /// **'Allocations are virtual earmarks and don\'t reserve money at the bank.'**
  String get goalsShortfallNote;

  /// No description provided for @goalsSectionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get goalsSectionActive;

  /// No description provided for @goalsSectionPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get goalsSectionPaused;

  /// No description provided for @goalsSectionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalsSectionCompleted;

  /// No description provided for @goalsSectionArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get goalsSectionArchived;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get goalTarget;

  /// No description provided for @goalFunded.
  ///
  /// In en, this message translates to:
  /// **'Funded'**
  String get goalFunded;

  /// No description provided for @goalRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get goalRemaining;

  /// No description provided for @goalOverfunded.
  ///
  /// In en, this message translates to:
  /// **'Overfunded'**
  String get goalOverfunded;

  /// No description provided for @goalRequiredMonthly.
  ///
  /// In en, this message translates to:
  /// **'Needed / month'**
  String get goalRequiredMonthly;

  /// No description provided for @goalProjectedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Projected completion'**
  String get goalProjectedCompletion;

  /// No description provided for @goalProjectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t estimate yet'**
  String get goalProjectionUnavailable;

  /// No description provided for @goalPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get goalPriority;

  /// No description provided for @goalTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get goalTargetDate;

  /// No description provided for @goalNoTargetDate.
  ///
  /// In en, this message translates to:
  /// **'No target date'**
  String get goalNoTargetDate;

  /// No description provided for @goalSavedForRepayment.
  ///
  /// In en, this message translates to:
  /// **'Saved for repayment'**
  String get goalSavedForRepayment;

  /// No description provided for @goalActualDebtReduced.
  ///
  /// In en, this message translates to:
  /// **'Actual debt reduced'**
  String get goalActualDebtReduced;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get goalName;

  /// No description provided for @goalType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get goalType;

  /// No description provided for @goalAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalAmount;

  /// No description provided for @goalLinkedLiability.
  ///
  /// In en, this message translates to:
  /// **'Debt to pay off'**
  String get goalLinkedLiability;

  /// No description provided for @goalSelectLiability.
  ///
  /// In en, this message translates to:
  /// **'Select a liability account'**
  String get goalSelectLiability;

  /// No description provided for @goalInitialAllocation.
  ///
  /// In en, this message translates to:
  /// **'Initial allocation'**
  String get goalInitialAllocation;

  /// No description provided for @goalNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get goalNotes;

  /// No description provided for @goalReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get goalReview;

  /// No description provided for @goalContribution.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get goalContribution;

  /// No description provided for @goalContributionAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to allocate'**
  String get goalContributionAmount;

  /// No description provided for @goalWithdrawAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to withdraw'**
  String get goalWithdrawAmount;

  /// No description provided for @goalTransferAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to transfer'**
  String get goalTransferAmount;

  /// No description provided for @goalTransferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to'**
  String get goalTransferTo;

  /// No description provided for @goalReason.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get goalReason;

  /// No description provided for @goalAvailableToAllocate.
  ///
  /// In en, this message translates to:
  /// **'Available to allocate'**
  String get goalAvailableToAllocate;

  /// No description provided for @goalAddContribution.
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get goalAddContribution;

  /// No description provided for @goalWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get goalWithdraw;

  /// No description provided for @goalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get goalTransfer;

  /// No description provided for @goalPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get goalPause;

  /// No description provided for @goalResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get goalResume;

  /// No description provided for @goalComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark complete'**
  String get goalComplete;

  /// No description provided for @goalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel goal'**
  String get goalCancel;

  /// No description provided for @goalArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get goalArchive;

  /// No description provided for @goalConfirmComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark this goal as complete?'**
  String get goalConfirmComplete;

  /// No description provided for @goalConfirmCancelWithBalance.
  ///
  /// In en, this message translates to:
  /// **'This goal still holds allocated money. Choose what to do with it.'**
  String get goalConfirmCancelWithBalance;

  /// No description provided for @goalCancelUnallocate.
  ///
  /// In en, this message translates to:
  /// **'Unallocate the balance and cancel'**
  String get goalCancelUnallocate;

  /// No description provided for @goalCancelKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it archived with its balance'**
  String get goalCancelKeep;

  /// No description provided for @goalConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this goal permanently? Only goals with no history can be deleted.'**
  String get goalConfirmDelete;

  /// No description provided for @goalConfirmCancelSimple.
  ///
  /// In en, this message translates to:
  /// **'Cancel this goal? Its history is kept.'**
  String get goalConfirmCancelSimple;

  /// No description provided for @goalLedger.
  ///
  /// In en, this message translates to:
  /// **'Fund activity'**
  String get goalLedger;

  /// No description provided for @goalNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get goalNoActivity;

  /// No description provided for @goalEntryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get goalEntryDeleted;

  /// No description provided for @goalEntryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get goalEntryDelete;

  /// No description provided for @goalEntryRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get goalEntryRestore;

  /// No description provided for @goalContributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get goalContributions;

  /// No description provided for @goalWithdrawals.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals'**
  String get goalWithdrawals;

  /// No description provided for @goalTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get goalTransfers;

  /// No description provided for @goalDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal details'**
  String get goalDetailsTitle;

  /// No description provided for @goalSaved.
  ///
  /// In en, this message translates to:
  /// **'Goal saved'**
  String get goalSaved;

  /// No description provided for @goalContributed.
  ///
  /// In en, this message translates to:
  /// **'Contribution added'**
  String get goalContributed;

  /// No description provided for @goalWithdrew.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal recorded'**
  String get goalWithdrew;

  /// No description provided for @goalTransferred.
  ///
  /// In en, this message translates to:
  /// **'Transfer completed'**
  String get goalTransferred;

  /// No description provided for @goalStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated'**
  String get goalStatusUpdated;

  /// No description provided for @goalTypeEmergencyFund.
  ///
  /// In en, this message translates to:
  /// **'Emergency fund'**
  String get goalTypeEmergencyFund;

  /// No description provided for @goalTypeHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get goalTypeHome;

  /// No description provided for @goalTypeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get goalTypeCar;

  /// No description provided for @goalTypeTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get goalTypeTravel;

  /// No description provided for @goalTypeEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get goalTypeEducation;

  /// No description provided for @goalTypeWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get goalTypeWedding;

  /// No description provided for @goalTypeRetirement.
  ///
  /// In en, this message translates to:
  /// **'Retirement'**
  String get goalTypeRetirement;

  /// No description provided for @goalTypeDebtPayoff.
  ///
  /// In en, this message translates to:
  /// **'Debt payoff'**
  String get goalTypeDebtPayoff;

  /// No description provided for @goalTypePurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get goalTypePurchase;

  /// No description provided for @goalTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get goalTypeCustom;

  /// No description provided for @goalPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get goalPriorityLow;

  /// No description provided for @goalPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get goalPriorityMedium;

  /// No description provided for @goalPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get goalPriorityHigh;

  /// No description provided for @goalPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get goalPriorityCritical;

  /// No description provided for @goalTrackCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalTrackCompleted;

  /// No description provided for @goalTrackNoTargetDate.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get goalTrackNoTargetDate;

  /// No description provided for @goalTrackNoHistory.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get goalTrackNoHistory;

  /// No description provided for @goalTrackAhead.
  ///
  /// In en, this message translates to:
  /// **'Ahead of plan'**
  String get goalTrackAhead;

  /// No description provided for @goalTrackOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get goalTrackOnTrack;

  /// No description provided for @goalTrackBehind.
  ///
  /// In en, this message translates to:
  /// **'Behind plan'**
  String get goalTrackBehind;

  /// No description provided for @dashboardGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get dashboardGoals;

  /// No description provided for @goalsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get goalsViewAll;

  /// No description provided for @budgetLinkedGoal.
  ///
  /// In en, this message translates to:
  /// **'Linked goal'**
  String get budgetLinkedGoal;

  /// No description provided for @budgetLinkGoalNone.
  ///
  /// In en, this message translates to:
  /// **'No linked goal'**
  String get budgetLinkGoalNone;

  /// No description provided for @budgetGoalContributed.
  ///
  /// In en, this message translates to:
  /// **'Contributed this month'**
  String get budgetGoalContributed;

  /// No description provided for @budgetGoalWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn this month'**
  String get budgetGoalWithdrawn;

  /// No description provided for @budgetGoalRemainingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Remaining planned contribution'**
  String get budgetGoalRemainingPlanned;

  /// No description provided for @goalInsightShortfall.
  ///
  /// In en, this message translates to:
  /// **'Allocated funds exceed your eligible liquid balance.'**
  String get goalInsightShortfall;

  /// No description provided for @goalInsightBehind.
  ///
  /// In en, this message translates to:
  /// **'{name} is behind its plan.'**
  String goalInsightBehind(String name);

  /// No description provided for @goalInsightNearCompletion.
  ///
  /// In en, this message translates to:
  /// **'{name} is almost funded.'**
  String goalInsightNearCompletion(String name);

  /// No description provided for @goalInsightCompleted.
  ///
  /// In en, this message translates to:
  /// **'{name} is fully funded.'**
  String goalInsightCompleted(String name);

  /// No description provided for @goalInsightStalled.
  ///
  /// In en, this message translates to:
  /// **'{name} hasn\'t received a contribution in a while.'**
  String goalInsightStalled(String name);

  /// No description provided for @goalInsightDeadlineSoon.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s target date is near with a lot still to save.'**
  String goalInsightDeadlineSoon(String name);

  /// No description provided for @goalInsightOverfunded.
  ///
  /// In en, this message translates to:
  /// **'{name} is funded beyond its target.'**
  String goalInsightOverfunded(String name);

  /// No description provided for @goalInsightEmergencyLow.
  ///
  /// In en, this message translates to:
  /// **'Your emergency fund is below its target.'**
  String get goalInsightEmergencyLow;

  /// No description provided for @errorGoalTargetInvalid.
  ///
  /// In en, this message translates to:
  /// **'The target amount must be greater than zero.'**
  String get errorGoalTargetInvalid;

  /// No description provided for @errorGoalLiabilityNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Only a debt-payoff goal can link a liability account.'**
  String get errorGoalLiabilityNotAllowed;

  /// No description provided for @errorGoalNotLiability.
  ///
  /// In en, this message translates to:
  /// **'The linked account must be a liability.'**
  String get errorGoalNotLiability;

  /// No description provided for @errorGoalNotActive.
  ///
  /// In en, this message translates to:
  /// **'Only active goals can receive contributions.'**
  String get errorGoalNotActive;

  /// No description provided for @errorGoalInsufficientFund.
  ///
  /// In en, this message translates to:
  /// **'The goal doesn\'t have enough allocated funds.'**
  String get errorGoalInsufficientFund;

  /// No description provided for @errorGoalExceedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'That exceeds your funds available to allocate.'**
  String get errorGoalExceedsAvailable;

  /// No description provided for @errorGoalSameTransfer.
  ///
  /// In en, this message translates to:
  /// **'Choose two different goals to transfer between.'**
  String get errorGoalSameTransfer;

  /// No description provided for @errorGoalHasLedger.
  ///
  /// In en, this message translates to:
  /// **'This goal has activity and can\'t be deleted. Cancel or archive it instead.'**
  String get errorGoalHasLedger;

  /// No description provided for @errorGoalAllocationExceedsTransaction.
  ///
  /// In en, this message translates to:
  /// **'The linked amount exceeds the transaction\'s value.'**
  String get errorGoalAllocationExceedsTransaction;

  /// No description provided for @errorGoalAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get errorGoalAmountInvalid;

  /// No description provided for @errorGoalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Goal not found.'**
  String get errorGoalNotFound;

  /// No description provided for @errorGoalEntryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Fund entry not found.'**
  String get errorGoalEntryNotFound;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'A database error occurred.'**
  String get errorDatabase;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
