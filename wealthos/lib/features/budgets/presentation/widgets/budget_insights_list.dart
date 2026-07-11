import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../categories/domain/category.dart';
import '../../domain/budget_insights.dart';

/// Renders the in-app budget insights as textual rows (icon + localized text).
class BudgetInsightsList extends StatelessWidget {
  const BudgetInsightsList({
    required this.insights,
    required this.categoriesById,
    super.key,
  });

  final List<BudgetInsight> insights;
  final Map<String, Category> categoriesById;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    String messageFor(BudgetInsight insight) {
      final category = insight.categoryId == null
          ? ''
          : categoriesById[insight.categoryId]?.localizedName(language) ?? '';
      return switch (insight.type) {
        BudgetInsightType.overspent => l.insightOverspent(category),
        BudgetInsightType.highConsumption => l.insightHighConsumption(category),
        BudgetInsightType.negativeAvailableToAssign =>
          l.insightNegativeAvailable,
        BudgetInsightType.incomeBelowExpected => l.insightIncomeBelowExpected,
        BudgetInsightType.closedMonthChanged => l.insightClosedMonthChanged,
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
                      insight.severity == InsightSeverity.warning
                          ? Icons.warning_amber_outlined
                          : Icons.info_outline,
                      size: 18,
                      color: insight.severity == InsightSeverity.warning
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
