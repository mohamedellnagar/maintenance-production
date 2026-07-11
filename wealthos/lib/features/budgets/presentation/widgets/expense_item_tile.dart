import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/enum_labels.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../categories/domain/category.dart';
import '../../domain/budget_calculator.dart';

/// A budget expense row: category, assigned/actual, remaining or overspent, a
/// progress bar and a **textual** status (never color alone).
class ExpenseItemTile extends StatelessWidget {
  const ExpenseItemTile({
    required this.result,
    required this.categoriesById,
    required this.currency,
    super.key,
  });

  final ExpenseItemResult result;
  final Map<String, Category> categoriesById;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final language = Localizations.localeOf(context).languageCode;
    final brightness = theme.brightness;

    final name =
        categoriesById[result.item.categoryId]?.localizedName(language) ?? '—';
    Money money(int m) => Money(amountMinor: m, currencyCode: currency);
    final percent = (result.usageRatio * 100).round();
    final progressColor = result.overspent
        ? AppColors.negative(brightness)
        : theme.colorScheme.primary;

    return InkWell(
      onTap: () => context.push(AppRoutes.budgetItemDetailPath(result.item.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: theme.textTheme.titleSmall)),
                MoneyText(
                  money(result.actualSpentMinor),
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  ' / ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  money(result.budgetedMinor).format(locale: locale),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: result.usageRatio.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: progressColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Text(
                  result.status.label(l),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: result.overspent
                        ? AppColors.negative(brightness)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  result.overspent
                      ? '${l.budgetItemOverspentBy} '
                            '${money(-result.remainingMinor).format(locale: locale)}'
                      : '${l.budgetItemRemaining} '
                            '${money(result.remainingMinor).format(locale: locale)}'
                            ' · ${l.budgetItemUsage(percent)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
