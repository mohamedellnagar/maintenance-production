import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../application/recurring_controller.dart';
import '../application/recurring_providers.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_type.dart';
import 'recurrence_describe.dart';
import 'widgets/occurrence_tile.dart';

class RecurringRuleDetailsPage extends ConsumerWidget {
  const RecurringRuleDetailsPage({required this.ruleId, super.key});

  final String ruleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ruleAsync = ref.watch(ruleByIdProvider(ruleId));
    return Scaffold(
      appBar: AppBar(
        title: Text(ruleAsync.value?.name ?? l.recurringRuleDetails),
      ),
      body: ruleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (rule) {
          if (rule == null) return Center(child: Text(l.errorRuleNotFound));
          return _Body(rule: rule);
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.rule});
  final RecurringRule rule;

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref,
    String message,
    Future<void> Function() action, {
    bool pop = false,
  }) async {
    final l = AppLocalizations.of(context);
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
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
    if (ok != true) return;
    await action();
    if (pop) router.pop();
    messenger.clearSnackBars();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final controller = ref.read(recurringControllerProvider);
    final views = ref
        .watch(occurrenceViewsProvider)
        .where((v) => v.rule.id == rule.id)
        .toList();
    final posted = views
        .where((v) => v.status == OccurrenceDisplayStatus.paid)
        .length;
    final overdue = views
        .where((v) => v.status == OccurrenceDisplayStatus.overdue)
        .length;
    final next = views
        .where(
          (v) =>
              v.status == OccurrenceDisplayStatus.scheduled ||
              v.status == OccurrenceDisplayStatus.due,
        )
        .fold<Object?>(null, (min, v) => min ?? v);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(rule.type.label(l))),
                    Chip(
                      label: Text(
                        rule.isActive ? l.recurringActive : l.recurringPaused,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                MoneyText(
                  Money(
                    amountMinor: rule.amountMinor,
                    currencyCode: rule.currencyCode,
                  ),
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(describeRecurrence(l, locale, rule)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Row(
          label: l.recurringNextDue,
          value: next is OccurrenceView
              ? DateFormat.yMMMd(
                  locale,
                ).format(next.effectiveDueDate.toDateTime())
              : '—',
        ),
        _Row(label: l.recurringCompletedCount, value: '$posted'),
        _Row(label: l.recurringOverdueCount, value: '$overdue'),
        if (rule.notes != null && rule.notes!.isNotEmpty)
          _Row(label: l.recurringNotes, value: rule.notes!),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (rule.isActive)
              OutlinedButton.icon(
                onPressed: () => controller.pause(rule.id),
                icon: const Icon(Icons.pause),
                label: Text(l.recurringPause),
              )
            else
              OutlinedButton.icon(
                onPressed: () => controller.resume(rule.id),
                icon: const Icon(Icons.play_arrow),
                label: Text(l.recurringResume),
              ),
            OutlinedButton.icon(
              onPressed: () =>
                  context.push(AppRoutes.recurringRuleEditPath(rule.id)),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l.commonEdit),
            ),
            OutlinedButton.icon(
              onPressed: () => _confirm(
                context,
                ref,
                l.recurringEndConfirm,
                () async => controller.endRule(rule.id),
              ),
              icon: const Icon(Icons.stop_circle_outlined),
              label: Text(l.recurringEnd),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  _confirm(context, ref, l.recurringDeleteConfirm, () async {
                    final r = await controller.deleteRule(rule.id);
                    if (r.isFailure && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.messageFor(r.failureOrNull!))),
                      );
                    }
                  }, pop: true),
              icon: const Icon(Icons.delete_outline),
              label: Text(l.commonDelete),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l.recurringRecentTransactions, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...views
            .where((v) => v.status == OccurrenceDisplayStatus.paid)
            .take(5)
            .map((v) => OccurrenceTile(view: v)),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

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
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
