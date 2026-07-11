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
