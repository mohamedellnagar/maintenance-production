import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../../recurring/application/recurring_providers.dart';
import '../../recurring/domain/recurring_type.dart';
import '../../recurring/presentation/widgets/occurrence_tile.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../application/budget_controller.dart';
import '../application/budgets_providers.dart';
import '../domain/budget.dart';
import '../domain/budget_calculator.dart';
import '../domain/budget_item.dart';

class BudgetItemDetailsPage extends ConsumerWidget {
  const BudgetItemDetailsPage({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final itemAsync = ref.watch(budgetItemByIdProvider(itemId));

    return Scaffold(
      appBar: AppBar(title: Text(l.budgetItemDetailsTitle)),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (item) {
          if (item == null) {
            return Center(child: Text(l.errorBudgetItemNotFound));
          }
          final budget = ref.watch(budgetByIdProvider(item.budgetId)).value;
          if (budget == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ItemBody(item: item, budget: budget);
        },
      ),
    );
  }
}

class _ItemBody extends ConsumerWidget {
  const _ItemBody({required this.item, required this.budget});
  final BudgetItem item;
  final Budget budget;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.budgetDeleteItemConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result = await ref.read(budgetControllerProvider).deleteItem(item.id);
    result.fold(
      (_) => router.pop(),
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final currency = budget.currencyCode;
    final transactions = ref.watch(allTransactionsProvider).value ?? const [];
    final categories = ref.watch(allCategoriesProvider).value ?? const [];
    final classifications = ref.watch(accountClassificationsProvider);
    final rollovers =
        ref.watch(rolloversForItemProvider(item.id)).value ?? const [];

    final contributing = BudgetCalculator.contributingTransactions(
      item: item,
      budget: budget,
      transactions: transactions,
      categories: categories,
      accountClassifications: classifications,
    );
    final actual = contributing.fold(0, (s, t) => s + t.amountMinor);
    final rolloverIn = rollovers
        .where((r) => r.targetBudgetItemId == item.id)
        .fold(0, (s, r) => s + r.amountMinor);
    final rolloverOut = rollovers
        .where((r) => r.sourceBudgetItemId == item.id)
        .fold(0, (s, r) => s + r.amountMinor);
    final budgeted = item.assignedAmountMinor + rolloverIn;
    final remaining = budgeted - actual;

    // Planned recurring occurrences matching this item's category (or liability
    // account) that fall in the budget's month. These are NOT actual spending —
    // shown separately so the user can anticipate cash flow.
    final upcomingRecurring = ref
        .watch(
          upcomingRecurringForMonthProvider((
            year: budget.year,
            month: budget.month,
          )),
        )
        .where((v) {
          if (item.categoryId != null) {
            return v.rule.categoryId == item.categoryId;
          }
          if (item.type == BudgetItemType.debtPayment) {
            return v.type == RecurringType.liabilityPayment &&
                v.rule.destinationAccountId == item.accountId;
          }
          return false;
        })
        .toList();
    final upcomingRecurringTotal = upcomingRecurring.fold(
      0,
      (s, v) => s + v.expectedAmountMinor,
    );

    Money money(int m) => Money(amountMinor: m, currencyCode: currency);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Text(item.type.label(l), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        _Row(
          label: l.budgetItemPlanned,
          money: money(item.assignedAmountMinor),
        ),
        if (item.type == BudgetItemType.expense)
          _Row(label: l.budgetItemRolloverIn, money: money(rolloverIn)),
        _Row(label: l.budgetItemActual, money: money(actual)),
        if (item.type != BudgetItemType.saving)
          _Row(label: l.budgetItemRemaining, money: money(remaining)),
        if (rolloverOut > 0)
          _Row(label: l.budgetItemRolloverOut, money: money(rolloverOut)),
        if (item.notes != null && item.notes!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(item.notes!),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (!budget.status.isClosed)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.budgetItemEditPath(item.id)),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l.commonEdit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _delete(context, ref),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l.commonDelete),
                ),
              ),
            ],
          )
        else
          Text(l.budgetReadOnly),
        if (upcomingRecurring.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.budgetUpcomingRecurring,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              MoneyText(
                money(upcomingRecurringTotal),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Text(
            l.budgetUpcomingRecurringNote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final v in upcomingRecurring) OccurrenceTile(view: v),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          l.budgetContributingTransactions,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (contributing.isEmpty)
          Text(l.budgetNoContributions)
        else
          for (final tx in contributing) TransactionTile(transaction: tx),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.money});
  final String label;
  final Money money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          MoneyText(money, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
