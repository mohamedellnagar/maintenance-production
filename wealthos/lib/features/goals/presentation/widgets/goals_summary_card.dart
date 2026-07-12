import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../application/goals_providers.dart';

/// Reactive dashboard card: allocated / unallocated, the nearest goal and its
/// progress, and how many goals are behind plan.
class GoalsSummaryCard extends ConsumerWidget {
  const GoalsSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final views = ref.watch(goalViewsProvider);
    if (views.isEmpty) return const SizedBox.shrink();

    final summary = ref.watch(goalsSummaryProvider);
    final currency = summary.currencyCode;
    Money money(int m) => Money(amountMinor: m, currencyCode: currency);
    final nearest = summary.nearestGoal;

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
                    l.dashboardGoals,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.goals),
                  child: Text(l.goalsViewAll),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: l.goalsSummaryAllocated,
                    money: money(summary.totalAllocatedMinor),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: l.goalsSummaryUnallocated,
                    money: money(summary.unallocatedMinor),
                  ),
                ),
              ],
            ),
            if (nearest != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '${l.goalsSummaryNearest}: ${nearest.goal.name}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              LinearProgressIndicator(
                value: nearest.progress.fundingRatio.clamp(0.0, 1.0) == 0
                    ? null
                    : nearest.progress.fundingRatio.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
              ),
            ],
            if (summary.behindCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_down,
                      size: 16,
                      color: AppColors.negative(theme.brightness),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${l.goalsSummaryBehind}: ${summary.behindCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.money});
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
