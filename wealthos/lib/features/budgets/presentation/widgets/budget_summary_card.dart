import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../application/budgets_providers.dart';

/// Reactive dashboard card summarizing the current month's budget.
class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewAsync = ref.watch(currentMonthBudgetViewProvider);

    return viewAsync.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (view) {
        if (view == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(child: Text(l.budgetCreateCta)),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.budgetCreate),
                    child: Text(l.budgetCreateTitle),
                  ),
                ],
              ),
            ),
          );
        }
        final s = view.summary;
        Money money(int m) =>
            Money(amountMinor: m, currencyCode: s.currencyCode);
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
                        l.budgetSummaryCardTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.budget),
                      child: Text(l.budgetOpen),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: l.budgetTotalAssigned,
                        money: money(s.totalAssignedMinor),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        label: l.budgetActualExpense,
                        money: money(s.totalActualExpenseMinor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: l.budgetTotalRemaining,
                        money: money(s.totalRemainingMinor),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.budgetOverspentCount,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${s.overspentCount}',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.money});
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
        const SizedBox(height: AppSpacing.xs),
        MoneyText(money, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
