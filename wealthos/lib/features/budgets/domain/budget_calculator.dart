import '../../accounts/domain/account_type.dart';
import '../../categories/domain/category.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_semantic.dart';
import '../../transactions/domain/transaction_type.dart';
import 'budget.dart';
import 'budget_item.dart';
import 'budget_rollover.dart';
import 'budget_thresholds.dart';

/// Textual status of an expense item (never expressed by color alone).
enum ExpenseItemStatus { notStarted, onTrack, nearLimit, overspent }

class ExpenseItemResult {
  const ExpenseItemResult({
    required this.item,
    required this.assignedMinor,
    required this.rolloverInMinor,
    required this.actualSpentMinor,
  });

  final BudgetItem item;
  final int assignedMinor;
  final int rolloverInMinor;
  final int actualSpentMinor;

  /// Money available to spend = assigned + carried-in.
  int get budgetedMinor => assignedMinor + rolloverInMinor;
  int get remainingMinor => budgetedMinor - actualSpentMinor;
  bool get overspent => actualSpentMinor > budgetedMinor;

  /// Consumption ratio (may exceed 1.0). 0 when nothing is budgeted or spent.
  double get usageRatio {
    if (budgetedMinor <= 0) return actualSpentMinor > 0 ? 1.0 : 0.0;
    return actualSpentMinor / budgetedMinor;
  }

  ExpenseItemStatus get status {
    if (overspent) return ExpenseItemStatus.overspent;
    if (actualSpentMinor == 0) return ExpenseItemStatus.notStarted;
    if (usageRatio >= BudgetThresholds.nearLimitRatio) {
      return ExpenseItemStatus.nearLimit;
    }
    return ExpenseItemStatus.onTrack;
  }
}

class IncomePlanItemResult {
  const IncomePlanItemResult({
    required this.item,
    required this.plannedMinor,
    required this.actualMinor,
  });

  final BudgetItem item;
  final int plannedMinor;
  final int actualMinor;
  int get varianceMinor => actualMinor - plannedMinor;
}

class DebtPaymentItemResult {
  const DebtPaymentItemResult({
    required this.item,
    required this.plannedMinor,
    required this.actualMinor,
  });

  final BudgetItem item;
  final int plannedMinor;
  final int actualMinor;
  int get remainingMinor => plannedMinor - actualMinor;
}

class SavingItemResult {
  const SavingItemResult({required this.item, required this.plannedMinor});
  final BudgetItem item;
  final int plannedMinor;
}

/// Aggregated month figures.
class BudgetSummary {
  const BudgetSummary({
    required this.currencyCode,
    required this.expectedIncomeMinor,
    required this.actualIncomeMinor,
    required this.assignedExpenseMinor,
    required this.assignedSavingMinor,
    required this.assignedDebtPaymentMinor,
    required this.incomingRolloverMinor,
    required this.totalActualExpenseMinor,
    required this.totalRemainingMinor,
    required this.overspentCount,
  });

  final String currencyCode;
  final int expectedIncomeMinor;
  final int actualIncomeMinor;
  final int assignedExpenseMinor;
  final int assignedSavingMinor;
  final int assignedDebtPaymentMinor;
  final int incomingRolloverMinor;
  final int totalActualExpenseMinor;
  final int totalRemainingMinor;
  final int overspentCount;

  int get totalAssignedMinor =>
      assignedExpenseMinor + assignedSavingMinor + assignedDebtPaymentMinor;

  /// Account balances never enter this: purely a plan-vs-plan figure.
  int get availableToAssignMinor =>
      expectedIncomeMinor + incomingRolloverMinor - totalAssignedMinor;
}

/// Pure budget math. Every rule here is unit-tested. Transactions passed in may
/// be the full non-deleted set; month filtering happens inside.
abstract final class BudgetCalculator {
  const BudgetCalculator._();

  static List<ExpenseItemResult> expenseResults({
    required Budget budget,
    required List<BudgetItem> items,
    required List<Transaction> transactions,
    required List<Category> categories,
    required List<BudgetRollover> incomingRollovers,
  }) {
    final childrenByParent = _childrenByParent(categories);
    return items.where((i) => i.type == BudgetItemType.expense).map((item) {
      final categoryIds = _categoryAndDescendants(
        item.categoryId,
        childrenByParent,
      );
      final actual = _sumExpenseInMonth(transactions, budget, categoryIds);
      final rolloverIn = _rolloverInto(incomingRollovers, item.id);
      return ExpenseItemResult(
        item: item,
        assignedMinor: item.assignedAmountMinor,
        rolloverInMinor: rolloverIn,
        actualSpentMinor: actual,
      );
    }).toList();
  }

