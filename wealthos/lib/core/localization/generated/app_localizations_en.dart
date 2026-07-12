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
  String get navRecurring => 'Recurring';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get navMore => 'More';

  @override
  String get moreTitle => 'More';

  @override
  String get moreSectionTools => 'Tools';

  @override
  String get recurringTitle => 'Recurring';

  @override
  String get recurringDueToday => 'Due today';

  @override
  String get recurringOverdue => 'Overdue';

  @override
  String get recurringUpcoming7 => 'Next 7 days';

  @override
  String get recurringUpcoming30 => 'Next 30 days';

  @override
  String get recurringActiveRules => 'Active rules';

  @override
  String get recurringPlannedIncome => 'Planned income (upcoming)';

  @override
  String get recurringPlannedExpenses =>
      'Planned expenses & payments (upcoming)';

  @override
  String get recurringPlannedNote => 'Scheduled — not actual cash flow.';

  @override
  String get recurringEmptyTitle => 'No recurring items yet';

  @override
  String get recurringEmptyMessage =>
      'Add a rule for salaries, rent, subscriptions or loan payments.';

  @override
  String get recurringAddRule => 'Add recurring';

  @override
  String get recurringNoOccurrences => 'Nothing scheduled here.';

  @override
  String get recurringTypeIncome => 'Income';

  @override
  String get recurringTypeExpense => 'Expense';

  @override
  String get recurringTypeTransfer => 'Transfer';

  @override
  String get recurringTypeLiabilityPayment => 'Debt payment';

  @override
  String get recurringFreqDaily => 'Daily';

  @override
  String get recurringFreqWeekly => 'Weekly';

  @override
  String get recurringFreqMonthly => 'Monthly';

  @override
  String get recurringFreqYearly => 'Yearly';

  @override
  String get recurringFreqCustomInterval => 'Every N days';

  @override
  String get occStatusScheduled => 'Scheduled';

  @override
  String get occStatusDue => 'Due';

  @override
  String get occStatusOverdue => 'Overdue';

  @override
  String get occStatusPaid => 'Paid';

  @override
  String get occStatusSkipped => 'Skipped';

  @override
  String get occStatusCancelled => 'Cancelled';

  @override
  String get recurringName => 'Name';

  @override
  String get recurringAmount => 'Amount';

  @override
  String get recurringType => 'Type';

  @override
  String get recurringSourceAccount => 'From account';

  @override
  String get recurringDestinationAccount => 'To account';

  @override
  String get recurringCategory => 'Category';

  @override
  String get recurringFrequency => 'Frequency';

  @override
  String get recurringInterval => 'Interval';

  @override
  String get recurringWeekdays => 'Days of the week';

  @override
  String get recurringMonthlyMode => 'Monthly on';

  @override
  String get recurringMonthlyByDay => 'A day of the month';

  @override
  String get recurringMonthlyByWeekday => 'A weekday';

  @override
  String get recurringMonthlyDay => 'Day of month';

  @override
  String get recurringOrdinal => 'Which';

  @override
  String get recurringWeekday => 'Weekday';

  @override
  String get recurringYearlyMonth => 'Month';

  @override
  String get recurringYearlyDay => 'Day';

  @override
  String get recurringStartDate => 'Start date';

  @override
  String get recurringEndDate => 'End date';

  @override
  String get recurringMaxOccurrences => 'Max occurrences';

  @override
  String get recurringReminderDays => 'Remind days before';

  @override
  String get recurringAutoCreate => 'Create automatically when due';

  @override
  String get recurringNotes => 'Notes';

  @override
  String get recurringSelectAsset => 'Choose an asset account';

  @override
  String get recurringSelectLiability => 'Choose a liability account';

  @override
  String get recurringSaved => 'Recurring rule saved';

  @override
  String get recurringRuleDetails => 'Recurring rule';

  @override
  String get recurringNextDue => 'Next due';

  @override
  String get recurringCompletedCount => 'Posted';

  @override
  String get recurringOverdueCount => 'Overdue';

  @override
  String get recurringRecentTransactions => 'Recent transactions';

  @override
  String get recurringPause => 'Pause';

  @override
  String get recurringResume => 'Resume';

  @override
  String get recurringEnd => 'End rule';

  @override
  String get recurringEndConfirm =>
      'End this rule? Future occurrences stop; history is kept.';

  @override
  String get recurringDeleteConfirm =>
      'Delete this rule? Only possible when nothing has been posted.';

  @override
  String get recurringPaused => 'Paused';

  @override
  String get recurringActive => 'Active';

  @override
  String get recurringEnded => 'Ended';

  @override
  String get recurringArchivedWarning =>
      'This rule uses an archived account or category.';

  @override
  String get ordinalFirst => 'First';

  @override
  String get ordinalSecond => 'Second';

  @override
  String get ordinalThird => 'Third';

  @override
  String get ordinalFourth => 'Fourth';

  @override
  String get ordinalLast => 'Last';

  @override
  String get occurrenceDetails => 'Occurrence';

  @override
  String get occExpectedAmount => 'Expected amount';

  @override
  String get occOriginalDate => 'Original date';

  @override
  String get occSnoozedDate => 'Snoozed to';

  @override
  String get occMarkPaid => 'Mark as paid';

  @override
  String get occMarkReceived => 'Mark as received';

  @override
  String get occSnooze => 'Snooze';

  @override
  String get occSnooze1Week => 'Snooze 1 week';

  @override
  String get occSkip => 'Skip';

  @override
  String get occSkipConfirm =>
      'Skip only this occurrence? The schedule continues.';

  @override
  String get occSkipReason => 'Reason (optional)';

  @override
  String get occLinkedTransaction => 'Linked transaction';

  @override
  String get occPosted => 'Posted to a transaction';

  @override
  String get occSnoozed => 'Occurrence snoozed';

  @override
  String get occSkippedMsg => 'Occurrence skipped';

  @override
  String get occEditBeforePosting => 'Edit before posting';

  @override
  String get recurrenceDaily => 'Every day';

  @override
  String recurrenceEveryNDays(int count) {
    return 'Every $count days';
  }

  @override
  String recurrenceWeeklyOn(String days) {
    return 'Weekly on $days';
  }

  @override
  String recurrenceEveryNWeeksOn(int count, String days) {
    return 'Every $count weeks on $days';
  }

  @override
  String recurrenceMonthlyDayText(int day) {
    return 'Monthly on day $day';
  }

  @override
  String recurrenceMonthlyOrdinalText(String ordinal, String weekday) {
    return 'Monthly on the $ordinal $weekday';
  }

  @override
  String recurrenceYearlyText(String date) {
    return 'Yearly on $date';
  }

  @override
  String get dashboardUpcomingBills => 'Upcoming bills';

  @override
  String get recurringViewAll => 'View all';

  @override
  String get recurringNoUpcoming => 'No upcoming bills.';

  @override
  String get budgetUpcomingRecurring => 'Upcoming recurring';

  @override
  String get budgetUpcomingRecurringNote =>
      'Planned, not yet posted. Does not affect actual spending or balances.';

  @override
  String get settingsAutoCreateRecurring =>
      'Auto-create recurring transactions';

  @override
  String get settingsAutoCreateRecurringSubtitle =>
      'When a rule is due, post it automatically. Off by default.';

  @override
  String get insightBillOverdue => 'You have an overdue bill.';

  @override
  String get insightMultipleDueToday => 'More than one bill is due today.';

  @override
  String get insightIncomeUpcoming => 'Expected income is due soon.';

  @override
  String get insightAutoCreateFailed =>
      'A recurring auto-post could not be created.';

  @override
  String get insightRecurringArchived =>
      'A recurring rule uses an archived account or category.';

  @override
  String get insightManyUnpaid => 'Several recurring occurrences are unpaid.';

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
  String get errorRecurringWeekdayRequired => 'Pick at least one weekday.';

  @override
  String get errorRecurringInvalidSchedule =>
      'The schedule is incomplete or invalid.';

  @override
  String get errorRecurringEndBeforeStart =>
      'The end date cannot be before the start date.';

  @override
  String get errorRecurringMaxInvalid =>
      'Max occurrences must be greater than zero.';

  @override
  String get errorRecurringReminderInvalid =>
      'Reminder days cannot be negative.';

  @override
  String get errorRecurringIntervalInvalid =>
      'The interval must be at least 1.';

  @override
  String get errorRecurringNotLiability =>
      'A debt payment must go from an asset to a liability account.';

  @override
  String get errorOccurrenceAlreadyPosted =>
      'This occurrence is already posted.';

  @override
  String get errorOccurrenceNotOpen => 'This occurrence cannot be posted.';

  @override
  String get errorRuleNotFound => 'Recurring rule not found.';

  @override
  String get errorOccurrenceNotFound => 'Occurrence not found.';

  @override
  String get navGoals => 'Goals';

  @override
  String get goalsTitle => 'Goals';

  @override
  String get goalsEmptyTitle => 'No goals yet';

  @override
  String get goalsEmptyMessage =>
      'Create a goal to start saving toward what matters.';

  @override
  String get goalAdd => 'New goal';

  @override
  String get goalsSummaryTotalTarget => 'Total target';

  @override
  String get goalsSummaryAllocated => 'Allocated';

  @override
  String get goalsSummaryRemaining => 'Remaining';

  @override
  String get goalsSummaryUnallocated => 'Unallocated';

  @override
  String get goalsSummaryActive => 'Active goals';

  @override
  String get goalsSummaryBehind => 'Behind plan';

  @override
  String get goalsSummaryNearest => 'Closest to done';

  @override
  String get goalsShortfallWarning =>
      'Allocated funds now exceed your eligible liquid balance.';

  @override
  String get goalsShortfallNote =>
      'Allocations are virtual earmarks and don\'t reserve money at the bank.';

  @override
  String get goalsSectionActive => 'Active';

  @override
  String get goalsSectionPaused => 'Paused';

  @override
  String get goalsSectionCompleted => 'Completed';

  @override
  String get goalsSectionArchived => 'Archived';

  @override
  String get goalTarget => 'Target';

  @override
  String get goalFunded => 'Funded';

  @override
  String get goalRemaining => 'Remaining';

  @override
  String get goalOverfunded => 'Overfunded';

  @override
  String get goalRequiredMonthly => 'Needed / month';

  @override
  String get goalProjectedCompletion => 'Projected completion';

  @override
  String get goalProjectionUnavailable => 'Can\'t estimate yet';

  @override
  String get goalPriority => 'Priority';

  @override
  String get goalTargetDate => 'Target date';

  @override
  String get goalNoTargetDate => 'No target date';

  @override
  String get goalSavedForRepayment => 'Saved for repayment';

  @override
  String get goalActualDebtReduced => 'Actual debt reduced';

  @override
  String get goalName => 'Name';

  @override
  String get goalType => 'Type';

  @override
  String get goalAmount => 'Target amount';

  @override
  String get goalLinkedLiability => 'Debt to pay off';

  @override
  String get goalSelectLiability => 'Select a liability account';

  @override
  String get goalInitialAllocation => 'Initial allocation';

  @override
  String get goalNotes => 'Notes';

  @override
  String get goalReview => 'Review';

  @override
  String get goalContribution => 'Contribution';

  @override
  String get goalContributionAmount => 'Amount to allocate';

  @override
  String get goalWithdrawAmount => 'Amount to withdraw';

  @override
  String get goalTransferAmount => 'Amount to transfer';

  @override
  String get goalTransferTo => 'Transfer to';

  @override
  String get goalReason => 'Note (optional)';

  @override
  String get goalAvailableToAllocate => 'Available to allocate';

  @override
  String get goalAddContribution => 'Add contribution';

  @override
  String get goalWithdraw => 'Withdraw';

  @override
  String get goalTransfer => 'Transfer';

  @override
  String get goalPause => 'Pause';

  @override
  String get goalResume => 'Resume';

  @override
  String get goalComplete => 'Mark complete';

  @override
  String get goalCancel => 'Cancel goal';

  @override
  String get goalArchive => 'Archive';

  @override
  String get goalConfirmComplete => 'Mark this goal as complete?';

  @override
  String get goalConfirmCancelWithBalance =>
      'This goal still holds allocated money. Choose what to do with it.';

  @override
  String get goalCancelUnallocate => 'Unallocate the balance and cancel';

  @override
  String get goalCancelKeep => 'Keep it archived with its balance';

  @override
  String get goalConfirmDelete =>
      'Delete this goal permanently? Only goals with no history can be deleted.';

  @override
  String get goalConfirmCancelSimple =>
      'Cancel this goal? Its history is kept.';

  @override
  String get goalLedger => 'Fund activity';

  @override
  String get goalNoActivity => 'No activity yet.';

  @override
  String get goalEntryDeleted => 'Deleted';

  @override
  String get goalEntryDelete => 'Delete entry';

  @override
  String get goalEntryRestore => 'Restore';

  @override
  String get goalContributions => 'Contributions';

  @override
  String get goalWithdrawals => 'Withdrawals';

  @override
  String get goalTransfers => 'Transfers';

  @override
  String get goalDetailsTitle => 'Goal details';

  @override
  String get goalSaved => 'Goal saved';

  @override
  String get goalContributed => 'Contribution added';

  @override
  String get goalWithdrew => 'Withdrawal recorded';

  @override
  String get goalTransferred => 'Transfer completed';

  @override
  String get goalStatusUpdated => 'Goal updated';

  @override
  String get goalTypeEmergencyFund => 'Emergency fund';

  @override
  String get goalTypeHome => 'Home';

  @override
  String get goalTypeCar => 'Car';

  @override
  String get goalTypeTravel => 'Travel';

  @override
  String get goalTypeEducation => 'Education';

  @override
  String get goalTypeWedding => 'Wedding';

  @override
  String get goalTypeRetirement => 'Retirement';

  @override
  String get goalTypeDebtPayoff => 'Debt payoff';

  @override
  String get goalTypePurchase => 'Purchase';

  @override
  String get goalTypeCustom => 'Custom';

  @override
  String get goalPriorityLow => 'Low';

  @override
  String get goalPriorityMedium => 'Medium';

  @override
  String get goalPriorityHigh => 'High';

  @override
  String get goalPriorityCritical => 'Critical';

  @override
  String get goalTrackCompleted => 'Completed';

  @override
  String get goalTrackNoTargetDate => 'No deadline';

  @override
  String get goalTrackNoHistory => 'Not started';

  @override
  String get goalTrackAhead => 'Ahead of plan';

  @override
  String get goalTrackOnTrack => 'On track';

  @override
  String get goalTrackBehind => 'Behind plan';

  @override
  String get dashboardGoals => 'Goals';

  @override
  String get goalsViewAll => 'View all';

  @override
  String get budgetLinkedGoal => 'Linked goal';

  @override
  String get budgetLinkGoalNone => 'No linked goal';

  @override
  String get budgetGoalContributed => 'Contributed this month';

  @override
  String get budgetGoalWithdrawn => 'Withdrawn this month';

  @override
  String get budgetGoalRemainingPlanned => 'Remaining planned contribution';

  @override
  String get goalInsightShortfall =>
      'Allocated funds exceed your eligible liquid balance.';

  @override
  String goalInsightBehind(String name) {
    return '$name is behind its plan.';
  }

  @override
  String goalInsightNearCompletion(String name) {
    return '$name is almost funded.';
  }

  @override
  String goalInsightCompleted(String name) {
    return '$name is fully funded.';
  }

  @override
  String goalInsightStalled(String name) {
    return '$name hasn\'t received a contribution in a while.';
  }

  @override
  String goalInsightDeadlineSoon(String name) {
    return '$name\'s target date is near with a lot still to save.';
  }

  @override
  String goalInsightOverfunded(String name) {
    return '$name is funded beyond its target.';
  }

  @override
  String get goalInsightEmergencyLow =>
      'Your emergency fund is below its target.';

  @override
  String get errorGoalTargetInvalid =>
      'The target amount must be greater than zero.';

  @override
  String get errorGoalLiabilityNotAllowed =>
      'Only a debt-payoff goal can link a liability account.';

  @override
  String get errorGoalNotLiability => 'The linked account must be a liability.';

  @override
  String get errorGoalNotActive =>
      'Only active goals can receive contributions.';

  @override
  String get errorGoalInsufficientFund =>
      'The goal doesn\'t have enough allocated funds.';

  @override
  String get errorGoalExceedsAvailable =>
      'That exceeds your funds available to allocate.';

  @override
  String get errorGoalSameTransfer =>
      'Choose two different goals to transfer between.';

  @override
  String get errorGoalHasLedger =>
      'This goal has activity and can\'t be deleted. Cancel or archive it instead.';

  @override
  String get errorGoalAllocationExceedsTransaction =>
      'The linked amount exceeds the transaction\'s value.';

  @override
  String get errorGoalAmountInvalid => 'Enter an amount greater than zero.';

  @override
  String get errorGoalNotFound => 'Goal not found.';

  @override
  String get errorGoalEntryNotFound => 'Fund entry not found.';

  @override
  String get errorDatabase => 'A database error occurred.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';
}
