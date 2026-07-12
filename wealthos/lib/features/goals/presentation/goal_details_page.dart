import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/result.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../application/goals_controller.dart';
import '../application/goals_providers.dart';
import '../domain/financial_goal.dart';
import '../domain/goal_fund_entry.dart';
import '../domain/goal_type.dart';
import 'goal_visuals.dart';
import 'widgets/goal_fund_entry_tile.dart';

class GoalDetailsPage extends ConsumerWidget {
  const GoalDetailsPage({required this.goalId, super.key});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final view = ref.watch(goalViewByIdProvider(goalId));
    return Scaffold(
      appBar: AppBar(title: Text(view?.goal.name ?? l.goalDetailsTitle)),
      body: view == null
          ? Center(child: Text(l.errorGoalNotFound))
          : _Body(goalId: goalId),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.goalId});
  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final view = ref.watch(goalViewByIdProvider(goalId));
    if (view == null) return const SizedBox.shrink();
    final goal = view.goal;
    final p = view.progress;
    final currency = goal.currencyCode;
    final entries = ref.watch(goalEntriesProvider(goalId)).value ?? const [];
    Money money(int m) => Money(amountMinor: m, currencyCode: currency);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          children: [
            Icon(goalTypeIcon(goal.type), size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                goal.type.label(l),
                style: theme.textTheme.titleMedium,
              ),
            ),
            Chip(label: Text(p.trackStatus.label(l))),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        MoneyText(
          money(view.fundedMinor),
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: p.fundingRatio.clamp(0.0, 1.0) == 0
              ? null
              : p.fundingRatio.clamp(0.0, 1.0).toDouble(),
          minHeight: 8,
        ),
        const SizedBox(height: AppSpacing.md),
        _row(context, l.goalTarget, money(p.targetMinor)),
        _row(context, l.goalRemaining, money(p.remainingMinor)),
        if (p.isOverfunded)
          _row(context, l.goalOverfunded, money(p.overfundedMinor)),
        if (p.requiredMonthlyMinor != null)
          _row(context, l.goalRequiredMonthly, money(p.requiredMonthlyMinor!)),
        _textRow(
          context,
          l.goalProjectedCompletion,
          p.projectedCompletion == null
              ? l.goalProjectionUnavailable
              : DateFormat.yMMMd(
                  locale,
                ).format(p.projectedCompletion!.toDateTime()),
        ),
        _textRow(context, l.goalPriority, goal.priority.label(l)),
        if (goal.type == GoalType.debtPayoff) ...[
          const Divider(height: AppSpacing.xl),
          _row(context, l.goalSavedForRepayment, money(view.fundedMinor)),
          _row(
            context,
            l.goalActualDebtReduced,
            money(view.actualDebtReducedMinor),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _actions(context, ref, goal),
        const SizedBox(height: AppSpacing.lg),
        Text(l.goalLedger, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (entries.isEmpty)
          Text(l.goalNoActivity)
        else
          for (final e in entries.reversed)
            GoalFundEntryTile(
              entry: e,
              currencyCode: currency,
              trailing: _entryTrailing(context, ref, e, currency),
            ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _entryTrailing(
    BuildContext context,
    WidgetRef ref,
    GoalFundEntry entry,
    String currency,
  ) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MoneyText(
          Money(
            amountMinor: entry.signedEffectMinor == 0 && entry.isDeleted
                ? (entry.type.increasesByType
                      ? entry.amountMinor
                      : -entry.amountMinor)
                : entry.signedEffectMinor,
            currencyCode: currency,
          ),
          colorBySign: true,
        ),
        PopupMenuButton<String>(
          onSelected: (v) async {
            final controller = ref.read(goalsControllerProvider);
            if (v == 'delete') {
              await controller.softDeleteEntry(entry.id);
            } else if (v == 'restore') {
              await controller.restoreEntry(entry.id);
            }
          },
          itemBuilder: (context) => [
            if (entry.isDeleted)
              PopupMenuItem(value: 'restore', child: Text(l.goalEntryRestore))
            else
              PopupMenuItem(value: 'delete', child: Text(l.goalEntryDelete)),
          ],
        ),
      ],
    );
  }

  Widget _actions(BuildContext context, WidgetRef ref, FinancialGoal goal) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (goal.status == GoalStatus.active)
          FilledButton.icon(
            onPressed: () => _amountDialog(
              context,
              ref,
              title: l.goalAddContribution,
              label: l.goalContributionAmount,
              action: (amount, note) => ref
                  .read(goalsControllerProvider)
                  .contribute(goal.id, amount, note: note),
            ),
            icon: const Icon(Icons.add),
            label: Text(l.goalAddContribution),
          ),
        OutlinedButton.icon(
          onPressed: () => _amountDialog(
            context,
            ref,
            title: l.goalWithdraw,
            label: l.goalWithdrawAmount,
            action: (amount, note) => ref
                .read(goalsControllerProvider)
                .withdraw(goal.id, amount, note: note),
          ),
          icon: const Icon(Icons.remove),
          label: Text(l.goalWithdraw),
        ),
        OutlinedButton.icon(
          onPressed: () => _transferDialog(context, ref, goal),
          icon: const Icon(Icons.swap_horiz),
          label: Text(l.goalTransfer),
        ),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.goalEditPath(goal.id)),
          icon: const Icon(Icons.edit_outlined),
          label: Text(l.commonEdit),
        ),
        if (goal.status == GoalStatus.active)
          OutlinedButton.icon(
            onPressed: () => ref.read(goalsControllerProvider).pause(goal.id),
            icon: const Icon(Icons.pause),
            label: Text(l.goalPause),
          )
        else if (goal.status == GoalStatus.paused)
          OutlinedButton.icon(
            onPressed: () => ref.read(goalsControllerProvider).resume(goal.id),
            icon: const Icon(Icons.play_arrow),
            label: Text(l.goalResume),
          ),
        OutlinedButton.icon(
          onPressed: () => _confirm(
            context,
            l.goalConfirmComplete,
            () => ref.read(goalsControllerProvider).complete(goal.id),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: Text(l.goalComplete),
        ),
        OutlinedButton.icon(
          onPressed: () => _cancelGoal(context, ref, goal),
          icon: const Icon(Icons.cancel_outlined),
          label: Text(l.goalCancel),
        ),
        OutlinedButton.icon(
          onPressed: () => ref.read(goalsControllerProvider).archive(goal.id),
          icon: const Icon(Icons.archive_outlined),
          label: Text(l.goalArchive),
        ),
      ],
    );
  }

  Future<void> _amountDialog(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String label,
    required Future<Result<void>> Function(int amount, String? note) action,
  }) async {
    final l = AppLocalizations.of(context);
    final currency = ref.read(baseCurrencyForGoalsProvider);
    final messenger = ScaffoldMessenger.of(context);
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: label,
                suffixText: currency,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: l.goalReason),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final money = Money.tryParse(amountController.text, currencyCode: currency);
    if (money == null || money.amountMinor <= 0) {
      messenger.showSnackBar(SnackBar(content: Text(l.errorGoalAmountInvalid)));
      return;
    }
    final note = noteController.text.trim();
    final result = await action(money.amountMinor, note.isEmpty ? null : note);
    result.fold(
      (_) {},
      (f) => messenger.showSnackBar(SnackBar(content: Text(l.messageFor(f)))),
    );
  }

  Future<void> _transferDialog(
    BuildContext context,
    WidgetRef ref,
    FinancialGoal goal,
  ) async {
    final l = AppLocalizations.of(context);
    final currency = ref.read(baseCurrencyForGoalsProvider);
    final messenger = ScaffoldMessenger.of(context);
    final targets = ref
        .read(goalViewsProvider)
        .where(
          (v) => v.goal.id != goal.id && v.goal.status == GoalStatus.active,
        )
        .toList();
    if (targets.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.errorGoalSameTransfer)));
      return;
    }
    final amountController = TextEditingController();
    var targetId = targets.first.goal.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.goalTransfer),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: targetId,
                decoration: InputDecoration(labelText: l.goalTransferTo),
                items: [
                  for (final t in targets)
                    DropdownMenuItem(
                      value: t.goal.id,
                      child: Text(t.goal.name),
                    ),
                ],
                onChanged: (v) => setState(() => targetId = v ?? targetId),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: l.goalTransferAmount,
                  suffixText: currency,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.commonSave),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final money = Money.tryParse(amountController.text, currencyCode: currency);
    if (money == null || money.amountMinor <= 0) {
      messenger.showSnackBar(SnackBar(content: Text(l.errorGoalAmountInvalid)));
      return;
    }
    final result = await ref
        .read(goalsControllerProvider)
        .transfer(goal.id, targetId, money.amountMinor);
    result.fold(
      (_) => messenger.showSnackBar(SnackBar(content: Text(l.goalTransferred))),
      (f) => messenger.showSnackBar(SnackBar(content: Text(l.messageFor(f)))),
    );
  }

  Future<void> _cancelGoal(
    BuildContext context,
    WidgetRef ref,
    FinancialGoal goal,
  ) async {
    final l = AppLocalizations.of(context);
    final controller = ref.read(goalsControllerProvider);
    final fund = ref.read(goalViewByIdProvider(goal.id))?.fundedMinor ?? 0;
    if (fund <= 0) {
      await _confirm(
        context,
        l.goalConfirmCancelSimple,
        () => controller.cancel(goal.id),
      );
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.goalConfirmCancelWithBalance),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'keep'),
            child: Text(l.goalCancelKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'unallocate'),
            child: Text(l.goalCancelUnallocate),
          ),
        ],
      ),
    );
    if (choice == 'keep') {
      await controller.archive(goal.id);
    } else if (choice == 'unallocate') {
      await controller.withdraw(goal.id, fund);
      await controller.cancel(goal.id);
    }
  }

  Future<void> _confirm(
    BuildContext context,
    String message,
    Future<Result<void>> Function() action,
  ) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.commonDone),
          ),
        ],
      ),
    );
    if (ok == true) await action();
  }

  Widget _row(BuildContext context, String label, Money money) {
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

  Widget _textRow(BuildContext context, String label, String value) {
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
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
