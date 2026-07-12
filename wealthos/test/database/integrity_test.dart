import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/budgets/data/budgets_repository.dart';
import 'package:wealthos/features/budgets/domain/budget_item.dart';
import 'package:wealthos/features/budgets/domain/budget_item_input.dart';
import 'package:wealthos/features/goals/data/goals_repository.dart';
import 'package:wealthos/features/goals/domain/goal_input.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/recurring/data/recurring_repository.dart';
import 'package:wealthos/features/recurring/domain/recurring_rule_input.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

/// Cross-feature data-integrity checks on a realistically-seeded v5 database.
void main() {
  late AppDatabase db;
  late AccountsRepository accounts;
  late TransactionsRepository transactions;
  late BudgetsRepository budgets;
  late RecurringRepository recurring;
  late GoalsRepository goals;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    accounts = AccountsRepository(db);
    transactions = TransactionsRepository(db);
    budgets = BudgetsRepository(db);
    recurring = RecurringRepository(db, transactions);
    goals = GoalsRepository(db, accounts, transactions);
    await db.customSelect('SELECT 1').get();
  });
  tearDown(() => db.close());

  /// Seeds one of everything so the integrity checks have real relationships.
  Future<void> seed() async {
    final bank = (await accounts.create(
      const NewAccountInput(
        name: 'Bank',
        type: AccountType.bank,
        classification: AccountClassification.asset,
        currencyCode: 'AED',
        openingBalanceMinor: 5000000,
      ),
    )).valueOrNull!;
    final card = (await accounts.create(
      const NewAccountInput(
        name: 'Card',
        type: AccountType.creditCard,
        classification: AccountClassification.liability,
        currencyCode: 'AED',
      ),
    )).valueOrNull!;

    await transactions.create(
      NewTransactionInput(
        type: TransactionType.income,
        amountMinor: 800000,
        currencyCode: 'AED',
        date: DateTime(2026, 7, 2),
        accountId: bank.id,
        categoryId: 'sys_inc_salary',
      ),
    );
    await transactions.create(
      NewTransactionInput(
        type: TransactionType.expense,
        amountMinor: 30000,
        currencyCode: 'AED',
        date: DateTime(2026, 7, 3),
        accountId: bank.id,
        categoryId: 'sys_exp_food',
      ),
    );

    // Budget + a saving item linked to a goal.
    final budget = (await budgets.createEmptyBudget(
      2026,
      7,
      'AED',
    )).valueOrNull!;
    await budgets.createItem(
      budget.id,
      const BudgetItemInput(
        type: BudgetItemType.expense,
        assignedAmountMinor: 100000,
        categoryId: 'sys_exp_food',
      ),
    );

    // Recurring rule → generate → post one occurrence.
    final rule = (await recurring.createRule(
      RecurringRuleInput(
        name: 'Rent',
        type: RecurringType.expense,
        amountMinor: 200000,
        currencyCode: 'AED',
        frequency: RecurrenceFrequency.monthly,
        monthlyDay: 1,
        startDate: const LocalDate(2026, 7, 1),
        accountId: bank.id,
        categoryId: 'sys_exp_housing',
      ),
    )).valueOrNull!;
    await recurring.generateForRule(
      rule,
      const LocalDate(2026, 7, 1),
      const LocalDate(2026, 7, 31),
    );
    final occ = (await recurring.watchOccurrencesForRule(rule.id).first).single;
    await recurring.postOccurrence(occ.id);

    // Goals: two goals + a contribution + a transfer + a linked budget item.
    final goalA = (await goals.createGoal(
      const GoalInput(
        name: 'Trip',
        type: GoalType.travel,
        targetAmountMinor: 400000,
        currencyCode: 'AED',
        priority: GoalPriority.medium,
      ),
    )).valueOrNull!;
    final goalB = (await goals.createGoal(
      const GoalInput(
        name: 'Car',
        type: GoalType.car,
        targetAmountMinor: 900000,
        currencyCode: 'AED',
        priority: GoalPriority.high,
      ),
    )).valueOrNull!;
    await goals.contribute(goalA.id, 300000);
    await goals.transferBetweenGoals(goalA.id, goalB.id, 100000);

    await budgets.createItem(
      budget.id,
      BudgetItemInput(
        type: BudgetItemType.saving,
        assignedAmountMinor: 50000,
        linkedGoalId: goalA.id,
      ),
    );

    // A linked-transaction contribution (exercise allocations).
    final loan = card; // reuse the card as a liability endpoint for a transfer
    final transfer = (await transactions.create(
      NewTransactionInput(
        type: TransactionType.transfer,
        amountMinor: 60000,
        currencyCode: 'AED',
        date: DateTime(2026, 7, 5),
        accountId: bank.id,
        destinationAccountId: loan.id,
      ),
    )).valueOrNull!;
    await goals.contribute(goalB.id, 40000, linkedTransactionId: transfer.id);
  }

  test('foreign keys and structural integrity hold after seeding', () async {
    await seed();
    final fkViolations = await db
        .customSelect('PRAGMA foreign_key_check')
        .get();
    expect(fkViolations, isEmpty);
    final integrity = await db
        .customSelect('PRAGMA integrity_check')
        .getSingle();
    expect(integrity.data.values.first, 'ok');
  });

  test('every goal fund cache matches its ledger', () async {
    await seed();
    expect(await goals.verifyFunds(), isEmpty);
  });

  test('no paid occurrence lacks a live transaction', () async {
    await seed();
    final rows = await db.customSelect('''
      SELECT o.id FROM recurring_occurrences o
      LEFT JOIN transactions t ON t.id = o.generated_transaction_id
      WHERE o.status = 'paid'
        AND (o.generated_transaction_id IS NULL
             OR t.id IS NULL
             OR t.deleted_at IS NOT NULL)
    ''').get();
    expect(rows, isEmpty);
  });

  test('no transaction is allocated to goals beyond its amount', () async {
    await seed();
    final rows = await db.customSelect('''
      SELECT a.transaction_id
      FROM goal_transaction_allocations a
      JOIN transactions t ON t.id = a.transaction_id
      GROUP BY a.transaction_id, t.amount_minor
      HAVING SUM(a.amount_minor) > t.amount_minor
    ''').get();
    expect(rows, isEmpty);
  });

  test('no budget item links a non-existent goal', () async {
    await seed();
    final rows = await db.customSelect('''
      SELECT bi.id FROM budget_items bi
      WHERE bi.linked_goal_id IS NOT NULL
        AND NOT EXISTS (
          SELECT 1 FROM financial_goals g WHERE g.id = bi.linked_goal_id
        )
    ''').get();
    expect(rows, isEmpty);
  });

  test('both legs of every transfer group are consistent', () async {
    await seed();
    // Each transfer group must have exactly two legs with equal amounts and
    // matching deleted state.
    final rows = await db.customSelect('''
      SELECT transfer_group_id,
             COUNT(*) AS legs,
             COUNT(DISTINCT amount_minor) AS amounts,
             COUNT(DISTINCT (deleted_at IS NULL)) AS states
      FROM goal_fund_entries
      WHERE transfer_group_id IS NOT NULL
      GROUP BY transfer_group_id
    ''').get();
    for (final r in rows) {
      expect(r.read<int>('legs'), 2);
      expect(r.read<int>('amounts'), 1);
      expect(r.read<int>('states'), 1);
    }
  });
}
