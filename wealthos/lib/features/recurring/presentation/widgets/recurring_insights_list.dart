import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/recurring_insights.dart';

/// Renders in-app recurring insights as textual rows (icon + localized text).
/// Status is conveyed by text and icon, never by color alone.
class RecurringInsightsList extends StatelessWidget {
  const RecurringInsightsList({required this.insights, super.key});

  final List<RecurringInsight> insights;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    String messageFor(RecurringInsight insight) => switch (insight.type) {
      RecurringInsightType.billOverdue => l.insightBillOverdue,
      RecurringInsightType.multipleDueToday => l.insightMultipleDueToday,
      RecurringInsightType.incomeUpcoming => l.insightIncomeUpcoming,
      RecurringInsightType.autoCreateFailed => l.insightAutoCreateFailed,
      RecurringInsightType.archivedReference => l.insightRecurringArchived,
      RecurringInsightType.manyUnpaid => l.insightManyUnpaid,
    };

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
                      insight.severity == RecurringInsightSeverity.warning
                          ? Icons.warning_amber_outlined
                          : Icons.info_outline,
                      size: 18,
                      color:
                          insight.severity == RecurringInsightSeverity.warning
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
