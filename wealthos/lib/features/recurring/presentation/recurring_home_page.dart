import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../application/recurring_providers.dart';
import '../domain/recurring_type.dart';
import 'recurrence_describe.dart';
import 'widgets/occurrence_tile.dart';
import 'widgets/recurring_insights_list.dart';

class RecurringHomePage extends ConsumerWidget {
  const RecurringHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // Trigger generation + auto-create on open (no background timer).
    ref.watch(recurringBootstrapProvider);

    final rules = ref.watch(allRulesProvider).value ?? const [];
    final views = ref.watch(occurrenceViewsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.recurringTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.recurringAdd),
        icon: const Icon(Icons.add),
        label: Text(l.recurringAddRule),
      ),
      body: rules.isEmpty && views.isEmpty
          ? EmptyState(
              icon: Icons.event_repeat_outlined,
              title: l.recurringEmptyTitle,
              message: l.recurringEmptyMessage,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.recurringAdd),
                icon: const Icon(Icons.add),
                label: Text(l.recurringAddRule),
              ),
            )
          : const _RecurringBody(),
    );
  }
}

class _RecurringBody extends ConsumerWidget {
  const _RecurringBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final due = ref.watch(dueTodayProvider);
    final overdue = ref.watch(overdueProvider);
    final upcoming7 = ref.watch(upcomingProvider(7));
    final upcoming30 = ref.watch(upcomingProvider(30));
    final rules = ref.watch(allRulesProvider).value ?? const [];
    final insights = ref.watch(recurringInsightsProvider);

    final currency = rules.isEmpty ? 'AED' : rules.first.currencyCode;
    final plannedIncome = upcoming30
        .where((v) => v.type == RecurringType.income)
        .fold(0, (s, v) => s + v.expectedAmountMinor);
    final plannedOut = upcoming30
        .where((v) => v.type != RecurringType.income)
        .fold(0, (s, v) => s + v.expectedAmountMinor);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          children: [
            Expanded(
              child: _PlanTile(
                label: l.recurringPlannedIncome,
                money: Money(
                  amountMinor: plannedIncome,
                  currencyCode: currency,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PlanTile(
                label: l.recurringPlannedExpenses,
                money: Money(amountMinor: plannedOut, currencyCode: currency),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            l.recurringPlannedNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (insights.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          RecurringInsightsList(insights: insights),
        ],
        if (overdue.isNotEmpty)
          _Section(title: l.recurringOverdue, views: overdue),
        if (due.isNotEmpty) _Section(title: l.recurringDueToday, views: due),
        _Section(title: l.recurringUpcoming7, views: upcoming7),
        if (upcoming30.length > upcoming7.length)
          _Section(title: l.recurringUpcoming30, views: upcoming30),
        const SizedBox(height: AppSpacing.md),
        Text(
          l.recurringActiveRules,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final rule in rules)
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () =>
                context.push(AppRoutes.recurringRuleDetailPath(rule.id)),
            leading: Icon(
              rule.isActive ? Icons.event_repeat : Icons.pause_circle_outline,
            ),
            title: Text(rule.name),
            subtitle: Text(describeRecurrence(l, locale, rule)),
            trailing: MoneyText(
              Money(
                amountMinor: rule.amountMinor,
                currencyCode: rule.currencyCode,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.views});
  final String title;
  final List<OccurrenceView> views;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (views.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(l.recurringNoOccurrences),
          )
        else
          for (final view in views) OccurrenceTile(view: view),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.label, required this.money});
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
