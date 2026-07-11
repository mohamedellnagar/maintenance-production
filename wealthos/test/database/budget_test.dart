import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/budgets/data/budgets_repository.dart';
import 'package:wealthos/features/budgets/domain/budget.dart';
import 'package:wealthos/features/budgets/domain/budget_item.dart';
import 'package:wealthos/features/budgets/domain/budget_item_input.dart';

void main() {
  group('migration v1 → v2', () {
    test('upgrading a v1 database creates the budget tables', () async {
      final raw = sqlite3.openInMemory();
      // Minimal v1 schema needed for seeding + budget FKs, marked as version 1.
      raw.execute('''
        CREATE TABLE categories (
          id TEXT NOT NULL PRIMARY KEY,
          name_ar TEXT NOT NULL,
          name_en TEXT NOT NULL,
          category_type TEXT NOT NULL,
          parent_id TEXT,
          icon TEXT,
          is_system INTEGER NOT NULL DEFAULT 0,
          is_archived INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');
      raw.execute('CREATE TABLE accounts (id TEXT NOT NULL PRIMARY KEY);');
      raw.execute('PRAGMA user_version = 1;');

      final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
      addTearDown(db.close);
      // Trigger open + migration.
      await db.customSelect('SELECT 1').get();

      final tables = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
          .get();
      final names = tables.map((r) => r.read<String>('name')).toSet();
      expect(
        names,
        containsAll(['budgets', 'budget_items', 'budget_rollovers']),
      );

      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 2);
    });
  });

  group('budget repository', () {
    late AppDatabase db;
    late BudgetsRepository budgets;
    late AccountsRepository accounts;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      budgets = BudgetsRepository(db);
      accounts = AccountsRepository(db);
      await db.customSelect('SELECT 1').get();
    });
    tearDown(() => db.close());

    Future<Account> liability() async {
      final r = await accounts.create(
        const NewAccountInput(
          name: 'Card',
          type: AccountType.creditCard,
          classification: AccountClassification.liability,
          currencyCode: 'AED',
        ),
      );
      return r.valueOrNull!;
    }

    Future<Budget> newBudget({int year = 2026, int month = 7}) async {
      final r = await budgets.createEmptyBudget(year, month, 'AED');
      return r.valueOrNull!;
    }

    test('only one budget per (year, month, currency)', () async {
      expect((await budgets.createEmptyBudget(2026, 7, 'AED')).isSuccess, true);
      expect((await budgets.createEmptyBudget(2026, 7, 'AED')).isFailure, true);
    });

    test('create, read and reopen a budget', () async {
      final b = await newBudget();
      expect((await budgets.getBudget(2026, 7, 'AED'))!.id, b.id);
      final reopened = await budgets.reopenMonth(b.id);
      expect(reopened.valueOrNull!.status, BudgetStatus.active);
    });

    test('CRUD budget items', () async {
      final b = await newBudget();
      final created = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 100000,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(created.isSuccess, true);
      final id = created.valueOrNull!.id;
      final updated = await budgets.updateItem(
        id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 150000,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(updated.valueOrNull!.assignedAmountMinor, 150000);
      expect((await budgets.deleteItem(id)).isSuccess, true);
    });

    test('rejects an expense item with an income category', () async {
      final b = await newBudget();
      final r = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 1000,
          categoryId: 'sys_inc_salary',
        ),
      );
      expect(r.isFailure, true);
    });

    test('rejects an archived category', () async {
      final b = await newBudget();
      await (db.update(db.categoriesTable)
            ..where((c) => c.id.equals('sys_exp_food')))
          .write(const CategoriesTableCompanion(isArchived: Value(true)));
      final r = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 1000,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(r.isFailure, true);
    });

    test(
      'debt payment requires a liability account; rejects an asset',
      () async {
        final b = await newBudget();
        final asset = await accounts.create(
          const NewAccountInput(
            name: 'Bank',
            type: AccountType.bank,
            classification: AccountClassification.asset,
            currencyCode: 'AED',
          ),
        );
        final r = await budgets.createItem(
          b.id,
          BudgetItemInput(
            type: BudgetItemType.debtPayment,
            assignedAmountMinor: 1000,
            accountId: asset.valueOrNull!.id,
          ),
        );
        expect(r.isFailure, true);

        final card = await liability();
        final ok = await budgets.createItem(
          b.id,
          BudgetItemInput(
            type: BudgetItemType.debtPayment,
            assignedAmountMinor: 1000,
            accountId: card.id,
          ),
        );
        expect(ok.isSuccess, true);
      },
    );

    test('rejects a duplicate category item', () async {
      final b = await newBudget();
      const input = BudgetItemInput(
        type: BudgetItemType.expense,
        assignedAmountMinor: 1000,
        categoryId: 'sys_exp_food',
      );
      expect((await budgets.createItem(b.id, input)).isSuccess, true);
      expect((await budgets.createItem(b.id, input)).isFailure, true);
    });

    test('rejects a parent+child hierarchy conflict', () async {
      final b = await newBudget();
      final now = DateTime(2026, 7, 1);
      // A child of the seeded Food category.
      await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion.insert(
              id: 'groceries',
              nameAr: 'بقالة',
              nameEn: 'Groceries',
              categoryType: 'expense',
              parentId: const Value('sys_exp_food'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      expect(
        (await budgets.createItem(
          b.id,
          const BudgetItemInput(
            type: BudgetItemType.expense,
            assignedAmountMinor: 1000,
            categoryId: 'sys_exp_food',
          ),
        )).isSuccess,
        true,
      );
      // Child conflicts with the already-budgeted parent.
      final conflict = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 1000,
          categoryId: 'groceries',
        ),
      );
      expect(conflict.isFailure, true);
    });

    test(
      'copy previous month copies items but not actuals or rollovers',
      () async {
        final prev = await budgets.createEmptyBudget(2026, 6, 'AED');
        await budgets.createItem(
          prev.valueOrNull!.id,
          const BudgetItemInput(
            type: BudgetItemType.expense,
            assignedAmountMinor: 120000,
            categoryId: 'sys_exp_food',
          ),
        );
        final result = await budgets.copyPreviousMonth(2026, 7, 'AED');
        expect(result.isSuccess, true);
        final items = await budgets
            .watchItems(result.valueOrNull!.budget.id)
            .first;
        expect(items.length, 1);
        expect(items.single.assignedAmountMinor, 120000);
      },
    );

    test('copy previous fails when there is no previous month', () async {
      final r = await budgets.copyPreviousMonth(2026, 7, 'AED');
      expect(r.isFailure, true);
    });

    test('close month is atomic and records a traceable rollover', () async {
      final b = await newBudget();
      final item = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 100000,
          categoryId: 'sys_exp_food',
          rolloverEnabled: true,
        ),
      );
      final closed = await budgets.closeMonth(
        b.id,
        rollovers: [(sourceItemId: item.valueOrNull!.id, amountMinor: 100000)],
        snapshotExpenseMinor: 0,
        snapshotIncomeMinor: 0,
      );
      expect(closed.valueOrNull!.status, BudgetStatus.closed);
      expect(closed.valueOrNull!.closedSnapshotExpenseMinor, 0);

      // Next month budget was created with a target item + rollover record.
      final next = await budgets.getBudget(2026, 8, 'AED');
      expect(next, isNotNull);
      final rollovers = await budgets.watchIncomingRollovers(next!.id).first;
      expect(rollovers.length, 1);
      expect(rollovers.single.sourceBudgetItemId, item.valueOrNull!.id);
      expect(rollovers.single.amountMinor, 100000);
      expect(rollovers.single.targetBudgetItemId, isNotNull);
    });

    test('closed month blocks item edits until reopened', () async {
      final b = await newBudget();
      final item = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 100000,
          categoryId: 'sys_exp_food',
        ),
      );
      await budgets.closeMonth(
        b.id,
        rollovers: const [],
        snapshotExpenseMinor: 0,
        snapshotIncomeMinor: 0,
      );
      final blocked = await budgets.updateItem(
        item.valueOrNull!.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 200000,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(blocked.isFailure, true);
      await budgets.reopenMonth(b.id);
      final ok = await budgets.updateItem(
        item.valueOrNull!.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 200000,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(ok.isSuccess, true);
    });

    test('cannot delete an item that has a linked rollover', () async {
      final b = await newBudget();
      final item = await budgets.createItem(
        b.id,
        const BudgetItemInput(
          type: BudgetItemType.expense,
          assignedAmountMinor: 100000,
          categoryId: 'sys_exp_food',
          rolloverEnabled: true,
        ),
      );
      await budgets.closeMonth(
        b.id,
        rollovers: [(sourceItemId: item.valueOrNull!.id, amountMinor: 100000)],
        snapshotExpenseMinor: 0,
        snapshotIncomeMinor: 0,
      );
      await budgets.reopenMonth(b.id);
      final r = await budgets.deleteItem(item.valueOrNull!.id);
      expect(r.isFailure, true);
    });

    test('foreign keys are enforced for budget items', () async {
      await expectLater(
        db
            .into(db.budgetItemsTable)
            .insert(
              BudgetItemsTableCompanion.insert(
                id: 'x',
                budgetId: 'no-such-budget',
                itemType: 'expense',
                assignedAmountMinor: 1000,
                createdAt: DateTime(2026, 7, 1),
                updatedAt: DateTime(2026, 7, 1),
              ),
            ),
        throwsA(anything),
      );
    });
  });
}
