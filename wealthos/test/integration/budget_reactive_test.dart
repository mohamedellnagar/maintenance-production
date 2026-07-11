import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/di/providers.dart';
import 'package:wealthos/features/accounts/data/accounts_repository.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/budgets/application/budgets_providers.dart';
import 'package:wealthos/features/budgets/domain/budget.dart';
import 'package:wealthos/features/budgets/domain/budget_item.dart';
import 'package:wealthos/features/budgets/domain/budget_item_input.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

const _month = (year: 2026, month: 7);
final _date = DateTime(2026, 7, 15);

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    await db.customSelect('SELECT 1').get();
    // Keep the reactive chain alive for the whole test.
    container.listen(
      budgetViewProvider(_month),
      (_, _) {},
      fireImmediately: true,
    );
    container.listen(accountClassificationsProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 80));

  Future<Account> account({
    String name = 'Bank',
    AccountType type = AccountType.bank,
    AccountClassification classification = AccountClassification.asset,
  }) async {
    final r = await container
        .read(accountsRepositoryProvider)
        .create(
          NewAccountInput(
            name: name,
            type: type,
            classification: classification,
            currencyCode: 'AED',
          ),
        );
    return r.valueOrNull!;
  }

  Future<Budget> budget() async {
    final r = await container
        .read(budgetsRepositoryProvider)
        .createEmptyBudget(_month.year, _month.month, 'AED');
    return r.valueOrNull!;
  }

  Future<BudgetItem> expenseItem(String budgetId, String categoryId) async {
    final r = await container
        .read(budgetsRepositoryProvider)
        .createItem(
          budgetId,
          BudgetItemInput(
            type: BudgetItemType.expense,
            assignedAmountMinor: 100000,
            categoryId: categoryId,
          ),
        );
    return r.valueOrNull!;
  }

  Future<Transaction> expense({
    required String accountId,
    required int amount,
    required String categoryId,
    DateTime? date,
  }) async {
    final r = await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.expense,
            amountMinor: amount,
            currencyCode: 'AED',
            date: date ?? _date,
            accountId: accountId,
            categoryId: categoryId,
          ),
        );
    return r.valueOrNull!;
  }

  int? actualFor(String categoryId) {
    final view = container.read(budgetViewProvider(_month)).value;
    final match = view?.expenses
        .where((e) => e.item.categoryId == categoryId)
        .toList();
    return match == null || match.isEmpty ? null : match.first.actualSpentMinor;
  }

  test('an expense transaction updates the budget actual reactively', () async {
    final b = await budget();
    await expenseItem(b.id, 'sys_exp_food');
    final bank = await account();
    await settle();
    expect(actualFor('sys_exp_food'), 0);

    await expense(
      accountId: bank.id,
      amount: 30000,
      categoryId: 'sys_exp_food',
    );
    await settle();
    expect(actualFor('sys_exp_food'), 30000);
  });

  test('editing a transaction amount updates the budget', () async {
    final b = await budget();
    await expenseItem(b.id, 'sys_exp_food');
    final bank = await account();
    final tx = await expense(
      accountId: bank.id,
      amount: 30000,
      categoryId: 'sys_exp_food',
    );
    await settle();
    await container
        .read(transactionsRepositoryProvider)
        .update(
          tx.id,
          NewTransactionInput(
            type: TransactionType.expense,
            amountMinor: 50000,
            currencyCode: 'AED',
            date: _date,
            accountId: bank.id,
            categoryId: 'sys_exp_food',
          ),
        );
    await settle();
    expect(actualFor('sys_exp_food'), 50000);
  });

  test('changing a category moves actual between budget items', () async {
    final b = await budget();
    await expenseItem(b.id, 'sys_exp_food');
    await expenseItem(b.id, 'sys_exp_transport');
    final bank = await account();
    final tx = await expense(
      accountId: bank.id,
      amount: 20000,
      categoryId: 'sys_exp_food',
    );
    await settle();
    expect(actualFor('sys_exp_food'), 20000);
    expect(actualFor('sys_exp_transport'), 0);

    await container
        .read(transactionsRepositoryProvider)
        .update(
          tx.id,
          NewTransactionInput(
            type: TransactionType.expense,
            amountMinor: 20000,
            currencyCode: 'AED',
            date: _date,
            accountId: bank.id,
            categoryId: 'sys_exp_transport',
          ),
        );
    await settle();
    expect(actualFor('sys_exp_food'), 0);
    expect(actualFor('sys_exp_transport'), 20000);
  });

  test('deleting then restoring a transaction updates the budget', () async {
    final b = await budget();
    await expenseItem(b.id, 'sys_exp_food');
    final bank = await account();
    final tx = await expense(
      accountId: bank.id,
      amount: 15000,
      categoryId: 'sys_exp_food',
    );
    await settle();
    expect(actualFor('sys_exp_food'), 15000);

    await container.read(transactionsRepositoryProvider).softDelete(tx.id);
    await settle();
    expect(actualFor('sys_exp_food'), 0);

    await container.read(transactionsRepositoryProvider).restore(tx.id);
    await settle();
    expect(actualFor('sys_exp_food'), 15000);
  });

  test('a repayment updates the debt budget; a card charge does not', () async {
    final b = await budget();
    final bank = await account();
    final card = await account(
      name: 'Card',
      type: AccountType.creditCard,
      classification: AccountClassification.liability,
    );
    await container
        .read(budgetsRepositoryProvider)
        .createItem(
          b.id,
          BudgetItemInput(
            type: BudgetItemType.debtPayment,
            assignedAmountMinor: 100000,
            accountId: card.id,
          ),
        );
    await settle();

    // A charge on the card must NOT count as a repayment.
    await expense(
      accountId: card.id,
      amount: 5000,
      categoryId: 'sys_exp_shopping',
    );
    await settle();
    var view = container.read(budgetViewProvider(_month)).value;
    expect(view!.debts.single.actualMinor, 0);

    // A transfer bank → card is a repayment.
    await container
        .read(transactionsRepositoryProvider)
        .create(
          NewTransactionInput(
            type: TransactionType.transfer,
            amountMinor: 20000,
            currencyCode: 'AED',
            date: _date,
            accountId: bank.id,
            destinationAccountId: card.id,
          ),
        );
    await settle();
    view = container.read(budgetViewProvider(_month)).value;
    expect(view!.debts.single.actualMinor, 20000);
  });
}
