import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;
import 'seed/default_categories.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AppSettingsTable,
    AccountsTable,
    CategoriesTable,
    TransactionsTable,
    BudgetsTable,
    BudgetItemsTable,
    BudgetRolloversTable,
    RecurringRulesTable,
    RecurringRuleWeekdaysTable,
    RecurringOccurrencesTable,
    FinancialGoalsTable,
    GoalFundsTable,
    GoalFundEntriesTable,
    GoalTransactionAllocationsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await seedDefaultCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // v1 → v2: add the budgeting tables.
      if (from < 2) {
        await m.createTable(budgetsTable);
        await m.createTable(budgetItemsTable);
        await m.createTable(budgetRolloversTable);
      }
      // v2 → v3: recurring engine + auto-create setting.
      if (from < 3) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.autoCreateRecurringEnabled,
        );
        await m.createTable(recurringRulesTable);
        await m.createTable(recurringRuleWeekdaysTable);
        await m.createTable(recurringOccurrencesTable);
      }
      // v3 → v4: financial goals + savings funds, and a budget-item link.
      if (from < 4) {
        await m.createTable(financialGoalsTable);
        await m.createTable(goalFundsTable);
        await m.createTable(goalFundEntriesTable);
        await m.createTable(goalTransactionAllocationsTable);
        // Only add the column when budget_items already existed (v2/v3). On a
        // v1 upgrade the table is (re)created above with the column present.
        if (from >= 2) {
          await m.addColumn(budgetItemsTable, budgetItemsTable.linkedGoalId);
        }
      }
      // v4 → v5: pair the two legs of a goal transfer via a shared group id.
      // Only add the column when goal_fund_entries pre-existed (from v4); a
      // < 4 upgrade creates the table above already including the column.
      if (from < 5 && from >= 4) {
        await m.addColumn(
          goalFundEntriesTable,
          goalFundEntriesTable.transferGroupId,
        );
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Safety net for databases created before seeding existed or partially
      // wiped: seeding is idempotent (insert-or-ignore on stable ids).
      if (!details.wasCreated) {
        await seedDefaultCategories();
      }
    },
  );

  /// Inserts the default categories. Idempotent: stable ids + insert-or-ignore
  /// mean running it any number of times never produces duplicates.
  Future<void> seedDefaultCategories({DateTime? now}) async {
    final timestamp = now ?? _clock();
    await batch((Batch batch) {
      for (final category in kDefaultCategories) {
        batch.insert(
          categoriesTable,
          CategoriesTableCompanion.insert(
            id: category.id,
            nameAr: category.nameAr,
            nameEn: category.nameEn,
            categoryType: category.type,
            icon: Value(category.icon),
            isSystem: const Value(true),
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  DateTime _clock() => DateTime.now();
}
