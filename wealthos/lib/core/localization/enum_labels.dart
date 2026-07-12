import '../../features/accounts/domain/account_type.dart';
import '../../features/budgets/domain/budget.dart';
import '../../features/budgets/domain/budget_calculator.dart';
import '../../features/budgets/domain/budget_item.dart';
import '../../features/goals/domain/goal_type.dart';
import '../../features/recurring/domain/recurring_type.dart';
import '../../features/transactions/domain/transaction_semantic.dart';
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

extension BudgetItemTypeLabel on BudgetItemType {
  String label(AppLocalizations l) => switch (this) {
    BudgetItemType.expense => l.budgetItemTypeExpense,
    BudgetItemType.saving => l.budgetItemTypeSaving,
    BudgetItemType.debtPayment => l.budgetItemTypeDebt,
    BudgetItemType.incomePlan => l.budgetItemTypeIncome,
  };
}

extension ExpenseItemStatusLabel on ExpenseItemStatus {
  String label(AppLocalizations l) => switch (this) {
    ExpenseItemStatus.notStarted => l.budgetStatusNotStarted,
    ExpenseItemStatus.onTrack => l.budgetStatusOnTrack,
    ExpenseItemStatus.nearLimit => l.budgetStatusNearLimit,
    ExpenseItemStatus.overspent => l.budgetStatusOverspent,
  };
}

extension BudgetStatusLabel on BudgetStatus {
  String label(AppLocalizations l) => switch (this) {
    BudgetStatus.draft => l.budgetStatusDraft,
    BudgetStatus.active => l.budgetStatusActive,
    BudgetStatus.closed => l.budgetStatusClosed,
  };
}

extension RecurringTypeLabel on RecurringType {
  String label(AppLocalizations l) => switch (this) {
    RecurringType.income => l.recurringTypeIncome,
    RecurringType.expense => l.recurringTypeExpense,
    RecurringType.transfer => l.recurringTypeTransfer,
    RecurringType.liabilityPayment => l.recurringTypeLiabilityPayment,
  };
}

extension RecurrenceFrequencyLabel on RecurrenceFrequency {
  String label(AppLocalizations l) => switch (this) {
    RecurrenceFrequency.daily => l.recurringFreqDaily,
    RecurrenceFrequency.weekly => l.recurringFreqWeekly,
    RecurrenceFrequency.monthly => l.recurringFreqMonthly,
    RecurrenceFrequency.yearly => l.recurringFreqYearly,
    RecurrenceFrequency.customInterval => l.recurringFreqCustomInterval,
  };
}

extension OccurrenceDisplayStatusLabel on OccurrenceDisplayStatus {
  String label(AppLocalizations l) => switch (this) {
    OccurrenceDisplayStatus.scheduled => l.occStatusScheduled,
    OccurrenceDisplayStatus.due => l.occStatusDue,
    OccurrenceDisplayStatus.overdue => l.occStatusOverdue,
    OccurrenceDisplayStatus.paid => l.occStatusPaid,
    OccurrenceDisplayStatus.skipped => l.occStatusSkipped,
    OccurrenceDisplayStatus.cancelled => l.occStatusCancelled,
  };
}

extension GoalTypeLabel on GoalType {
  String label(AppLocalizations l) => switch (this) {
    GoalType.emergencyFund => l.goalTypeEmergencyFund,
    GoalType.home => l.goalTypeHome,
    GoalType.car => l.goalTypeCar,
    GoalType.travel => l.goalTypeTravel,
    GoalType.education => l.goalTypeEducation,
    GoalType.wedding => l.goalTypeWedding,
    GoalType.retirement => l.goalTypeRetirement,
    GoalType.debtPayoff => l.goalTypeDebtPayoff,
    GoalType.purchase => l.goalTypePurchase,
    GoalType.custom => l.goalTypeCustom,
  };
}

extension GoalPriorityLabel on GoalPriority {
  String label(AppLocalizations l) => switch (this) {
    GoalPriority.low => l.goalPriorityLow,
    GoalPriority.medium => l.goalPriorityMedium,
    GoalPriority.high => l.goalPriorityHigh,
    GoalPriority.critical => l.goalPriorityCritical,
  };
}

extension GoalTrackStatusLabel on GoalTrackStatus {
  String label(AppLocalizations l) => switch (this) {
    GoalTrackStatus.completed => l.goalTrackCompleted,
    GoalTrackStatus.noTargetDate => l.goalTrackNoTargetDate,
    GoalTrackStatus.noContributionHistory => l.goalTrackNoHistory,
    GoalTrackStatus.ahead => l.goalTrackAhead,
    GoalTrackStatus.onTrack => l.goalTrackOnTrack,
    GoalTrackStatus.behind => l.goalTrackBehind,
  };
}

extension TransactionSemanticLabel on TransactionSemantic {
  String label(AppLocalizations l) => switch (this) {
    TransactionSemantic.income => l.transactionTypeIncome,
    TransactionSemantic.expense => l.transactionTypeExpense,
    TransactionSemantic.liabilityCharge => l.semanticLiabilityCharge,
    TransactionSemantic.transfer => l.transactionTypeTransfer,
    TransactionSemantic.liabilityRepayment => l.semanticLiabilityRepayment,
    TransactionSemantic.liabilityDrawdown => l.semanticLiabilityDrawdown,
    TransactionSemantic.adjustment => l.transactionTypeAdjustment,
  };
}
