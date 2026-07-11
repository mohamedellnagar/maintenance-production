import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/di/providers.dart';
import 'package:wealthos/features/accounts/application/accounts_providers.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_balance.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/transactions/application/transactions_providers.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 60));

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<Account> createAccount({int opening = 0}) async {
    final r = await container
        .read(accountsRepositoryProvider)
        .create(
          NewAccountInput(
            name: 'Bank',
            type: AccountType.bank,
            classification: AccountClassification.asset,
            currencyCode: 'AED',
            openingBalanceMinor: opening,
          ),
        );
    return r.valueOrNull!;
  }

  test('allTransactionsProvider reacts to create and delete', () async {
    final account = await createAccount();
    final emissions = <List<Transaction>>[];
    final sub = container.listen(allTransactionsProvider, (_, next) {
      if (next.hasValue) emissions.add(next.value!);
    }, fireImmediately: true);
    addTearDown(sub.close);
    await _settle();

    final created = await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.income,
            amountMinor: 50000,
            currencyCode: 'AED',
            date: DateTime(2026, 7, 11),
            accountId: account.id,
          ),
        );
    await _settle();
    expect(emissions.last.length, 1);

    await container
        .read(transactionsRepositoryProvider)
        .softDelete(created.valueOrNull!.id);
    await _settle();
    expect(emissions.last, isEmpty);
  });

  test('account balance provider recomputes after a transaction', () async {
    final account = await createAccount(opening: 100000);
    // Prime the transactions stream.
    final sub = container.listen(allTransactionsProvider, (_, _) {});
    addTearDown(sub.close);
    await _settle();

    AccountBalance? balance() =>
        container.read(accountBalanceProvider(account));
    expect(balance()?.signedBalanceMinor, 100000);

    await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.expense,
            amountMinor: 30000,
            currencyCode: 'AED',
            date: DateTime(2026, 7, 11),
            accountId: account.id,
          ),
        );
    await _settle();
    expect(balance()?.signedBalanceMinor, 70000);
  });
}
