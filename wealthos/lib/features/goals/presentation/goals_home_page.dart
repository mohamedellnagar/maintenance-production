import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../application/goals_providers.dart';
import 'widgets/goal_card.dart';
import 'widgets/goal_insights_list.dart';

class GoalsHomePage extends ConsumerWidget {
  const GoalsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final views = ref.watch(goalViewsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.goalsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.goalAdd),
        icon: const Icon(Icons.add),
        label: Text(l.goalAdd),
      ),
      body: views.isEmpty
          ? EmptyState(
              icon: Icons.flag_outlined,
              title: l.goalsEmptyTitle,
              message: l.goalsEmptyMessage,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.goalAdd),
                icon: const Icon(Icons.add),
                label: Text(l.goalAdd),
              ),
            )
          : const _GoalsBody(),
    );
  }
}

class _GoalsBody extends ConsumerWidget {
  const _GoalsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final summary = ref.watch(goalsSummaryProvider);
    final insights = ref.watch(goalInsightsProvider);
    final active = ref.watch(activeGoalViewsProvider);
    final paused = ref.watch(pausedGoalViewsProvider);
    final completed = ref.watch(completedGoalViewsProvider);
    final archived = ref.watch(archivedGoalViewsProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        _SummaryCard(summary: summary),
        if (insights.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          GoalInsightsList(insights: insights),
        ],
        _section(l.goalsSectionActive, active),
        _section(l.goalsSectionPaused, paused),
        _section(l.goalsSectionCompleted, completed),
        _section(l.goalsSectionArchived, archived),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _section(String title, List<GoalView> views) {
    if (views.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.sm,
          ),
          child: Builder(
            builder: (context) => Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        for (final v in views) GoalCard(view: v),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});
  final GoalsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currency = summary.currencyCode;
    Money money(int m) => Money(amountMinor: m, currencyCode: currency);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: l.goalsSummaryTotalTarget,
                    money: money(summary.totalTargetMinor),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: l.goalsSummaryRemaining,
                    money: money(summary.totalRemainingMinor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _Pill(label: '${l.goalsSummaryActive}: ${summary.activeCount}'),
                const SizedBox(width: AppSpacing.sm),
                if (summary.behindCount > 0)
                  _Pill(
                    label: '${l.goalsSummaryBehind}: ${summary.behindCount}',
                  ),
              ],
            ),
            if (summary.hasShortfall) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 18,
                    color: AppColors.negative(theme.brightness),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l.goalsShortfallWarning,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  l.goalsShortfallNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: theme.textTheme.labelMedium),
    );
  }
}
