import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/currency.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/net_worth.dart';

/// Combined net-worth + monthly cash-flow figures for the dashboard.
class DashboardData {
  const DashboardData({
    required this.summary,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.hasAnyData,
  });

  final NetWorthSummary summary;
  final MonthlyCashFlow monthlyIncome;
  final MonthlyCashFlow monthlyExpense;
  final bool hasAnyData;
}

/// Wrapper kept as a named type for readability at call sites.
typedef MonthlyCashFlow = ({int amountMinor, String currencyCode});

/// Derives all dashboard KPIs from live account + transaction data.
final dashboardDataProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final accountsAsync = ref.watch(allAccountsProvider);
  final transactionsAsync = ref.watch(allTransactionsProvider);
  final settings = ref.watch(currentSettingsProvider);
  final currency = settings?.baseCurrency ?? Currencies.defaultCurrency.code;

  return accountsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
    data: (accounts) => transactionsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
      data: (transactions) {
        final now = DateTime.now();
        final summary = NetWorthCalculator.summarize(
          accounts,
          transactions,
          currencyCode: currency,
        );
        final income = NetWorthCalculator.monthlyIncome(
          transactions,
          month: now,
          currencyCode: currency,
        );
        final expense = NetWorthCalculator.monthlyExpense(
          transactions,
          month: now,
          currencyCode: currency,
        );
        return AsyncValue.data(
          DashboardData(
            summary: summary,
            monthlyIncome: (
              amountMinor: income.amountMinor,
              currencyCode: currency,
            ),
            monthlyExpense: (
              amountMinor: expense.amountMinor,
              currencyCode: currency,
            ),
            hasAnyData: accounts.isNotEmpty || transactions.isNotEmpty,
          ),
        );
      },
    ),
  );
});
