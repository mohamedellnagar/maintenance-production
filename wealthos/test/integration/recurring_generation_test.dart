import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/recurring/application/recurrence_generation_service.dart';
import 'package:wealthos/features/recurring/data/recurring_repository.dart';
import 'package:wealthos/features/recurring/domain/recurring_rule_input.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';

void main() {
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

  Future<String> asset() async {
    final r = await accounts.create(
      const NewAccountInput(
        name: 'Bank',
        type: AccountType.bank,
        classification: AccountClassification.asset,
        currencyCode: 'AED',
        openingBalanceMinor: 10000000,
      ),
    );
    return r.valueOrNull!.id;
  }

  Future<String> createRule({bool autoCreate = false}) async {
    final acc = await asset();
    final r = await recurring.createRule(
      RecurringRuleInput(
        name: 'Rent',
        type: RecurringType.expense,
        amountMinor: 500000,
        currencyCode: 'AED',
        frequency: RecurrenceFrequency.monthly,
        monthlyDay: 1,
        startDate: const LocalDate(2026, 1, 1),
        accountId: acc,
        categoryId: 'sys_exp_housing',
        autoCreateTransaction: autoCreate,
      ),
    );
    return r.valueOrNull!.id;
  }

  RecurrenceGenerationService service(
    LocalDate today, {
    bool autoCreate = false,
  }) => RecurrenceGenerationService(
    repository: recurring,
    today: () => today,
    autoCreateEnabled: () async => autoCreate,
  );

  test('generation is idempotent across repeated runs', () async {
    await createRule();
    final svc = service(const LocalDate(2026, 3, 15));
    await svc.generate();
    final firstCount = (await recurring.watchOccurrences().first).length;
    await svc.generate();
    final secondCount = (await recurring.watchOccurrences().first).length;
    expect(secondCount, firstCount);
    expect(firstCount, greaterThan(0));
  });

  test('a long absence backfills missed occurrences as overdue', () async {
    await createRule();
    // Rule started Jan 1; app first opens in June. Backfill + horizon should
    // include the earlier months' occurrences (Apr onward within backfill).
    await service(const LocalDate(2026, 6, 15)).generate();
    final occ = await recurring.watchOccurrences().first;
    // At least one occurrence dated before "today" exists (overdue).
    expect(
      occ.any((o) => o.dueDate.isBefore(const LocalDate(2026, 6, 15))),
      isTrue,
    );
  });

  test('auto-create posts due occurrences only when enabled', () async {
    await createRule(autoCreate: true);

    // Disabled: nothing is posted.
    await service(const LocalDate(2026, 2, 15)).generateAndAutoCreate();
    expect(await transactions.getAll(), isEmpty);

    // Enabled: due/overdue occurrences post exactly once.
    await service(
      const LocalDate(2026, 2, 15),
      autoCreate: true,
    ).generateAndAutoCreate();
    final afterFirst = (await transactions.getAll()).length;
    expect(afterFirst, greaterThan(0));

    // Running again does not double-post.
    await service(
      const LocalDate(2026, 2, 15),
      autoCreate: true,
    ).generateAndAutoCreate();
    expect((await transactions.getAll()).length, afterFirst);
  });

  test('auto-create never posts future occurrences', () async {
    await createRule(autoCreate: true);
    // Today is before the first due date.
    await service(
      const LocalDate(2025, 12, 15),
      autoCreate: true,
    ).generateAndAutoCreate();
    expect(await transactions.getAll(), isEmpty);
  });
}
