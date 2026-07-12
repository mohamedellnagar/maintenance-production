import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/accounts/domain/balance_calculator.dart';
import 'package:wealthos/features/settings/data/settings_repository.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

void main() {
  late AppDatabase db;
  late AccountsRepository accounts;
  late TransactionsRepository transactions;
  late SettingsRepository settings;

  final date = DateTime(2026, 7, 11);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    accounts = AccountsRepository(db);
    transactions = TransactionsRepository(db);
    settings = SettingsRepository(db);
    // Touch the database so migration onCreate (createAll + seed) runs.
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> createAccount({
    String name = 'Bank',
    AccountType type = AccountType.bank,
    int opening = 0,
  }) async {
    final result = await accounts.create(
      NewAccountInput(
        name: name,
        type: type,
        classification: type.defaultClassification,
        currencyCode: 'AED',
        openingBalanceMinor: opening,
      ),
    );
    return result.valueOrNull!.id;
  }

  group('migrations & schema', () {
    test('schema version is 4 and all tables are queryable', () async {
      expect(db.schemaVersion, 4);
      await db.select(db.accountsTable).get();
      await db.select(db.transactionsTable).get();
      await db.select(db.categoriesTable).get();
      await db.select(db.appSettingsTable).get();
      await db.select(db.recurringRulesTable).get();
      await db.select(db.recurringRuleWeekdaysTable).get();
      await db.select(db.recurringOccurrencesTable).get();
      await db.select(db.financialGoalsTable).get();
      await db.select(db.goalFundsTable).get();
      await db.select(db.goalFundEntriesTable).get();
      await db.select(db.goalTransactionAllocationsTable).get();
    });
  });

  group('category seeding', () {
    test('seeds the default set exactly once (idempotent)', () async {
      final first = await db.select(db.categoriesTable).get();
      expect(first.length, 16);

      // Re-running the seed must not create duplicates.
      await db.seedDefaultCategories();
      await db.seedDefaultCategories();
      final again = await db.select(db.categoriesTable).get();
      expect(again.length, 16);
    });
  });

  group('accounts', () {
    test('creation persists and is retrievable', () async {
      final id = await createAccount(name: 'Emirates NBD', opening: 100000);
      final fetched = await accounts.getById(id);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Emirates NBD');
      expect(fetched.openingBalanceMinor, 100000);
      expect((await accounts.getAll()).length, 1);
    });

    test(
      'rejects an account whose currency is not the base currency',
      () async {
        await settings.update(baseCurrency: 'AED');
        final result = await accounts.create(
          NewAccountInput(
            name: 'Dollar',
            type: AccountType.bank,
            classification: AccountClassification.asset,
            currencyCode: 'USD',
          ),
        );
        expect(result.isFailure, isTrue);
      },
    );

    test('archiving hides the account from the default list', () async {
      final id = await createAccount();
      await accounts.setArchived(id, archived: true);
      expect((await accounts.getAll()).isEmpty, isTrue);
      expect((await accounts.getAll(includeArchived: true)).length, 1);
    });
  });

  group('transactions', () {
    test('income creation persists', () async {
      final id = await createAccount();
      final result = await transactions.create(
        NewTransactionInput(
          type: TransactionType.income,
          amountMinor: 5000,
          currencyCode: 'AED',
          date: date,
          accountId: id,
        ),
      );
      expect(result.isSuccess, isTrue);
      expect((await transactions.getAll()).length, 1);
    });

    test(
      'transfer is atomic: a bad destination rolls everything back',
      () async {
        final source = await createAccount(name: 'A');
        final result = await transactions.create(
          NewTransactionInput(
            type: TransactionType.transfer,
            amountMinor: 1000,
            currencyCode: 'AED',
            date: date,
            accountId: source,
            destinationAccountId: 'does-not-exist',
          ),
        );
        expect(result.isFailure, isTrue);
        // Nothing was written.
        expect((await transactions.getAll()).isEmpty, isTrue);
      },
    );

    test('valid transfer moves balance between accounts', () async {
      final a = await createAccount(name: 'A', opening: 10000);
      final b = await createAccount(name: 'B', opening: 0);
      final result = await transactions.create(
        NewTransactionInput(
          type: TransactionType.transfer,
          amountMinor: 4000,
          currencyCode: 'AED',
          date: date,
          accountId: a,
          destinationAccountId: b,
        ),
      );
      expect(result.isSuccess, isTrue);

      final all = await transactions.getAll();
      final accA = await accounts.getById(a);
      final accB = await accounts.getById(b);
      expect(BalanceCalculator.balanceOf(accA!, all).amountMinor, 6000);
      expect(BalanceCalculator.balanceOf(accB!, all).amountMinor, 4000);
    });

    test('invalid transfer (same account) is rejected before insert', () async {
      final a = await createAccount();
      final result = await transactions.create(
        NewTransactionInput(
          type: TransactionType.transfer,
          amountMinor: 1000,
          currencyCode: 'AED',
          date: date,
          accountId: a,
          destinationAccountId: a,
        ),
      );
      expect(result.isFailure, isTrue);
      expect((await transactions.getAll()).isEmpty, isTrue);
    });

    test('soft delete removes it from queries but keeps the row', () async {
      final id = await createAccount();
      final created = await transactions.create(
        NewTransactionInput(
          type: TransactionType.expense,
          amountMinor: 2000,
          currencyCode: 'AED',
          date: date,
          accountId: id,
        ),
      );
      final txId = created.valueOrNull!.id;
      await transactions.softDelete(txId);

      expect((await transactions.getAll()).isEmpty, isTrue);
      // The underlying row still exists with a deletedAt timestamp.
      final rows = await db.select(db.transactionsTable).get();
      expect(rows.length, 1);
      expect(rows.first.deletedAt, isNotNull);
    });
  });
}
