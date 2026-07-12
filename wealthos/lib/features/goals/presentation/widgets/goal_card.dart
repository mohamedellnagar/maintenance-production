import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/enum_labels.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../application/goals_providers.dart';
import '../goal_visuals.dart';

/// A tappable summary card for a single goal. Progress is conveyed by a bar
/// *and* text (never color alone).
class GoalCard extends StatelessWidget {
  const GoalCard({required this.view, super.key});

  final GoalView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final goal = view.goal;
    final progress = view.progress;
    final currency = goal.currencyCode;
    final ratio = progress.fundingRatio.clamp(0.0, 1.0);

    Money money(int m) => Money(amountMinor: m, currencyCode: currency);

    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.goalDetailPath(goal.id)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(goalTypeIcon(goal.type), size: 22),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      goal.name,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    progress.trackStatus.label(l),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: ratio == 0 ? null : ratio.toDouble(),
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Wrap (not Row) so long currency values / large text scales
              // reflow instead of overflowing.
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  MoneyText(
                    money(view.fundedMinor),
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    '${(progress.fundingRatio * 100).round()}%',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${l.goalTarget}: ${money(progress.targetMinor).format(locale: locale)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (goal.targetDate != null &&
                  progress.requiredMonthlyMinor != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l.goalTargetDate}: '
                  '${DateFormat.yMMMd(locale).format(goal.targetDate!.toDateTime())}'
                  ' · ${l.goalRequiredMonthly}: '
                  '${money(progress.requiredMonthlyMinor!).format(locale: locale)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