  static List<IncomePlanItemResult> incomeResults({
    required Budget budget,
    required List<BudgetItem> items,
    required List<Transaction> transactions,
  }) {
    return items.where((i) => i.type == BudgetItemType.incomePlan).map((item) {
      final actual = _sumIncomeForCategory(
        transactions,
        budget,
        item.categoryId,
      );
      return IncomePlanItemResult(
        item: item,
        plannedMinor: item.assignedAmountMinor,
        actualMinor: actual,
      );
    }).toList();
  }

  static List<DebtPaymentItemResult> debtResults({
    required Budget budget,
    required List<BudgetItem> items,
    required List<Transaction> transactions,
    required Map<String, AccountClassification> accountClassifications,
  }) {
    return items.where((i) => i.type == BudgetItemType.debtPayment).map((item) {
      final actual = actualDebtPayment(
        transactions: transactions,
        budget: budget,
        liabilityAccountId: item.accountId,
        accountClassifications: accountClassifications,
      );
      return DebtPaymentItemResult(
        item: item,
        plannedMinor: item.assignedAmountMinor,
        actualMinor: actual,
      );
    }).toList();
  }

  static List<SavingItemResult> savingResults(List<BudgetItem> items) => items
      .where((i) => i.type == BudgetItemType.saving)
      .map(
        (i) => SavingItemResult(item: i, plannedMinor: i.assignedAmountMinor),
      )
      .toList();

  static int expectedIncome(List<BudgetItem> items) => items
      .where((i) => i.type == BudgetItemType.incomePlan)
      .fold(0, (sum, i) => sum + i.assignedAmountMinor);

