import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../categories/domain/category.dart';
import '../application/budget_controller.dart';
import '../application/budgets_providers.dart';
import '../domain/budget_calculator.dart';
import 'widgets/budget_insights_list.dart';
import 'widgets/expense_item_tile.dart';

class BudgetMonthPage extends ConsumerWidget {
  const BudgetMonthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final month = ref.watch(selectedBudgetMonthProvider);
    final viewAsync = ref.watch(budgetViewProvider(month));
    final monthLabel = DateFormat.yMMMM(
      locale,
    ).format(DateTime(month.year, month.month));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.budgetTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _MonthNavigator(label: monthLabel),
        ),
      ),
      floatingActionButton:
          viewAsync.value != null && !viewAsync.value!.budget.status.isClosed
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.budgetItemAdd),
              icon: const Icon(Icons.add),
              label: Text(l.budgetAddItem),
            )
          : null,
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (view) {
          if (view == null) {
            return EmptyState(
              icon: Icons.pie_chart_outline,
              title: l.budgetEmptyTitle,
              message: l.budgetEmptyMessage,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.budgetCreate),
                icon: const Icon(Icons.add),
                label: Text(l.budgetCreateTitle),
              ),
            );
          }
          return _BudgetBody(view: view);
        },
      ),
    );
  }
}

class _MonthNavigator extends ConsumerWidget {
  const _MonthNavigator({required this.label});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(selectedBudgetMonthProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: notifier.previous,
          ),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: notifier.next,
          ),
        ],
      ),
    );
  }
}

class _BudgetBody extends ConsumerWidget {
  const _BudgetBody({required this.view});
  final BudgetView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final categories = ref.watch(allCategoriesProvider).value ?? const [];
    final byId = {for (final c in categories) c.id: c};
    final summary = view.summary;
    final currency = summary.currencyCode;

    Money money(int minor) => Money(amountMinor: minor, currencyCode: currency);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          children: [
            Chip(label: Text(view.budget.status.label(l))),
            const Spacer(),
            if (view.budget.status.isClosed)
              TextButton.icon(
                onPressed: () => _reopen(context, ref),
                icon: const Icon(Icons.lock_open, size: 18),
                label: Text(l.budgetReopen),
              )
            else
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.budgetClose),
                icon: const Icon(Icons.lock_outline, size: 18),
                label: Text(l.budgetCloseMonth),
              ),
          ],
        ),
        if (view.budget.status.isClosed)
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(l.budgetClosedBanner),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        _KpiGrid(summary: summary, money: money),
        if (view.insights.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          BudgetInsightsList(insights: view.insights, categoriesById: byId),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (view.incomes.isNotEmpty) ...[
          _SectionHeader(l.budgetSectionIncomePlan),
          for (final r in view.incomes)
            _IncomeTile(result: r, categoriesById: byId, money: money),
          const SizedBox(height: AppSpacing.md),
        ],
        _SectionHeader(l.budgetSectionExpense),
        if (view.expenses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(l.budgetNoContributions),
          )
        else
          for (final r in view.expenses)
            ExpenseItemTile(
              result: r,
              categoriesById: byId,
              currency: currency,
            ),
        if (view.savings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(l.budgetSectionSavings),
          for (final r in view.savings)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () =>
                  context.push(AppRoutes.budgetItemDetailPath(r.item.id)),
              title: Text(r.item.customName ?? l.budgetItemTypeSaving),
              subtitle: Text(l.budgetSavingPlanOnly),
              trailing: MoneyText(money(r.plannedMinor)),
            ),
        ],
        if (view.debts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(l.budgetSectionDebt),
          for (final r in view.debts) _DebtTile(result: r, money: money),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Future<void> _reopen(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.budgetReopenConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.budgetReopen),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(budgetControllerProvider).reopen(view.budget.id);
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.summary, required this.money});
  final BudgetSummary summary;
  final Money Function(int) money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tiles = <(String, Money)>[
      (l.budgetExpectedIncome, money(summary.expectedIncomeMinor)),
      (l.budgetActualIncome, money(summary.actualIncomeMinor)),
      (l.budgetTotalAssigned, money(summary.totalAssignedMinor)),
      (l.budgetAvailableToAssign, money(summary.availableToAssignMinor)),
      (l.budgetActualExpense, money(summary.totalActualExpenseMinor)),
      (l.budgetTotalRemaining, money(summary.totalRemainingMinor)),
    ];
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _KpiTile(label: tiles[i].$1, money: tiles[i].$2),
                ),
                const SizedBox(width: AppSpacing.md),
                if (i + 1 < tiles.length)
                  Expanded(
                    child: _KpiTile(
                      label: tiles[i + 1].$1,
                      money: tiles[i + 1].$2,
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),
        Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${l.budgetOverspentCount}: ${summary.overspentCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.label, required this.money});
  final String label;
  final Money money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
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
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _IncomeTile extends StatelessWidget {
  const _IncomeTile({
    required this.result,
    required this.categoriesById,
    required this.money,
  });
  final IncomePlanItemResult result;
  final Map<String, Category> categoriesById;
  final Money Function(int) money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final name =
        categoriesById[result.item.categoryId]?.localizedName(language) ?? '—';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => GoRouter.of(
        context,
      ).push(AppRoutes.budgetItemDetailPath(result.item.id)),
      title: Text(name),
      subtitle: Text(
        '${l.budgetItemPlanned}: ${money(result.plannedMinor).format(locale: Localizations.localeOf(context).toString())}'
        ' · ${l.budgetItemActual}: ${money(result.actualMinor).format(locale: Localizations.localeOf(context).toString())}',
      ),
      trailing: MoneyText(money(result.actualMinor)),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({required this.result, required this.money});
  final DebtPaymentItemResult result;
  final Money Function(int) money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => GoRouter.of(
        context,
      ).push(AppRoutes.budgetItemDetailPath(result.item.id)),
      title: Text(l.budgetItemTypeDebt),
      subtitle: Text(
        '${l.budgetItemPlanned}: ${money(result.plannedMinor).format(locale: locale)}'
        ' · ${l.budgetItemActual}: ${money(result.actualMinor).format(locale: locale)}',
      ),
      trailing: MoneyText(money(result.remainingMinor)),
    );
  }
}
