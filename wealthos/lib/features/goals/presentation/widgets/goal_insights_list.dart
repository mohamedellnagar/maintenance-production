import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/goal_insights.dart';

/// Renders in-app goal insights as textual rows (icon + localized text).
class GoalInsightsList extends StatelessWidget {
  const GoalInsightsList({required this.insights, super.key});

  final List<GoalInsight> insights;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    String messageFor(GoalInsight i) {
      final name = i.goalName ?? '';
      return switch (i.type) {
        GoalInsightType.allocationShortfall => l.goalInsightShortfall,
        GoalInsightType.behind => l.goalInsightBehind(name),
        GoalInsightType.nearCompletion => l.goalInsightNearCompletion(name),
        GoalInsightType.completed => l.goalInsightCompleted(name),
        GoalInsightType.stalled => l.goalInsightStalled(name),
        GoalInsightType.deadlineSoon => l.goalInsightDeadlineSoon(name),
        GoalInsightType.overfunded => l.goalInsightOverfunded(name),
        GoalInsightType.emergencyFundLow => l.goalInsightEmergencyLow,
      };
    }

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final insight in insights)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      insight.severity == GoalInsightSeverity.warning
                          ? Icons.warning_amber_outlined
                          : Icons.info_outline,
                      size: 18,
                      color: insight.severity == GoalInsightSeverity.warning
                          ? AppColors.negative(theme.brightness)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        messageFor(insight),
                        style: theme.textTheme.bodyMedium,
                      ),
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