  static int actualIncome(List<Transaction> transactions, Budget budget) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TransactionType.income) continue;
      if (budget.containsDate(tx.date)) total += tx.amountMinor;
    }
    return total;
  }

  /// Total actual expense in the month across all non-deleted expense
  /// transactions (cash-flow view, independent of which items exist).
  static int totalActualExpense(List<Transaction> transactions, Budget budget) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TransactionType.expense) continue;
      if (budget.containsDate(tx.date)) total += tx.amountMinor;
    }
    return total;
  }

  /// Payments that reduce a liability during the month: a transfer *into* the
  /// liability (repayment) or income booked on it. Excludes card purchases,
  /// loan draw-downs, adjustments and deleted rows.
  static int actualDebtPayment({
    required List<Transaction> transactions,
    required Budget budget,
    required String? liabilityAccountId,
    required Map<String, AccountClassification> accountClassifications,
  }) {
    if (liabilityAccountId == null) return 0;
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || !budget.containsDate(tx.date)) continue;
      final semantic = TransactionSemanticClassifier.classify(
        type: tx.type,
        sourceClassification: accountClassifications[tx.accountId],
        destinationClassification:
            accountClassifications[tx.destinationAccountId],
      );
      if (semantic != TransactionSemantic.liabilityRepayment) continue;
      final reducesThisLiability =
          (tx.type == TransactionType.transfer &&
              tx.destinationAccountId == liabilityAccountId) ||
          (tx.type == TransactionType.income &&
              tx.accountId == liabilityAccountId);
      if (reducesThisLiability) total += tx.amountMinor;
    }
    return total;
  }

  static int incomingRolloverTotal(List<BudgetRollover> incomingRollovers) =>
      incomingRollovers.fold(0, (sum, r) => sum + r.amountMinor);

  static BudgetSummary summarize({
    required Budget budget,
    required List<BudgetItem> items,
    required List<Transaction> transactions,
    required List<Category> categories,
    required List<BudgetRollover> incomingRollovers,
    required Map<String, AccountClassification> accountClassifications,
  }) {
    final expenses = expenseResults(
      budget: budget,
      items: items,
      transactions: transactions,
      categories: categories,
      incomingRollovers: incomingRollovers,
    );
    var assignedExpense = 0;
    var totalRemaining = 0;
    var overspent = 0;
    for (final e in expenses) {
      assignedExpense += e.assignedMinor;
      totalRemaining += e.remainingMinor;
      if (e.overspent) overspent++;
    }
    final assignedSaving = _assignedByType(items, BudgetItemType.saving);
    final assignedDebt = _assignedByType(items, BudgetItemType.debtPayment);

    return BudgetSummary(
      currencyCode: budget.currencyCode,
      expectedIncomeMinor: expectedIncome(items),
      actualIncomeMinor: actualIncome(transactions, budget),
      assignedExpenseMinor: assignedExpense,
      assignedSavingMinor: assignedSaving,
      assignedDebtPaymentMinor: assignedDebt,
      incomingRolloverMinor: incomingRolloverTotal(incomingRollovers),
      totalActualExpenseMinor: totalActualExpense(transactions, budget),
      totalRemainingMinor: totalRemaining,
      overspentCount: overspent,
    );
  }

  /// The transactions that make up an item's actual figure (for its details).
  static List<Transaction> contributingTransactions({
    required BudgetItem item,
    required Budget budget,
    required List<Transaction> transactions,
    required List<Category> categories,
    required Map<String, AccountClassification> accountClassifications,
  }) {
    switch (item.type) {
      case BudgetItemType.expense:
        final ids = _categoryAndDescendants(
          item.categoryId,
          _childrenByParent(categories),
        );
        return transactions
            .where(
              (tx) =>
                  !tx.isDeleted &&
                  tx.type == TransactionType.expense &&
                  budget.containsDate(tx.date) &&
                  tx.categoryId != null &&
                  ids.contains(tx.categoryId),
            )
            .toList();
      case BudgetItemType.incomePlan:
        return transactions
            .where(
              (tx) =>
                  !tx.isDeleted &&
                  tx.type == TransactionType.income &&
                  budget.containsDate(tx.date) &&
                  tx.categoryId == item.categoryId,
            )
            .toList();
      case BudgetItemType.debtPayment:
        return transactions.where((tx) {
          if (tx.isDeleted || !budget.containsDate(tx.date)) return false;
          final semantic = TransactionSemanticClassifier.classify(
            type: tx.type,
            sourceClassification: accountClassifications[tx.accountId],
            destinationClassification:
                accountClassifications[tx.destinationAccountId],
          );
          if (semantic != TransactionSemantic.liabilityRepayment) return false;
          return (tx.type == TransactionType.transfer &&
                  tx.destinationAccountId == item.accountId) ||
              (tx.type == TransactionType.income &&
                  tx.accountId == item.accountId);
        }).toList();
      case BudgetItemType.saving:
        return const [];
    }
  }

  // --- helpers ---

  static int _assignedByType(List<BudgetItem> items, BudgetItemType type) =>
      items
          .where((i) => i.type == type)
          .fold(0, (sum, i) => sum + i.assignedAmountMinor);

  static int _sumExpenseInMonth(
    List<Transaction> transactions,
    Budget budget,
    Set<String> categoryIds,
  ) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TransactionType.expense) continue;
      if (!budget.containsDate(tx.date)) continue;
      if (tx.categoryId != null && categoryIds.contains(tx.categoryId)) {
        total += tx.amountMinor;
      }
    }
    return total;
  }

  static int _sumIncomeForCategory(
    List<Transaction> transactions,
    Budget budget,
    String? categoryId,
  ) {
    if (categoryId == null) return 0;
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TransactionType.income) continue;
      if (!budget.containsDate(tx.date)) continue;
      if (tx.categoryId == categoryId) total += tx.amountMinor;
    }
    return total;
  }

  static int _rolloverInto(List<BudgetRollover> rollovers, String itemId) =>
      rollovers
          .where((r) => r.targetBudgetItemId == itemId)
          .fold(0, (sum, r) => sum + r.amountMinor);

  static Map<String, List<String>> _childrenByParent(
    List<Category> categories,
  ) {
    final map = <String, List<String>>{};
    for (final c in categories) {
      final parent = c.parentId;
      if (parent != null) {
        map.putIfAbsent(parent, () => <String>[]).add(c.id);
      }
    }
    return map;
  }

  /// A category id plus all of its descendants (self + children, recursively).
  static Set<String> _categoryAndDescendants(
    String? categoryId,
    Map<String, List<String>> childrenByParent,
  ) {
    final result = <String>{};
    if (categoryId == null) return result;
    final queue = <String>[categoryId];
    while (queue.isNotEmpty) {
      final id = queue.removeLast();
      if (!result.add(id)) continue;
      final children = childrenByParent[id];
      if (children != null) queue.addAll(children);
    }
    return result;
  }
}
