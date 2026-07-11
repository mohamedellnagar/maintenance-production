import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../budgets/presentation/widgets/budget_summary_card.dart';
import '../../recurring/presentation/widgets/upcoming_bills_card.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../application/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.dashboardTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addTransaction),
        icon: const Icon(Icons.add),
        label: Text(l.transactionAdd),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (data) {
          if (!data.hasAnyData) {
            return EmptyState(
              icon: Icons.savings_outlined,
              title: l.dashboardEmptyTitle,
              message: l.dashboardEmptyMessage,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.addTransaction),
                icon: const Icon(Icons.add),
                label: Text(l.transactionAdd),
              ),
            );
          }
          return _DashboardBody(data: data);
        },
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.data});
  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final recentAsync = ref.watch(recentTransactionsProvider(5));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Text(
          l.dashboardWelcome,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        _NetWorthCard(data: data),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: l.dashboardMonthlyIncome,
                money: Money(
                  amountMinor: data.monthlyIncome.amountMinor,
                  currencyCode: data.monthlyIncome.currencyCode,
                ),
                icon: Icons.south_west,
                positive: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _KpiCard(
                label: l.dashboardMonthlyExpense,
                money: Money(
                  amountMinor: data.monthlyExpense.amountMinor,
                  currencyCode: data.monthlyExpense.currencyCode,
                ),
                icon: Icons.north_east,
                positive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const BudgetSummaryCard(),
        const SizedBox(height: AppSpacing.md),
        const UpcomingBillsCard(),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.dashboardRecentTransactions,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        recentAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text(l.errorUnexpected),
          data: (transactions) {
            if (transactions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  l.dashboardNoTransactions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
            return Column(
              children: [
                for (final tx in transactions) TransactionTile(transaction: tx),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  const _NetWorthCard({required this.data});
  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.dashboardNetWorth,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            MoneyText(
              data.summary.netWorth,
              colorBySign: true,
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: l.dashboardTotalAssets,
                    money: data.summary.totalAssets,
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: l.dashboardTotalLiabilities,
                    money: data.summary.totalLiabilities,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.money});
  final String label;
  final Money money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        MoneyText(money, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.money,
    required this.icon,
    required this.positive,
  });

  final String label;
  final Money money;
  final IconData icon;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            MoneyText(money, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
