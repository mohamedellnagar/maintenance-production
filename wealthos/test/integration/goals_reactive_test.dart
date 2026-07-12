import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/di/providers.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/goals/application/goals_providers.dart';
import 'package:wealthos/features/goals/data/goals_repository.dart';
import 'package:wealthos/features/goals/domain/goal_input.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late AccountsRepository accounts;
  late GoalsRepository goals;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => const LocalDate(2026, 6, 15)),
      ],
    );
    await db.customSelect('SELECT 1').get();
    accounts = container.read(accountsRepositoryProvider);
    goals = container.read(goalsRepositoryProvider);
    container.listen(goalViewsProvider, (_, _) {}, fireImmediately: true);
    container.listen(goalsSummaryProvider, (_, _) {}, fireImmediately: true);
    container.listen(allocationShortfallProvider, (_, _) {});
    container.listen(eligibleLiquidAssetsProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 80));

  Future<String> bank({int opening = 500000}) async {
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

  GoalInput input({GoalType type = GoalType.travel, String? liability}) =>
      GoalInput(
        name: 'Trip',
        type: type,
        targetAmountMinor: 400000,
        currencyCode: 'AED',
        priority: GoalPriority.medium,
        linkedLiabilityAccountId: liability,
      );

  test('a contribution flows into the goal view and summary', () async {
    await bank();
    final id = (await goals.createGoal(input())).valueOrNull!.id;
    await settle();
    await goals.contribute(id, 200000);
    await settle();

    final view = container
        .read(goalViewsProvider)
        .firstWhere((v) => v.goal.id == id);
    expect(view.fundedMinor, 200000);
    final summary = container.read(goalsSummaryProvider);
    expect(summary.totalAllocatedMinor, 200000);
    expect(summary.unallocatedMinor, 300000); // 500000 liquid - 200000
  });

  test('spending after allocation raises an Allocation Shortfall', () async {
    final acc = await bank(opening: 500000);
    final id = (await goals.createGoal(input())).valueOrNull!.id;
    await settle();
    await goals.contribute(id, 200000);
    await settle();
    expect(container.read(allocationShortfallProvider).has, isFalse);

    // Spend 400000 → liquid drops to 100000, below the 200000 allocated.
    await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.expense,
            amountMinor: 400000,
            currencyCode: 'AED',
            date: DateTime(2026, 6, 10),
            accountId: acc,
            categoryId: 'sys_exp_other',
          ),
        );
    await settle();

    final shortfall = container.read(allocationShortfallProvider);
    expect(shortfall.has, isTrue);
    expect(shortfall.amountMinor, 100000); // 200000 - 100000
  });

  test('a transfer between goals preserves total allocated', () async {
    await bank();
    final a = (await goals.createGoal(input())).valueOrNull!.id;
    final b = (await goals.createGoal(input())).valueOrNull!.id;
    await settle();
    await goals.contribute(a, 200000);
    await settle();
    final before = container.read(goalsSummaryProvider).totalAllocatedMinor;

    await goals.transferBetweenGoals(a, b, 120000);
    await settle();
    expect(container.read(goalsSummaryProvider).totalAllocatedMinor, before);
  });

  test('a real repayment updates a debt goal actual debt reduced', () async {
    final acc = await bank();
    final loanR = await accounts.create(
      const NewAccountInput(
        name: 'Loan',
        type: AccountType.loan,
        classification: AccountClassification.liability,
        currencyCode: 'AED',
      ),
    );
    final loan = loanR.valueOrNull!.id;
    final id = (await goals.createGoal(
      input(type: GoalType.debtPayoff, liability: loan),
    )).valueOrNull!.id;
    await settle();

    await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.transfer,
            amountMinor: 150000,
            currencyCode: 'AED',
            date: DateTime(2030, 1, 1),
            accountId: acc,
            destinationAccountId: loan,
          ),
        );
    await settle();

    final view = container
        .read(goalViewsProvider)
        .firstWhere((v) => v.goal.id == id);
    expect(view.actualDebtReducedMinor, 150000);
  });
}
