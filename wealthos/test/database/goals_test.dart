import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/errors/failure.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/goals/data/goals_repository.dart';
import 'package:wealthos/features/goals/domain/goal_fund.dart';
import 'package:wealthos/features/goals/domain/goal_input.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

void main() {
  group('migration v3 → v4', () {
    test(
      'upgrading a v3 database creates the goal tables + item column',
      () async {
        final raw = sqlite3.openInMemory();
        // Minimal pre-v4 schema. `categories` must exist so the beforeOpen seed
        // (idempotent) can run on this pre-existing database.
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
        raw.execute(
          'CREATE TABLE transactions (id TEXT NOT NULL PRIMARY KEY);',
        );
        raw.execute(
          'CREATE TABLE budget_items (id TEXT NOT NULL PRIMARY KEY);',
        );
        raw.execute('PRAGMA user_version = 3;');

        final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
        addTearDown(db.close);
        await db.customSelect('SELECT 1').get();

        final names =
            (await db
                    .customSelect(
                      "SELECT name FROM sqlite_master WHERE type='table'",
                    )
                    .get())
                .map((r) => r.read<String>('name'))
                .toSet();
        expect(
          names,
          containsAll([
            'financial_goals',
            'goal_funds',
            'goal_fund_entries',
            'goal_transaction_allocations',
          ]),
        );
        final itemCols =
            (await db.customSelect('PRAGMA table_info(budget_items)').get())
                .map((r) => r.read<String>('name'))
                .toSet();
        expect(itemCols, contains('linked_goal_id'));

        final version = await db
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), 5);
      },
    );
  });

  group('goals repository', () {
    late AppDatabase db;
    late AccountsRepository accounts;
    late TransactionsRepository transactions;
    late GoalsRepository goals;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      accounts = AccountsRepository(db);
      transactions = TransactionsRepository(db);
      goals = GoalsRepository(db, accounts, transactions);
      await db.customSelect('SELECT 1').get();
    });
    tearDown(() => db.close());

    Future<String> bank({int opening = 10000000}) async {
      final r = await accounts.create(
        NewAccountInput(
          name: 'Bank',
          type: AccountType.bank,
          classification: AccountClassification.asset,
          currencyCode: 'AED',
          openingBalanceMinor: opening,
        ),
      );
      return r.valueOrNull!.id;
    }

    Future<String> loan() async {
      final r = await accounts.create(
        const NewAccountInput(
          name: 'Loan',
          type: AccountType.loan,
          classification: AccountClassification.liability,
          currencyCode: 'AED',
        ),
      );
      return r.valueOrNull!.id;
    }

    GoalInput input({
      int target = 500000,
      GoalType type = GoalType.travel,
      String? liability,
    }) => GoalInput(
      name: 'Trip',
      type: type,
      targetAmountMinor: target,
      currencyCode: 'AED',
      priority: GoalPriority.medium,
      linkedLiabilityAccountId: liability,
    );

    Future<String> createGoal({int? initial}) async {
      await bank();
      final r = await goals.createGoal(
        input(),
        initialAllocationMinor: initial,
      );
      return r.valueOrNull!.id;
    }

    test('create makes a goal with a zero-balance fund', () async {
      final id = await createGoal();
      expect((await goals.getGoalById(id))!.name, 'Trip');
      expect((await goals.getFund(id))!.currentAllocatedMinor, 0);
    });

    test('an initial allocation seeds the fund', () async {
      final id = await createGoal(initial: 100000);
      expect((await goals.getFund(id))!.currentAllocatedMinor, 100000);
    });

    test(
      'contribution increases the fund; a real transaction is not created',
      () async {
        final id = await createGoal();
        final r = await goals.contribute(id, 200000);
        expect(r.isSuccess, isTrue);
        expect((await goals.getFund(id))!.currentAllocatedMinor, 200000);
        expect(await transactions.getAll(), isEmpty);
      },
    );

    test('contributing more than available liquid is rejected', () async {
      await bank(opening: 100000);
      final id = (await goals.createGoal(input())).valueOrNull!.id;
      final r = await goals.contribute(id, 250000);
      expect(r.isFailure, isTrue);
      expect(
        (r.failureOrNull as ValidationFailure).code,
        FailureCodes.goalExceedsAvailable,
      );
    });

    test(
      'withdrawal decreases the fund and is bounded by the balance',
      () async {
        final id = await createGoal(initial: 100000);
        expect((await goals.withdraw(id, 40000)).isSuccess, isTrue);
        expect((await goals.getFund(id))!.currentAllocatedMinor, 60000);
        final over = await goals.withdraw(id, 100000);
        expect(over.isFailure, isTrue);
        expect(
          (over.failureOrNull as ValidationFailure).code,
          FailureCodes.goalInsufficientFund,
        );
      },
    );

    test(
      'transfer between goals is atomic and preserves total allocated',
      () async {
        await bank();
        final a = (await goals.createGoal(input())).valueOrNull!.id;
        final b = (await goals.createGoal(input())).valueOrNull!.id;
        await goals.contribute(a, 200000);
        final before =
            (await goals.getFund(a))!.currentAllocatedMinor +
            (await goals.getFund(b))!.currentAllocatedMinor;

        final r = await goals.transferBetweenGoals(a, b, 80000);
        expect(r.isSuccess, isTrue);
        expect((await goals.getFund(a))!.currentAllocatedMinor, 120000);
        expect((await goals.getFund(b))!.currentAllocatedMinor, 80000);
        final after =
            (await goals.getFund(a))!.currentAllocatedMinor +
            (await goals.getFund(b))!.currentAllocatedMinor;
        expect(after, before);
      },
    );

    test(
      'transfer to the same goal or beyond the balance is rejected',
      () async {
        final id = await createGoal(initial: 50000);
        expect(
          (await goals.transferBetweenGoals(id, id, 1000)).isFailure,
          isTrue,
        );
        final other = (await goals.createGoal(input())).valueOrNull!.id;
        final over = await goals.transferBetweenGoals(id, other, 90000);
        expect(over.isFailure, isTrue);
        expect(
          (over.failureOrNull as ValidationFailure).code,
          FailureCodes.goalInsufficientFund,
        );
      },
    );

    test('soft delete then restore of an entry rebuilds the balance', () async {
      final id = await createGoal();
      await goals.contribute(id, 100000);
      final entry = (await goals.getEntriesForGoal(id)).single;

      await goals.softDeleteEntry(entry.id);
      expect((await goals.getFund(id))!.currentAllocatedMinor, 0);
      await goals.restoreEntry(entry.id);
      expect((await goals.getFund(id))!.currentAllocatedMinor, 100000);
    });

    test('recomputeFund rebuilds the cache from the ledger', () async {
      final id = await createGoal();
      await goals.contribute(id, 100000);
      await goals.withdraw(id, 30000);
      final entries = await goals.getEntriesForGoal(id);
      expect(GoalFund.balanceFromEntries(entries), 70000);
      await goals.recomputeFund(id);
      expect((await goals.getFund(id))!.currentAllocatedMinor, 70000);
    });

    test('status transitions set the right timestamps', () async {
      final id = await createGoal();
      await goals.setStatus(id, GoalStatus.paused);
      expect((await goals.getGoalById(id))!.status, GoalStatus.paused);
      await goals.setStatus(id, GoalStatus.completed);
      expect((await goals.getGoalById(id))!.completedAt, isNotNull);
    });

    test('a paused goal rejects contributions', () async {
      final id = await createGoal();
      await goals.setStatus(id, GoalStatus.paused);
      final r = await goals.contribute(id, 1000);
      expect(r.isFailure, isTrue);
      expect(
        (r.failureOrNull as ValidationFailure).code,
        FailureCodes.goalNotActive,
      );
    });

    test('a goal with ledger history cannot be hard-deleted', () async {
      final id = await createGoal();
      await goals.contribute(id, 1000);
      final r = await goals.deleteGoal(id);
      expect(r.isFailure, isTrue);
      expect(
        (r.failureOrNull as ValidationFailure).code,
        FailureCodes.goalHasLedger,
      );
    });

    test('a goal with no history can be deleted', () async {
      final id = await createGoal();
      expect((await goals.deleteGoal(id)).isSuccess, isTrue);
      expect(await goals.getGoalById(id), isNull);
    });

    test('debt-payoff can link a liability; other types cannot', () async {
      final debt = await loan();
      final ok = await goals.createGoal(
        input(type: GoalType.debtPayoff, liability: debt),
      );
      expect(ok.isSuccess, isTrue);

      final bad = await goals.createGoal(
        input(type: GoalType.travel, liability: debt),
      );
      expect(bad.isFailure, isTrue);
      expect(
        (bad.failureOrNull as ValidationFailure).code,
        FailureCodes.goalLiabilityNotAllowed,
      );
    });

    test(
      'linking a non-liability account to a debt goal is rejected',
      () async {
        final asset = await bank();
        final r = await goals.createGoal(
          input(type: GoalType.debtPayoff, liability: asset),
        );
        expect(r.isFailure, isTrue);
        expect(
          (r.failureOrNull as ValidationFailure).code,
          FailureCodes.goalNotLiability,
        );
      },
    );

    test('a transaction cannot be over-allocated across goals', () async {
      final acc = await bank();
      final acc2 = await bank();
      final tx = (await transactions.create(
        NewTransactionInput(
          type: TransactionType.transfer,
          amountMinor: 50000,
          currencyCode: 'AED',
          date: DateTime(2026, 6, 1),
          accountId: acc,
          destinationAccountId: acc2,
        ),
      )).valueOrNull!;

      final a = (await goals.createGoal(input())).valueOrNull!.id;
      final b = (await goals.createGoal(input())).valueOrNull!.id;
      expect(
        (await goals.contribute(
          a,
          40000,
          linkedTransactionId: tx.id,
        )).isSuccess,
        isTrue,
      );
      final over = await goals.contribute(b, 20000, linkedTransactionId: tx.id);
      expect(over.isFailure, isTrue);
      expect(
        (over.failureOrNull as ValidationFailure).code,
        FailureCodes.goalAllocationExceedsTransaction,
      );
    });

    test('deleting one leg of a transfer deletes both atomically', () async {
      await bank();
      final a = (await goals.createGoal(input())).valueOrNull!.id;
      final b = (await goals.createGoal(input())).valueOrNull!.id;
      await goals.contribute(a, 200000);
      await goals.transferBetweenGoals(a, b, 80000);
      expect((await goals.getFund(a))!.currentAllocatedMinor, 120000);
      expect((await goals.getFund(b))!.currentAllocatedMinor, 80000);

      // Delete the transferIn leg on b — both legs must reverse.
      final legB = (await goals.getEntriesForGoal(
        b,
      )).firstWhere((e) => e.isTransferLeg);
      await goals.softDeleteEntry(legB.id);
      expect((await goals.getFund(a))!.currentAllocatedMinor, 200000);
      expect((await goals.getFund(b))!.currentAllocatedMinor, 0);

      // Restoring re-applies both legs.
      await goals.restoreEntry(legB.id);
      expect((await goals.getFund(a))!.currentAllocatedMinor, 120000);
      expect((await goals.getFund(b))!.currentAllocatedMinor, 80000);
    });

    test(
      'verifyFunds detects a corrupted cache and repairAllFunds fixes it',
      () async {
        final id = await createGoal();
        await goals.contribute(id, 100000);
        // Corrupt the cached balance directly, bypassing the ledger.
        await (db.update(
          db.goalFundsTable,
        )..where((f) => f.goalId.equals(id))).write(
          const GoalFundsTableCompanion(currentAllocatedMinor: Value(999999)),
        );

        final mismatches = await goals.verifyFunds();
        expect(mismatches.length, 1);
        expect(mismatches.single.cachedMinor, 999999);
        expect(mismatches.single.ledgerMinor, 100000);

        final repaired = await goals.repairAllFunds();
        expect(repaired, 1);
        expect((await goals.getFund(id))!.currentAllocatedMinor, 100000);
        expect(await goals.verifyFunds(), isEmpty);
      },
    );
  });

  group('migration v4 → v5', () {
    test('adds transfer_group_id to goal_fund_entries', () async {
      final raw = sqlite3.openInMemory();
      raw.execute('''
        CREATE TABLE categories (
          id TEXT NOT NULL PRIMARY KEY, name_ar TEXT NOT NULL,
          name_en TEXT NOT NULL, category_type TEXT NOT NULL, parent_id TEXT,
          icon TEXT, is_system INTEGER NOT NULL DEFAULT 0,
          is_archived INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');
      raw.execute('CREATE TABLE accounts (id TEXT NOT NULL PRIMARY KEY);');
      raw.execute('CREATE TABLE transactions (id TEXT NOT NULL PRIMARY KEY);');
      raw.execute(
        'CREATE TABLE financial_goals (id TEXT NOT NULL PRIMARY KEY);',
      );
      // A v4 goal_fund_entries table WITHOUT transfer_group_id.
      raw.execute('''
        CREATE TABLE goal_fund_entries (
          id TEXT NOT NULL PRIMARY KEY, goal_id TEXT NOT NULL,
          entry_type TEXT NOT NULL, direction TEXT, amount_minor INTEGER NOT NULL,
          linked_transaction_id TEXT, related_goal_id TEXT,
          entry_date INTEGER NOT NULL, note TEXT, created_at INTEGER NOT NULL,
          deleted_at INTEGER
        );
      ''');
      raw.execute('PRAGMA user_version = 4;');

      final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
      addTearDown(db.close);
      await db.customSelect('SELECT 1').get();

      final cols =
          (await db.customSelect('PRAGMA table_info(goal_fund_entries)').get())
              .map((r) => r.read<String>('name'))
              .toSet();
      expect(cols, contains('transfer_group_id'));
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 5);
    });
  });
}
