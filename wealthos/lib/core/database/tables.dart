import 'package:drift/drift.dart';

/// Single-row table holding user-wide application settings.
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  TextColumn get languageCode => text().withLength(min: 2, max: 5)();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoCreateRecurringEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Financial accounts held by the user.
class AccountsTable extends Table {
  @override
  String get tableName => 'accounts';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get accountType => text()();
  TextColumn get classification => text()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get openingBalanceMinor =>
      integer().withDefault(const Constant(0))();
  TextColumn get institutionName => text().nullable()();
  TextColumn get accountNumberLast4 => text().nullable().withLength(max: 4)();
  TextColumn get icon => text().nullable()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (account_type IN '
        "('cash','bank','wallet','creditCard','investment','asset','loan','other'))",
    "CHECK (classification IN ('asset','liability'))",
  ];
}

/// Income/expense categories, shipped with a localized default set.
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get categoryType => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get icon => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (category_type IN ('income','expense'))",
  ];
}

/// The core ledger: every income, expense, transfer and adjustment.
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  TextColumn get transactionType => text()();
  @ReferenceName('outgoingTransactions')
  TextColumn get accountId =>
      text().nullable().references(AccountsTable, #id)();
  @ReferenceName('incomingTransactions')
  TextColumn get destinationAccountId =>
      text().nullable().references(AccountsTable, #id)();
  TextColumn get categoryId =>
      text().nullable().references(CategoriesTable, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get adjustmentReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (transaction_type IN ('income','expense','transfer','adjustment'))",
    // Amount is never zero. Only adjustments may be negative; income, expense
    // and transfer store a strictly positive magnitude (an expense is never
    // stored as a negative number — its direction comes from the type).
    'CHECK (amount_minor <> 0)',
    "CHECK (transaction_type = 'adjustment' OR amount_minor > 0)",
    // income / expense / adjustment must reference a source account.
    "CHECK (transaction_type = 'transfer' OR account_id IS NOT NULL)",
    // A transfer needs both endpoints and they must differ.
    "CHECK (transaction_type <> 'transfer' OR "
        '(account_id IS NOT NULL AND destination_account_id IS NOT NULL '
        'AND account_id <> destination_account_id))',
    // Only transfers carry a destination account.
    "CHECK (transaction_type = 'transfer' OR destination_account_id IS NULL)",
    // Adjustments must record a reason.
    "CHECK (transaction_type <> 'adjustment' OR "
        "(adjustment_reason IS NOT NULL AND adjustment_reason <> ''))",
  ];
}

/// One monthly budget per (year, month, currency).
class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  TextColumn get id => text()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().nullable()();
  // Totals captured when the month is closed, to detect later changes.
  IntColumn get closedSnapshotExpenseMinor => integer().nullable()();
  IntColumn get closedSnapshotIncomeMinor => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (status IN ('draft','active','closed'))",
    'CHECK (month BETWEEN 1 AND 12)',
    'UNIQUE (year, month, currency_code)',
  ];
}

/// A line item within a budget.
class BudgetItemsTable extends Table {
  @override
  String get tableName => 'budget_items';

