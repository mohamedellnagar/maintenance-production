import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/budgets/domain/budget.dart';
import 'package:wealthos/features/budgets/domain/budget_calculator.dart';
import 'package:wealthos/features/budgets/domain/budget_item.dart';
import 'package:wealthos/features/budgets/domain/budget_rollover.dart';
import 'package:wealthos/features/categories/domain/category.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

final _now = DateTime(2026, 7, 15);

Budget _budget({int year = 2026, int month = 7}) => Budget(
  id: 'b',
  year: year,
  month: month,
  currencyCode: 'AED',
  status: BudgetStatus.active,
  createdAt: _now,
  updatedAt: _now,
);

BudgetItem _item({
  required BudgetItemType type,
  required int assigned,
  String? categoryId,
  String? accountId,
  bool rollover = false,
  String id = 'i',
}) => BudgetItem(
  id: id,
  budgetId: 'b',
  type: type,
  categoryId: categoryId,
  accountId: accountId,
  assignedAmountMinor: assigned,
  rolloverEnabled: rollover,
  displayOrder: 0,
  createdAt: _now,
  updatedAt: _now,
);

Transaction _tx({
  required TransactionType type,
  required int amount,
  String? accountId,
  String? destinationAccountId,
  String? categoryId,
  DateTime? date,
  bool deleted = false,
}) => Transaction(
  id: 't-$amount-${categoryId ?? ''}-${date ?? _now}',
  type: type,
  amountMinor: amount,
  currencyCode: 'AED',
  date: date ?? _now,
  accountId: accountId,
  destinationAccountId: destinationAccountId,
  categoryId: categoryId,
  createdAt: _now,
  updatedAt: _now,
  deletedAt: deleted ? _now : null,
);

Category _cat(String id, {String? parent, String type = 'expense'}) => Category(
  id: id,
  nameAr: id,
  nameEn: id,
  type: CategoryType.fromName(type),
  parentId: parent,
  isSystem: true,
  isArchived: false,
);

