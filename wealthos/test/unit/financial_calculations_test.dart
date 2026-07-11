import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/accounts/domain/balance_calculator.dart';
import 'package:wealthos/features/dashboard/domain/net_worth.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_effect.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

const aed = 'AED';
final _now = DateTime(2026, 7, 11);

Account _account({
  required String id,
  AccountType type = AccountType.bank,
  AccountClassification classification = AccountClassification.asset,
  int opening = 0,
}) => Account(
  id: id,
  name: id,
  type: type,
  classification: classification,
  currencyCode: aed,
  openingBalanceMinor: opening,
  displayOrder: 0,
  isArchived: false,
  createdAt: _now,
  updatedAt: _now,
);

Transaction _tx({
  required TransactionType type,
  required int amount,
  String? accountId,
  String? destinationAccountId,
  DateTime? date,
  DateTime? deletedAt,
}) => Transaction(
  id: 't-${type.name}-$amount-${accountId ?? ''}-${destinationAccountId ?? ''}',
  type: type,
  amountMinor: amount,
  currencyCode: aed,
  date: date ?? _now,
  accountId: accountId,
  destinationAccountId: destinationAccountId,
  createdAt: _now,
  updatedAt: _now,
  deletedAt: deletedAt,
);

void main() {
  group('TransactionEffect', () {
    test('income increases the source account', () {
      final tx = _tx(type: TransactionType.income, amount: 500, accountId: 'a');
      expect(TransactionEffect.deltaFor(tx, 'a'), 500);
      expect(TransactionEffect.deltaFor(tx, 'b'), 0);
    });

    test('expense decreases the source account', () {
      final tx = _tx(
        type: TransactionType.expense,
        amount: 500,
        accountId: 'a',
      );
      expect(TransactionEffect.deltaFor(tx, 'a'), -500);
    });

    test('transfer debits source and credits destination', () {
      final tx = _tx(
        type: TransactionType.transfer,
        amount: 300,
        accountId: 'a',
        destinationAccountId: 'b',
      );
      expect(TransactionEffect.deltaFor(tx, 'a'), -300);
      expect(TransactionEffect.deltaFor(tx, 'b'), 300);
      expect(TransactionEffect.deltaFor(tx, 'c'), 0);
    });

    test('adjustment applies a signed delta', () {
      final positive = _tx(
        type: TransactionType.adjustment,
        amount: 100,
        accountId: 'a',
      );
      final negative = _tx(
        type: TransactionType.adjustment,
        amount: -100,
        accountId: 'a',
      );
      expect(TransactionEffect.deltaFor(positive, 'a'), 100);
      expect(TransactionEffect.deltaFor(negative, 'a'), -100);
    });

    test('soft-deleted transactions have no effect', () {
      final tx = _tx(
        type: TransactionType.income,
        amount: 500,
        accountId: 'a',
        deletedAt: _now,
      );
      expect(TransactionEffect.deltaFor(tx, 'a'), 0);
    });
  });

  group('BalanceCalculator', () {
    test('balance = opening + effects', () {
      final account = _account(id: 'a', opening: 10000);
      final txs = [
        _tx(type: TransactionType.income, amount: 5000, accountId: 'a'),
        _tx(type: TransactionType.expense, amount: 2000, accountId: 'a'),
        _tx(
          type: TransactionType.transfer,
          amount: 1000,
          accountId: 'a',
          destinationAccountId: 'b',
        ),
      ];
      // 10000 + 5000 - 2000 - 1000 = 12000
      expect(BalanceCalculator.balanceOf(account, txs).amountMinor, 12000);
    });

    test('destination account receives transfer credit', () {
      final dest = _account(id: 'b', opening: 0);
      final txs = [
        _tx(
          type: TransactionType.transfer,
          amount: 1000,
          accountId: 'a',
          destinationAccountId: 'b',
        ),
      ];
      expect(BalanceCalculator.balanceOf(dest, txs).amountMinor, 1000);
    });

    test('liability: expense increases owed, income reduces owed', () {
      // Credit card with 500 owed => opening -50000 (net-worth convention).
      final card = _account(
        id: 'card',
        type: AccountType.creditCard,
        classification: AccountClassification.liability,
        opening: -50000,
      );
      final txs = [
        // Spend 100 on the card -> owe more (-10000).
        _tx(type: TransactionType.expense, amount: 10000, accountId: 'card'),
        // Pay 200 into the card -> owe less (+20000).
        _tx(type: TransactionType.income, amount: 20000, accountId: 'card'),
      ];
      // -50000 - 10000 + 20000 = -40000 (owe 400).
      expect(BalanceCalculator.balanceOf(card, txs).amountMinor, -40000);
    });
  });

  group('NetWorthCalculator', () {
    test('net worth = assets - liabilities', () {
      final accounts = [
        _account(id: 'cash', opening: 100000),
        _account(id: 'bank', opening: 250000),
        _account(
          id: 'card',
          type: AccountType.creditCard,
          classification: AccountClassification.liability,
          opening: -50000,
        ),
      ];
      final summary = NetWorthCalculator.summarize(
        accounts,
        const [],
        currencyCode: aed,
      );
      expect(summary.totalAssets.amountMinor, 350000);
      expect(summary.totalLiabilities.amountMinor, 50000);
      expect(summary.netWorth.amountMinor, 300000);
    });

    test('monthly income sums only income in the month', () {
      final txs = [
        _tx(
          type: TransactionType.income,
          amount: 5000,
          accountId: 'a',
          date: DateTime(2026, 7, 5),
        ),
        _tx(
          type: TransactionType.income,
          amount: 3000,
          accountId: 'a',
          date: DateTime(2026, 6, 30),
        ),
        _tx(
          type: TransactionType.expense,
          amount: 9999,
          accountId: 'a',
          date: DateTime(2026, 7, 6),
        ),
        _tx(
          type: TransactionType.transfer,
          amount: 1000,
          accountId: 'a',
          destinationAccountId: 'b',
          date: DateTime(2026, 7, 6),
        ),
      ];
      final income = NetWorthCalculator.monthlyIncome(
        txs,
        month: DateTime(2026, 7, 1),
        currencyCode: aed,
      );
      expect(income.amountMinor, 5000);
    });

    test('monthly expense excludes transfers and adjustments', () {
      final txs = [
        _tx(
          type: TransactionType.expense,
          amount: 2000,
          accountId: 'a',
          date: DateTime(2026, 7, 5),
        ),
        _tx(
          type: TransactionType.adjustment,
          amount: 500,
          accountId: 'a',
          date: DateTime(2026, 7, 5),
        ),
        _tx(
          type: TransactionType.transfer,
          amount: 700,
          accountId: 'a',
          destinationAccountId: 'b',
          date: DateTime(2026, 7, 5),
        ),
      ];
      final expense = NetWorthCalculator.monthlyExpense(
        txs,
        month: DateTime(2026, 7, 1),
        currencyCode: aed,
      );
      expect(expense.amountMinor, 2000);
    });
  });
}
