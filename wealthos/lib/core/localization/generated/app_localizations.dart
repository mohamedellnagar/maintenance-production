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
  /// **'Adjustments correct a balance and are excluded from cash-flow reports.'**
  String get transactionAdjustmentHint;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionSaved;

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

  /// No description provided for @errorAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get errorAccountNotFound;

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