void main() {
  group('income', () {
    test('expected income sums incomePlan items', () {
      final items = [
        _item(
          type: BudgetItemType.incomePlan,
          assigned: 500000,
          categoryId: 'salary',
        ),
        _item(
          type: BudgetItemType.incomePlan,
          assigned: 100000,
          categoryId: 'bonus',
          id: 'i2',
        ),
      ];
      expect(BudgetCalculator.expectedIncome(items), 600000);
    });

    test('actual income counts only in-month, non-deleted income', () {
      final txs = [
        _tx(type: TransactionType.income, amount: 500000),
        _tx(
          type: TransactionType.income,
          amount: 999,
          date: DateTime(2026, 6, 30),
        ),
        _tx(type: TransactionType.income, amount: 111, deleted: true),
        _tx(type: TransactionType.expense, amount: 222),
        _tx(
          type: TransactionType.transfer,
          amount: 333,
          accountId: 'a',
          destinationAccountId: 'b',
        ),
      ];
      expect(BudgetCalculator.actualIncome(txs, _budget()), 500000);
    });
  });

  group('assigned & available to assign', () {
    test('total assigned excludes incomePlan; availableToAssign excludes '
        'account balances', () {
      final items = [
        _item(
          type: BudgetItemType.incomePlan,
          assigned: 800000,
          categoryId: 'salary',
        ),
        _item(
          type: BudgetItemType.expense,
          assigned: 300000,
          categoryId: 'food',
          id: 'e',
        ),
        _item(type: BudgetItemType.saving, assigned: 100000, id: 's'),
        _item(
          type: BudgetItemType.debtPayment,
          assigned: 50000,
          accountId: 'loan',
          id: 'd',
        ),
      ];
      final summary = BudgetCalculator.summarize(
        budget: _budget(),
        items: items,
        transactions: const [],
        categories: const [],
        incomingRollovers: const [],
        accountClassifications: const {},
      );
      expect(summary.totalAssignedMinor, 450000);
      // 800000 expected - 450000 assigned = 350000, no account balance leaks in.
      expect(summary.availableToAssignMinor, 350000);
    });

    test('incoming rollover raises availableToAssign', () {
      final items = [
        _item(
          type: BudgetItemType.expense,
          assigned: 100000,
          categoryId: 'food',
          id: 'e',
        ),
      ];
      final rollovers = [
        BudgetRollover(
          id: 'r',
          fromBudgetId: 'prev',
          toBudgetId: 'b',
          sourceBudgetItemId: 's',
          targetBudgetItemId: 'e',
          amountMinor: 25000,
          createdAt: _now,
        ),
      ];
      final summary = BudgetCalculator.summarize(
        budget: _budget(),
        items: items,
        transactions: const [],
        categories: const [],
        incomingRollovers: rollovers,
        accountClassifications: const {},
      );
      // expected 0 + rollover 25000 - assigned 100000 = -75000
      expect(summary.availableToAssignMinor, -75000);
    });
  });

  group('expense item spending & status', () {
    test('actual spent, remaining and overspending', () {
      final item = _item(
        type: BudgetItemType.expense,
        assigned: 100000,
        categoryId: 'food',
      );
      final txs = [
        _tx(type: TransactionType.expense, amount: 40000, categoryId: 'food'),
        _tx(type: TransactionType.expense, amount: 90000, categoryId: 'food'),
        _tx(type: TransactionType.expense, amount: 5000, categoryId: 'other'),
        _tx(
          type: TransactionType.expense,
          amount: 1,
          deleted: true,
          categoryId: 'food',
        ),
      ];
      final results = BudgetCalculator.expenseResults(
        budget: _budget(),
        items: [item],
        transactions: txs,
        categories: const [],
        incomingRollovers: const [],
      );
      final r = results.single;
      expect(r.actualSpentMinor, 130000);
      expect(r.remainingMinor, -30000);
      expect(r.overspent, isTrue);
      expect(r.status, ExpenseItemStatus.overspent);
    });

    test('usage percentage and near-limit status', () {
      final item = _item(
        type: BudgetItemType.expense,
        assigned: 100000,
        categoryId: 'food',
      );
      final txs = [
        _tx(type: TransactionType.expense, amount: 85000, categoryId: 'food'),
      ];
      final r = BudgetCalculator.expenseResults(
        budget: _budget(),
        items: [item],
        transactions: txs,
        categories: const [],
        incomingRollovers: const [],
      ).single;
      expect((r.usageRatio * 100).round(), 85);
      expect(r.status, ExpenseItemStatus.nearLimit);
    });

    test('zero-budget item with no spend is not started; usage guarded', () {
      final item = _item(
        type: BudgetItemType.expense,
        assigned: 0,
        categoryId: 'food',
      );
      final r = BudgetCalculator.expenseResults(
        budget: _budget(),
        items: [item],
        transactions: const [],
        categories: const [],
        incomingRollovers: const [],
      ).single;
      expect(r.usageRatio, 0.0);
      expect(r.status, ExpenseItemStatus.notStarted);
    });
  });

  group('category hierarchy', () {
    test('expense item includes its category and descendants', () {
      final item = _item(
        type: BudgetItemType.expense,
        assigned: 100000,
        categoryId: 'food',
      );
      final cats = [
        _cat('food'),
        _cat('groceries', parent: 'food'),
        _cat('dining', parent: 'food'),
      ];
      final txs = [
        _tx(
          type: TransactionType.expense,
          amount: 30000,
          categoryId: 'groceries',
        ),
        _tx(type: TransactionType.expense, amount: 20000, categoryId: 'dining'),
        _tx(type: TransactionType.expense, amount: 10000, categoryId: 'food'),
      ];
      final r = BudgetCalculator.expenseResults(
        budget: _budget(),
        items: [item],
        transactions: txs,
        categories: cats,
        incomingRollovers: const [],
      ).single;
      expect(r.actualSpentMinor, 60000);
    });
  });

  group('debt payment', () {
    const classifications = {
      'bank': AccountClassification.asset,
      'card': AccountClassification.liability,
    };
    test('counts repayments into the liability, not charges or draw-downs', () {
      final txs = [
        // Repayment: bank -> card
        _tx(
          type: TransactionType.transfer,
          amount: 20000,
          accountId: 'bank',
          destinationAccountId: 'card',
        ),
        // Card purchase (charge) — must NOT count.
        _tx(
          type: TransactionType.expense,
          amount: 15000,
          accountId: 'card',
          categoryId: 'shopping',
        ),
        // Income paid onto the card — counts as a reduction.
        _tx(type: TransactionType.income, amount: 5000, accountId: 'card'),
        // Adjustment on the card — excluded.
        _tx(type: TransactionType.adjustment, amount: 1000, accountId: 'card'),
      ];
      final actual = BudgetCalculator.actualDebtPayment(
        transactions: txs,
        budget: _budget(),
        liabilityAccountId: 'card',
        accountClassifications: classifications,
      );
      expect(actual, 25000);
    });
  });

  group('month boundaries', () {
    test('includes future-dated transactions inside the same month', () {
      final txs = [
        _tx(
          type: TransactionType.income,
          amount: 1000,
          date: DateTime(2026, 7, 31, 23, 59),
        ),
      ];
      expect(BudgetCalculator.actualIncome(txs, _budget()), 1000);
    });

    test('leap-year February end boundary (2028-02-29) is inside February', () {
      final feb = _budget(year: 2028, month: 2);
      expect(feb.monthEndExclusive, DateTime(2028, 3, 1));
      final txs = [
        _tx(
          type: TransactionType.expense,
          amount: 500,
          date: DateTime(2028, 2, 29),
        ),
      ];
      expect(BudgetCalculator.totalActualExpense(txs, feb), 500);
    });

    test('December rolls into next January', () {
      final dec = _budget(year: 2026, month: 12);
      expect(dec.monthEndExclusive, DateTime(2027, 1, 1));
      expect(dec.nextMonth, (year: 2027, month: 1));
    });
  });
}
