import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/money/currency.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account_type.dart';
import '../../categories/domain/category.dart';
import '../../settings/application/settings_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/budget.dart';
import '../domain/budget_calculator.dart';
import '../domain/budget_insights.dart';
import '../domain/budget_item.dart';
import '../domain/budget_rollover.dart';

/// The (year, month) currently shown in the Budget tab. Defaults to now.
class SelectedBudgetMonth extends Notifier<({int year, int month})> {
  @override
  ({int year, int month}) build() {
    final now = DateTime.now();
    return (year: now.year, month: now.month);
  }

  void set(int year, int month) => state = (year: year, month: month);

  void next() {
    final m = state;
    state = m.month == 12
        ? (year: m.year + 1, month: 1)
        : (year: m.year, month: m.month + 1);
  }

  void previous() {
    final m = state;
    state = m.month == 1
        ? (year: m.year - 1, month: 12)
        : (year: m.year, month: m.month - 1);
  }
}

final selectedBudgetMonthProvider =
    NotifierProvider<SelectedBudgetMonth, ({int year, int month})>(
      SelectedBudgetMonth.new,
    );

/// Base currency, falling back to the default while settings load.
final baseCurrencyProvider = Provider<String>(
  (ref) =>
      ref.watch(currentSettingsProvider)?.baseCurrency ??
      Currencies.defaultCurrency.code,
);

/// All categories (including archived), for hierarchy and name resolution.
final allCategoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoriesRepositoryProvider).watchAll(),
);

/// Map of account id → accounting classification, for debt-payment math.
final accountClassificationsProvider =
    Provider<Map<String, AccountClassification>>((ref) {
      final accounts = ref.watch(allAccountsProvider).value ?? const [];
      return {for (final a in accounts) a.id: a.classification};
    });

final budgetForMonthProvider =
    StreamProvider.family<Budget?, ({int year, int month})>((ref, m) {
      final currency = ref.watch(baseCurrencyProvider);
      return ref
          .watch(budgetsRepositoryProvider)
          .watchBudget(m.year, m.month, currency);
    });

final budgetByIdProvider = StreamProvider.family<Budget?, String>(
  (ref, id) => ref.watch(budgetsRepositoryProvider).watchBudgetById(id),
);

final budgetItemsProvider = StreamProvider.family<List<BudgetItem>, String>(
  (ref, budgetId) => ref.watch(budgetsRepositoryProvider).watchItems(budgetId),
);

final budgetItemByIdProvider = StreamProvider.family<BudgetItem?, String>(
  (ref, id) => ref.watch(budgetsRepositoryProvider).watchItemById(id),
);

final incomingRolloversProvider =
    StreamProvider.family<List<BudgetRollover>, String>(
      (ref, budgetId) =>
          ref.watch(budgetsRepositoryProvider).watchIncomingRollovers(budgetId),
    );

final rolloversForItemProvider =
    StreamProvider.family<List<BudgetRollover>, String>(
      (ref, itemId) =>
          ref.watch(budgetsRepositoryProvider).watchRolloversForItem(itemId),
    );

/// Everything the month screen needs, recomputed reactively whenever the
/// budget, its items, transactions, categories, accounts or rollovers change.
class BudgetView {
  const BudgetView({
    required this.budget,
    required this.items,
    required this.expenses,
    required this.incomes,
    required this.debts,
    required this.savings,
    required this.summary,
    required this.insights,
    required this.incomingRollovers,
  });

  final Budget budget;
  final List<BudgetItem> items;
  final List<ExpenseItemResult> expenses;
  final List<IncomePlanItemResult> incomes;
  final List<DebtPaymentItemResult> debts;
  final List<SavingItemResult> savings;
  final BudgetSummary summary;
  final List<BudgetInsight> insights;
  final List<BudgetRollover> incomingRollovers;
}

/// The budget view for a specific month (null when no budget exists yet).
final budgetViewProvider =
    Provider.family<AsyncValue<BudgetView?>, ({int year, int month})>((ref, m) {
      final budgetAsync = ref.watch(budgetForMonthProvider(m));
      return budgetAsync.when(
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
        data: (budget) {
          if (budget == null) return const AsyncValue<BudgetView?>.data(null);
          final items = ref.watch(budgetItemsProvider(budget.id)).value;
          final transactions = ref.watch(allTransactionsProvider).value;
          final categories = ref.watch(allCategoriesProvider).value;
          final rollovers = ref
              .watch(incomingRolloversProvider(budget.id))
              .value;
          final classifications = ref.watch(accountClassificationsProvider);
          if (items == null ||
              transactions == null ||
              categories == null ||
              rollovers == null) {
            return const AsyncValue.loading();
          }

          final expenses = BudgetCalculator.expenseResults(
            budget: budget,
            items: items,
            transactions: transactions,
            categories: categories,
            incomingRollovers: rollovers,
          );
          final summary = BudgetCalculator.summarize(
            budget: budget,
            items: items,
            transactions: transactions,
            categories: categories,
            incomingRollovers: rollovers,
            accountClassifications: classifications,
          );
          final insights = BudgetInsightBuilder.build(
            budget: budget,
            summary: summary,
            expenses: expenses,
            closedSnapshotExpenseMinor: budget.closedSnapshotExpenseMinor,
            closedSnapshotIncomeMinor: budget.closedSnapshotIncomeMinor,
          );
          return AsyncValue.data(
            BudgetView(
              budget: budget,
              items: items,
              expenses: expenses,
              incomes: BudgetCalculator.incomeResults(
                budget: budget,
                items: items,
                transactions: transactions,
              ),
              debts: BudgetCalculator.debtResults(
                budget: budget,
                items: items,
                transactions: transactions,
                accountClassifications: classifications,
              ),
              savings: BudgetCalculator.savingResults(items),
              summary: summary,
              insights: insights,
              incomingRollovers: rollovers,
            ),
          );
        },
      );
    });

/// The current calendar month's view — used by the dashboard card.
final currentMonthBudgetViewProvider = Provider<AsyncValue<BudgetView?>>((ref) {
  final now = DateTime.now();
  return ref.watch(budgetViewProvider((year: now.year, month: now.month)));
});