  TextColumn get id => text()();
  TextColumn get budgetId => text().references(BudgetsTable, #id)();
  TextColumn get itemType => text()();
  TextColumn get categoryId =>
      text().nullable().references(CategoriesTable, #id)();
  TextColumn get accountId =>
      text().nullable().references(AccountsTable, #id)();
  TextColumn get customName => text().nullable()();
  IntColumn get assignedAmountMinor => integer()();
  BoolColumn get rolloverEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  // Optional link from a saving item to a financial goal (added in v4).
  TextColumn get linkedGoalId =>
      text().nullable().references(FinancialGoalsTable, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (item_type IN ('expense','saving','debtPayment','incomePlan'))",
    'CHECK (assigned_amount_minor >= 0)',
    // NULLs are distinct in SQLite, so these block duplicate category / account
    // items while allowing multiple saving rows (both columns null).
    'UNIQUE (budget_id, category_id)',
    'UNIQUE (budget_id, account_id)',
  ];
}

/// A traceable carry-over from one month's item to the next.
class BudgetRolloversTable extends Table {
  @override
  String get tableName => 'budget_rollovers';

  TextColumn get id => text()();
  @ReferenceName('rolloversFrom')
  TextColumn get fromBudgetId => text().references(BudgetsTable, #id)();
  @ReferenceName('rolloversTo')
  TextColumn get toBudgetId => text().references(BudgetsTable, #id)();
  @ReferenceName('rolloversFromItem')
  TextColumn get sourceBudgetItemId =>
      text().references(BudgetItemsTable, #id)();
  @ReferenceName('rolloversToItem')
  TextColumn get targetBudgetItemId =>
      text().nullable().references(BudgetItemsTable, #id)();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A schedule that produces recurring financial events (income, expense,
/// transfer or liability payment). Dates are stored as integer epoch-days.
class RecurringRulesTable extends Table {
  @override
  String get tableName => 'recurring_rules';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get recurringType => text()();
  TextColumn get accountId =>
      text().nullable().references(AccountsTable, #id)();
  @ReferenceName('recurringDestination')
  TextColumn get destinationAccountId =>
      text().nullable().references(AccountsTable, #id)();
  TextColumn get categoryId =>
      text().nullable().references(CategoriesTable, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get recurrenceFrequency => text()();
  IntColumn get intervalValue => integer().withDefault(const Constant(1))();
  IntColumn get monthlyDay => integer().nullable()();
  IntColumn get monthlyWeekOrdinal => integer().nullable()();
  IntColumn get monthlyWeekday => integer().nullable()();
  IntColumn get yearlyMonth => integer().nullable()();
  IntColumn get yearlyDay => integer().nullable()();
  IntColumn get startDate => integer()(); // epoch day
  IntColumn get endDate => integer().nullable()();
  IntColumn get maxOccurrences => integer().nullable()();
  BoolColumn get autoCreateTransaction =>
      boolean().withDefault(const Constant(false))();
  IntColumn get reminderDaysBefore =>
      integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get lastGeneratedThrough => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (recurring_type IN '
        "('income','expense','transfer','liabilityPayment'))",
    'CHECK (recurrence_frequency IN '
        "('daily','weekly','monthly','yearly','customInterval'))",
    'CHECK (amount_minor > 0)',
    'CHECK (interval_value >= 1)',
    'CHECK (reminder_days_before >= 0)',
  ];
}

/// Selected weekdays for a weekly rule (1=Mon..7=Sun).
class RecurringRuleWeekdaysTable extends Table {
  @override
  String get tableName => 'recurring_rule_weekdays';

  TextColumn get recurringRuleId =>
      text().references(RecurringRulesTable, #id)();
  IntColumn get weekday => integer()();

  @override
  Set<Column<Object>> get primaryKey => {recurringRuleId, weekday};
}

/// A generated due date for a rule. Dates are integer epoch-days.
class RecurringOccurrencesTable extends Table {
  @override
  String get tableName => 'recurring_occurrences';

  TextColumn get id => text()();
  TextColumn get recurringRuleId =>
      text().references(RecurringRulesTable, #id)();
  IntColumn get dueDate => integer()();
  IntColumn get originalDueDate => integer()();
  IntColumn get expectedAmountMinor => integer()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get generatedTransactionId =>
      text().nullable().references(TransactionsTable, #id)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get skippedAt => dateTime().nullable()();
  TextColumn get skipReason => text().nullable()();
  IntColumn get snoozedUntil => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (status IN ('scheduled','paid','skipped','cancelled'))",
    // Never generate the same occurrence twice.
    'UNIQUE (recurring_rule_id, original_due_date)',
  ];
}

/// A financial goal: a *target* the user saves toward. It never holds real
/// money — the money lives in accounts; a goal only tracks a target and its
/// virtual allocation fund. `target_date` is an integer epoch-day.
class FinancialGoalsTable extends Table {
  @override
  String get tableName => 'financial_goals';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get goalType => text()();
  IntColumn get targetAmountMinor => integer()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get targetDate => integer().nullable()(); // epoch day
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get linkedLiabilityAccountId =>
      text().nullable().references(AccountsTable, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get cancelledAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (goal_type IN '
        "('emergencyFund','home','car','travel','education','wedding',"
        "'retirement','debtPayoff','purchase','custom'))",
    "CHECK (priority IN ('low','medium','high','critical'))",
    'CHECK (status IN '
        "('draft','active','paused','completed','cancelled','archived'))",
    'CHECK (target_amount_minor > 0)',
  ];
}

/// The virtual allocation bucket for a goal (1:1). `current_allocated_minor` is
/// a cached balance kept in sync with [GoalFundEntriesTable] (the ledger, which
/// is the source of truth) and can be rebuilt from it.
class GoalFundsTable extends Table {
  @override
  String get tableName => 'goal_funds';

  TextColumn get id => text()();
  TextColumn get goalId => text().references(FinancialGoalsTable, #id)();
  IntColumn get currentAllocatedMinor =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>['UNIQUE (goal_id)'];
}

/// The movement ledger for a goal's fund. Every row stores a positive
/// `amount_minor`; direction is explicit in `entry_type` (with `direction` for
/// adjustments). Soft-deleted rows never count toward the balance.
class GoalFundEntriesTable extends Table {
  @override
  String get tableName => 'goal_fund_entries';

  TextColumn get id => text()();
  @ReferenceName('goalFundEntries')
  TextColumn get goalId => text().references(FinancialGoalsTable, #id)();
  TextColumn get entryType => text()();
  TextColumn get direction => text().nullable()(); // adjustments only
  IntColumn get amountMinor => integer()();
  TextColumn get linkedTransactionId =>
      text().nullable().references(TransactionsTable, #id)();
  @ReferenceName('goalFundEntriesRelated')
  TextColumn get relatedGoalId =>
      text().nullable().references(FinancialGoalsTable, #id)();
  IntColumn get entryDate => integer()(); // epoch day
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (entry_type IN '
        "('contribution','withdrawal','transferIn','transferOut','adjustment'))",
    'CHECK (amount_minor > 0)',
    "CHECK (entry_type <> 'adjustment' OR direction IN ('increase','decrease'))",
  ];
}

/// Links a goal contribution to a real transaction, without re-booking the
/// transaction. The sum of a transaction's allocations must stay `<=` its
/// amount (enforced in the repository).
class GoalTransactionAllocationsTable extends Table {
  @override
  String get tableName => 'goal_transaction_allocations';

  TextColumn get id => text()();
  TextColumn get goalId => text().references(FinancialGoalsTable, #id)();
  TextColumn get transactionId => text().references(TransactionsTable, #id)();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (amount_minor > 0)',
    'UNIQUE (goal_id, transaction_id)',
  ];
}
