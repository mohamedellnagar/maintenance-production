import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/errors/failure.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/recurring/data/recurring_repository.dart';
import 'package:wealthos/features/recurring/domain/recurring_rule_input.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

void main() {
  group('migration v2 → v3', () {
    test(
      'upgrading a v2 database creates recurring tables + settings column',
      () async {
        final raw = sqlite3.openInMemory();
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
        raw.execute('''
        CREATE TABLE app_settings (
          id INTEGER NOT NULL PRIMARY KEY DEFAULT 1,
          base_currency TEXT NOT NULL,
          language_code TEXT NOT NULL,
          theme_mode TEXT NOT NULL DEFAULT 'system',
          biometric_enabled INTEGER NOT NULL DEFAULT 0,
          onboarding_completed INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');
        // Budget tables already present (v2).
        raw.execute('CREATE TABLE budgets (id TEXT NOT NULL PRIMARY KEY);');
        raw.execute(
          'CREATE TABLE budget_items (id TEXT NOT NULL PRIMARY KEY);',
        );
        raw.execute(
          'CREATE TABLE budget_rollovers (id TEXT NOT NULL PRIMARY KEY);',
        );
        raw.execute('PRAGMA user_version = 2;');

        final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
        addTearDown(db.close);
        await db.customSelect('SELECT 1').get();

        final tables = await db
            .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
            .get();
        final names = tables.map((r) => r.read<String>('name')).toSet();
        expect(
          names,
          containsAll([
            'recurring_rules',
            'recurring_rule_weekdays',
            'recurring_occurrences',
          ]),
        );

        // Migrating a v2 database now lands at the latest version (4), which
        // also creates the goals tables.
        expect(
          names,
          containsAll([
            'financial_goals',
            'goal_funds',
            'goal_fund_entries',
            'goal_transaction_allocations',
          ]),
        );
        final version = await db
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), 4);
      },
    );
  });

  group('recurring repository', () {
    late AppDatabase db;
    late AccountsRepository accounts;
    late TransactionsRepository transactions;
    late RecurringRepository recurring;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      accounts = AccountsRepository(db);
      transactions = TransactionsRepository(db);
      recurring = RecurringRepository(db, transactions);
      await db.customSelect('SELECT 1').get();
    });
    tearDown(() => db.close());

    Future<String> asset({int opening = 0}) async {
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

    Future<String> liability() async {
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

    RecurringRuleInput expenseRule(String accountId) => RecurringRuleInput(
      name: 'Rent',
      type: RecurringType.expense,
      amountMinor: 500000,
      currencyCode: 'AED',
      frequency: RecurrenceFrequency.monthly,
      monthlyDay: 1,
      startDate: const LocalDate(2026, 1, 1),
      accountId: accountId,
      categoryId: 'sys_exp_housing',
    );

    test('create + generate is idempotent', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;

      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 3, 31),
      );
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 3, 31),
      );

      final occ = await recurring.watchOccurrencesForRule(rule.id).first;
      expect(occ.length, 3); // Jan, Feb, Mar — no duplicates
    });

    test('an unpaid occurrence creates no transaction', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      expect(await transactions.getAll(), isEmpty);
    });

    test(
      'posting an expense occurrence creates a linked expense transaction',
      () async {
        final acc = await asset(opening: 1000000);
        final rule = (await recurring.createRule(
          expenseRule(acc),
        )).valueOrNull!;
        await recurring.generateForRule(
          rule,
          const LocalDate(2026, 1, 1),
          const LocalDate(2026, 1, 31),
        );
        final occ =
            (await recurring.watchOccurrencesForRule(rule.id).first).single;

        final result = await recurring.postOccurrence(occ.id);
        expect(result.isSuccess, isTrue);

        final txs = await transactions.getAll();
        expect(txs.length, 1);
        expect(txs.single.type, TransactionType.expense);
        expect(txs.single.amountMinor, 500000);

        final posted = await recurring.getOccurrenceById(occ.id);
        expect(posted!.generatedTransactionId, txs.single.id);
      },
    );

    test('liability payment posts a transfer, not an expense/income', () async {
      final acc = await asset(opening: 1000000);
      final loan = await liability();
      final rule = (await recurring.createRule(
        RecurringRuleInput(
          name: 'Loan payment',
          type: RecurringType.liabilityPayment,
          amountMinor: 100000,
          currencyCode: 'AED',
          frequency: RecurrenceFrequency.monthly,
          monthlyDay: 1,
          startDate: const LocalDate(2026, 1, 1),
          accountId: acc,
          destinationAccountId: loan,
        ),
      )).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      final occ =
          (await recurring.watchOccurrencesForRule(rule.id).first).single;
      await recurring.postOccurrence(occ.id);

      final tx = (await transactions.getAll()).single;
      expect(tx.type, TransactionType.transfer);
      expect(tx.accountId, acc);
      expect(tx.destinationAccountId, loan);
    });

    test('double posting is rejected while the transaction is alive', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      final occ =
          (await recurring.watchOccurrencesForRule(rule.id).first).single;

      expect((await recurring.postOccurrence(occ.id)).isSuccess, isTrue);
      final second = await recurring.postOccurrence(occ.id);
      expect(second.isFailure, isTrue);
      expect(
        (second.failureOrNull as ValidationFailure).code,
        FailureCodes.occurrenceAlreadyPosted,
      );
      expect((await transactions.getAll()).length, 1);
    });

    test(
      'deleting the linked transaction lets the occurrence be re-posted',
      () async {
        final acc = await asset(opening: 1000000);
        final rule = (await recurring.createRule(
          expenseRule(acc),
        )).valueOrNull!;
        await recurring.generateForRule(
          rule,
          const LocalDate(2026, 1, 1),
          const LocalDate(2026, 1, 31),
        );
        final occ =
            (await recurring.watchOccurrencesForRule(rule.id).first).single;
        await recurring.postOccurrence(occ.id);
        final firstTx = (await transactions.getAll()).single;

        await transactions.softDelete(firstTx.id);
        // Re-posting now succeeds (occurrence reopened).
        final repost = await recurring.postOccurrence(occ.id);
        expect(repost.isSuccess, isTrue);

        final live = await transactions
            .getAll(); // getAll excludes soft-deleted
        expect(live.length, 1);
      },
    );

    test('skip marks the occurrence skipped and never posts', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      final occ =
          (await recurring.watchOccurrencesForRule(rule.id).first).single;

      await recurring.skip(occ.id, reason: 'On holiday');
      final skipped = await recurring.getOccurrenceById(occ.id);
      expect(skipped!.status, OccurrenceStatus.skipped);
      expect(skipped.skipReason, 'On holiday');

      final post = await recurring.postOccurrence(occ.id);
      expect(post.isFailure, isTrue);
      expect(await transactions.getAll(), isEmpty);
    });

    test('snooze moves the effective due date', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      final occ =
          (await recurring.watchOccurrencesForRule(rule.id).first).single;

      await recurring.snooze(occ.id, const LocalDate(2026, 1, 8));
      final snoozed = await recurring.getOccurrenceById(occ.id);
      expect(snoozed!.effectiveDueDate, const LocalDate(2026, 1, 8));
    });

    test('pause + resume toggles active state', () async {
      final acc = await asset();
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.setActive(rule.id, active: false);
      expect((await recurring.getRuleById(rule.id))!.isActive, isFalse);
      await recurring.setActive(rule.id, active: true);
      expect((await recurring.getRuleById(rule.id))!.isActive, isTrue);
    });

    test('editing the schedule drops future scheduled occurrences', () async {
      final acc = await asset();
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 6, 30),
      );
      expect(
        (await recurring.watchOccurrencesForRule(rule.id).first).length,
        6,
      );

      // Change day-of-month → schedule change wipes future unposted occurrences.
      await recurring.updateRule(
        rule.id,
        RecurringRuleInput(
          name: rule.name,
          type: RecurringType.expense,
          amountMinor: rule.amountMinor,
          currencyCode: 'AED',
          frequency: RecurrenceFrequency.monthly,
          monthlyDay: 15,
          startDate: const LocalDate(2026, 1, 1),
          accountId: acc,
          categoryId: 'sys_exp_housing',
        ),
        today: const LocalDate(2026, 1, 1),
      );
      expect(await recurring.watchOccurrencesForRule(rule.id).first, isEmpty);
    });

    test('a posted occurrence protects the rule from hard deletion', () async {
      final acc = await asset(opening: 1000000);
      final rule = (await recurring.createRule(expenseRule(acc))).valueOrNull!;
      await recurring.generateForRule(
        rule,
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 31),
      );
      final occ =
          (await recurring.watchOccurrencesForRule(rule.id).first).single;
      await recurring.postOccurrence(occ.id);

      final deleted = await recurring.deleteRule(rule.id);
      expect(deleted.isFailure, isTrue);
    });

    test('creating a rule against an archived account fails', () async {
      final acc = await asset();
      await accounts.setArchived(acc, archived: true);
      final result = await recurring.createRule(expenseRule(acc));
      expect(result.isFailure, isTrue);
      expect(
        (result.failureOrNull as ValidationFailure).code,
        FailureCodes.accountArchived,
      );
    });

    test(
      'liability payment requires the destination to be a liability',
      () async {
        final acc = await asset();
        final acc2 = await asset();
        final result = await recurring.createRule(
          RecurringRuleInput(
            name: 'Bad',
            type: RecurringType.liabilityPayment,
            amountMinor: 1000,
            currencyCode: 'AED',
            frequency: RecurrenceFrequency.monthly,
            monthlyDay: 1,
            startDate: const LocalDate(2026, 1, 1),
            accountId: acc,
            destinationAccountId: acc2,
          ),
        );
        expect(result.isFailure, isTrue);
        expect(
          (result.failureOrNull as ValidationFailure).code,
          FailureCodes.recurringNotLiability,
        );
      },
    );
  });
}
