import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../application/recurring_providers.dart';
import 'occurrence_tile.dart';

/// Reactive dashboard card summarizing overdue / due-today / upcoming bills.
class UpcomingBillsCard extends ConsumerWidget {
  const UpcomingBillsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Ensure occurrences are generated even if the user never opens the tab.
    ref.watch(recurringBootstrapProvider);

    final overdue = ref.watch(overdueProvider);
    final due = ref.watch(dueTodayProvider);
    final upcoming = ref.watch(upcomingProvider(7));
    final rules = ref.watch(allRulesProvider).value ?? const [];

    if (rules.isEmpty && overdue.isEmpty && due.isEmpty && upcoming.isEmpty) {
      return const SizedBox.shrink();
    }

    final currency = rules.isEmpty ? 'AED' : rules.first.currencyCode;
    final total = upcoming.fold(0, (s, v) => s + v.expectedAmountMinor);
    final preview = [...overdue, ...due, ...upcoming].take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.dashboardUpcomingBills,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.recurring),
                  child: Text(l.recurringViewAll),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: l.recurringOverdue,
                    value: '${overdue.length}',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: l.recurringDueToday,
                    value: '${due.length}',
                  ),
                ),
                Expanded(
                  child: _MetricMoney(
                    label: l.recurringUpcoming7,
                    money: Money(amountMinor: total, currencyCode: currency),
                  ),
                ),
              ],
            ),
            if (preview.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(l.recurringNoUpcoming),
              )
            else
              for (final view in preview) OccurrenceTile(view: view),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

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
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _MetricMoney extends StatelessWidget {
  const _MetricMoney({required this.label, required this.money});
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
        MoneyText(money, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
