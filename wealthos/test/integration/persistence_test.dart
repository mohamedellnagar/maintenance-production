import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/goals/data/goals_repository.dart';
import 'package:wealthos/features/goals/domain/goal_input.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/recurring/application/recurrence_generation_service.dart';
import 'package:wealthos/features/recurring/data/recurring_repository.dart';
import 'package:wealthos/features/recurring/domain/recurring_rule_input.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';

/// Simulates closing and reopening the app by pointing two [AppDatabase]
/// instances at the same on-disk SQLite file.
void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('wealthos_persist');
    file = File('${dir.path}/wealthos.sqlite');
  });
  tearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  test('data survives an app restart and the generator resumes', () async {
    // --- first launch: seed a goal + fund, and a recurring rule ---
    final db1 = AppDatabase.forTesting(NativeDatabase(file));
    final accounts1 = AccountsRepository(db1);
    final tx1 = TransactionsRepository(db1);
    final goals1 = GoalsRepository(db1, accounts1, tx1);
    final recurring1 = RecurringRepository(db1, tx1);

    final bank = (await accounts1.create(
      const NewAccountInput(
        name: 'Bank',
        type: AccountType.bank,
        classification: AccountClassification.asset,
        currencyCode: 'AED',
        openingBalanceMinor: 5000000,
      ),
    )).valueOrNull!;
    final goal = (await goals1.createGoal(
      const GoalInput(
        name: 'Trip',
        type: GoalType.travel,
        targetAmountMinor: 400000,
        currencyCode: 'AED',
        priority: GoalPriority.medium,
      ),
    )).valueOrNull!;
    await goals1.contribute(goal.id, 150000);
    await recurring1.createRule(
      RecurringRuleInput(
        name: 'Rent',
        type: RecurringType.expense,
        amountMinor: 200000,
        currencyCode: 'AED',
        frequency: RecurrenceFrequency.monthly,
        monthlyDay: 1,
        startDate: const LocalDate(2026, 1, 1),
        accountId: bank.id,
        categoryId: 'sys_exp_housing',
      ),
    );
    await db1.close();

    // --- second launch: everything persists ---
    final db2 = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db2.close);
    final accounts2 = AccountsRepository(db2);
    final tx2 = TransactionsRepository(db2);
    final goals2 = GoalsRepository(db2, accounts2, tx2);
    final recurring2 = RecurringRepository(db2, tx2);

    expect((await accounts2.getAll()).length, 1);
    final reloaded = (await goals2.watchGoals().first).single;
    expect(reloaded.name, 'Trip');
    expect((await goals2.getFund(reloaded.id))!.currentAllocatedMinor, 150000);
    // The cache still matches the ledger after a restart.
    expect(await goals2.verifyFunds(), isEmpty);

    // The recurrence generator resumes and produces occurrences on reopen.
    final service = RecurrenceGenerationService(
      repository: recurring2,
      today: () => const LocalDate(2026, 3, 15),
      autoCreateEnabled: () async => false,
    );
    await service.generate();
    final occurrences = await recurring2.watchOccurrences().first;
    expect(occurrences, isNotEmpty);
  });
}
