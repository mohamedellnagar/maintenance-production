import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_balance.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/accounts/domain/balance_calculator.dart';
import 'package:wealthos/features/dashboard/domain/net_worth.dart';
import 'package:wealthos/features/transactions/data/transactions_repository.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

void main() {
  late AppDatabase db;
  late AccountsRepository accounts;
  late TransactionsRepository transactions;

  final date = DateTime(2026, 7, 11);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    accounts = AccountsRepository(db);
    transactions = TransactionsRepository(db);
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() => db.close());

  Future<Account> createAccount({
    required String name,
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
    return result.valueOrNull!;
  }

  Future<int> signedBalance(Account account) async {
    final all = await transactions.getAll();
    return BalanceCalculator.signedBalanceMinor(account, all);
  }

  Future<Account> reload(Account a) async => (await accounts.getById(a.id))!;

  NewTransactionInput tx({
    required TransactionType type,
    required int amount,
    String? accountId,
    String? destinationAccountId,
    String? categoryId,
    String? reason,
  }) => NewTransactionInput(
    type: type,
    amountMinor: amount,
    currencyCode: 'AED',
    date: date,
    accountId: accountId,
    destinationAccountId: destinationAccountId,
    categoryId: categoryId,
    adjustmentReason: reason,
  );

  group('liability operations', () {
    test('credit-card purchase increases debt and counts as expense', () async {
      final card = await createAccount(
        name: 'Card',
        type: AccountType.creditCard,
      );
      final r = await transactions.create(
        tx(
          type: TransactionType.expense,
          amount: 10000,
          accountId: card.id,
          categoryId: 'sys_exp_shopping',
        ),
      );
      expect(r.isSuccess, isTrue);
      // signed -10000 => outstanding 10000.
      expect(await signedBalance(card), -10000);
      final expense = NetWorthCalculator.monthlyExpense(
        await transactions.getAll(),
        month: date,
        currencyCode: 'AED',
      );
      expect(expense.amountMinor, 10000);
    });

    test('credit-card repayment reduces cash and debt, no cash-flow', () async {
      final bank = await createAccount(name: 'Bank', opening: 100000);
      final card = await createAccount(
        name: 'Card',
        type: AccountType.creditCard,
        opening: -50000, // owes 500
      );
      final r = await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 20000,
          accountId: bank.id,
          destinationAccountId: card.id,
        ),
      );
      expect(r.isSuccess, isTrue);
      expect(await signedBalance(bank), 80000); // 1000 - 200
      expect(await signedBalance(card), -30000); // owes 300 now
      final income = NetWorthCalculator.monthlyIncome(
        await transactions.getAll(),
        month: date,
        currencyCode: 'AED',
      );
      final expense = NetWorthCalculator.monthlyExpense(
        await transactions.getAll(),
        month: date,
        currencyCode: 'AED',
      );
      expect(income.amountMinor, 0);
      expect(expense.amountMinor, 0);
    });

    test('loan receipt: cash up, debt up (transfer from the loan)', () async {
      final bank = await createAccount(name: 'Bank');
      final loan = await createAccount(name: 'Loan', type: AccountType.loan);
      await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 300000,
          accountId: loan.id,
          destinationAccountId: bank.id,
        ),
      );
      expect(await signedBalance(bank), 300000); // received cash
      expect(await signedBalance(loan), -300000); // owes 3000
    });

    test('loan repayment reduces debt', () async {
      final bank = await createAccount(name: 'Bank', opening: 500000);
      final loan = await createAccount(
        name: 'Loan',
        type: AccountType.loan,
        opening: -300000,
      );
      await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 100000,
          accountId: bank.id,
          destinationAccountId: loan.id,
        ),
      );
      expect(await signedBalance(bank), 400000);
      expect(await signedBalance(loan), -200000); // owes 2000
    });

    test('loan interest is an expense that increases the debt', () async {
      final loan = await createAccount(
        name: 'Loan',
        type: AccountType.loan,
        opening: -300000,
      );
      await transactions.create(
        tx(
          type: TransactionType.expense,
          amount: 5000,
          accountId: loan.id,
          categoryId: 'sys_exp_bills',
        ),
      );
      expect(await signedBalance(loan), -305000); // owes 3050
      final expense = NetWorthCalculator.monthlyExpense(
        await transactions.getAll(),
        month: date,
        currencyCode: 'AED',
      );
      expect(expense.amountMinor, 5000);
    });
  });

  group('edit transaction', () {
    test('editing the amount recomputes the balance', () async {
      final bank = await createAccount(name: 'Bank', opening: 100000);
      final created = await transactions.create(
        tx(type: TransactionType.expense, amount: 20000, accountId: bank.id),
      );
      final id = created.valueOrNull!.id;
      expect(await signedBalance(bank), 80000);

      final updated = await transactions.update(
        id,
        tx(type: TransactionType.expense, amount: 50000, accountId: bank.id),
      );
      expect(updated.isSuccess, isTrue);
      expect(await signedBalance(bank), 50000);
    });

    test('editing a transfer moves both endpoints atomically', () async {
      final a = await createAccount(name: 'A', opening: 100000);
      final b = await createAccount(name: 'B');
      final c = await createAccount(name: 'C');
      final created = await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 30000,
          accountId: a.id,
          destinationAccountId: b.id,
        ),
      );
      // Redirect the transfer to account C with a new amount.
      await transactions.update(
        created.valueOrNull!.id,
        tx(
          type: TransactionType.transfer,
          amount: 40000,
          accountId: a.id,
          destinationAccountId: c.id,
        ),
      );
      expect(await signedBalance(a), 60000);
      expect(await signedBalance(b), 0); // no longer affected
      expect(await signedBalance(c), 40000);
    });

    test('changing type income→expense flips the effect', () async {
      final bank = await createAccount(name: 'Bank', opening: 100000);
      final created = await transactions.create(
        tx(type: TransactionType.income, amount: 20000, accountId: bank.id),
      );
      expect(await signedBalance(bank), 120000);
      await transactions.update(
        created.valueOrNull!.id,
        tx(type: TransactionType.expense, amount: 20000, accountId: bank.id),
      );
      expect(await signedBalance(bank), 80000);
    });

    test('editing to a non-existent transaction fails', () async {
      final bank = await createAccount(name: 'Bank');
      final r = await transactions.update(
        'missing',
        tx(type: TransactionType.income, amount: 1000, accountId: bank.id),
      );
      expect(r.isFailure, isTrue);
    });
  });

  group('delete & restore', () {
    test(
      'deleting a transfer removes its effect; restore brings it back',
      () async {
        final a = await createAccount(name: 'A', opening: 100000);
        final b = await createAccount(name: 'B');
        final created = await transactions.create(
          tx(
            type: TransactionType.transfer,
            amount: 40000,
            accountId: a.id,
            destinationAccountId: b.id,
          ),
        );
        final id = created.valueOrNull!.id;
        expect(await signedBalance(a), 60000);
        expect(await signedBalance(b), 40000);

        await transactions.softDelete(id);
        expect(await signedBalance(a), 100000);
        expect(await signedBalance(b), 0);
        expect((await transactions.getAll()).isEmpty, isTrue);

        await transactions.restore(id);
        expect(await signedBalance(a), 60000);
        expect(await signedBalance(b), 40000);
        // Restored the same row, not a new one.
        expect((await transactions.getAll()).length, 1);
      },
    );

    test('deleting an adjustment reverses its effect', () async {
      final bank = await createAccount(name: 'Bank', opening: 100000);
      final created = await transactions.create(
        tx(
          type: TransactionType.adjustment,
          amount: -25000,
          accountId: bank.id,
          reason: 'reconcile',
        ),
      );
      expect(await signedBalance(bank), 75000);
      await transactions.softDelete(created.valueOrNull!.id);
      expect(await signedBalance(bank), 100000);
    });

    test('repeated delete is an idempotent success', () async {
      final bank = await createAccount(name: 'Bank');
      final created = await transactions.create(
        tx(type: TransactionType.income, amount: 1000, accountId: bank.id),
      );
      final id = created.valueOrNull!.id;
      expect((await transactions.softDelete(id)).isSuccess, isTrue);
      expect((await transactions.softDelete(id)).isSuccess, isTrue);
    });
  });

  group('integrity', () {
    test('rejects a transaction on an archived account', () async {
      final bank = await createAccount(name: 'Bank');
      await accounts.setArchived(bank.id, archived: true);
      final r = await transactions.create(
        tx(type: TransactionType.income, amount: 1000, accountId: bank.id),
      );
      expect(r.isFailure, isTrue);
      expect((await transactions.getAll()).isEmpty, isTrue);
    });

    test('rejects a transfer into an archived account', () async {
      final a = await createAccount(name: 'A');
      final b = await createAccount(name: 'B');
      await accounts.setArchived(b.id, archived: true);
      final r = await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 1000,
          accountId: a.id,
          destinationAccountId: b.id,
        ),
      );
      expect(r.isFailure, isTrue);
    });

    test('rejects an archived category', () async {
      final bank = await createAccount(name: 'Bank');
      await (db.update(db.categoriesTable)
            ..where((c) => c.id.equals('sys_exp_food')))
          .write(const CategoriesTableCompanion(isArchived: Value(true)));
      final r = await transactions.create(
        tx(
          type: TransactionType.expense,
          amount: 1000,
          accountId: bank.id,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(r.isFailure, isTrue);
    });

    test('rejects an income using an expense category', () async {
      final bank = await createAccount(name: 'Bank');
      final r = await transactions.create(
        tx(
          type: TransactionType.income,
          amount: 1000,
          accountId: bank.id,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(r.isFailure, isTrue);
    });

    test('rejects a category attached to a transfer', () async {
      final a = await createAccount(name: 'A');
      final b = await createAccount(name: 'B');
      final r = await transactions.create(
        tx(
          type: TransactionType.transfer,
          amount: 1000,
          accountId: a.id,
          destinationAccountId: b.id,
          categoryId: 'sys_exp_food',
        ),
      );
      expect(r.isFailure, isTrue);
    });

    test(
      'rejects a transaction currency that is not the base currency',
      () async {
        final bank = await createAccount(name: 'Bank');
        final r = await transactions.create(
          NewTransactionInput(
            type: TransactionType.income,
            amountMinor: 1000,
            currencyCode: 'USD',
            date: date,
            accountId: bank.id,
          ),
        );
        expect(r.isFailure, isTrue);
      },
    );

    test(
      'foreign keys are enforced (bad account reference rejected)',
      () async {
        // A raw insert bypassing the repository must still fail on the FK.
        await expectLater(
          db
              .into(db.transactionsTable)
              .insert(
                TransactionsTableCompanion.insert(
                  id: 'raw',
                  transactionType: 'income',
                  accountId: const Value('does-not-exist'),
                  amountMinor: 1000,
                  currencyCode: 'AED',
                  transactionDate: date,
                  createdAt: date,
                  updatedAt: date,
                ),
              ),
          throwsA(anything),
        );
      },
    );
  });

  group('summaries exclude deleted', () {
    test('net worth and monthly totals ignore soft-deleted rows', () async {
      final bank = await createAccount(name: 'Bank', opening: 100000);
      final income = await transactions.create(
        tx(type: TransactionType.income, amount: 50000, accountId: bank.id),
      );
      await transactions.create(
        tx(type: TransactionType.expense, amount: 20000, accountId: bank.id),
      );
      await transactions.softDelete(income.valueOrNull!.id);

      final all = await transactions.getAll();
      final reloaded = await reload(bank);
      final balance = AccountBalance.fromSigned(
        reloaded,
        BalanceCalculator.signedBalanceMinor(reloaded, all),
      );
      expect(balance.signedBalanceMinor, 80000); // 100000 - 20000

      final summary = NetWorthCalculator.summarize(
        [reloaded],
        all,
        currencyCode: 'AED',
      );
      expect(summary.netWorth.amountMinor, 80000);
      expect(
        NetWorthCalculator.monthlyIncome(
          all,
          month: date,
          currencyCode: 'AED',
        ).amountMinor,
        0,
      );
    });
  });
}
