import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/time/local_date.dart';
import '../../../core/widgets/money_text.dart';
import '../application/recurring_controller.dart';
import '../application/recurring_providers.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_type.dart';

class OccurrenceDetailsPage extends ConsumerWidget {
  const OccurrenceDetailsPage({required this.occurrenceId, super.key});

  final String occurrenceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final view = ref
        .watch(occurrenceViewsProvider)
        .where((v) => v.occurrence.id == occurrenceId)
        .cast<OccurrenceView?>()
        .firstWhere((v) => true, orElse: () => null);

    return Scaffold(
      appBar: AppBar(title: Text(l.occurrenceDetails)),
      body: view == null
          ? Center(child: Text(l.errorOccurrenceNotFound))
          : _Body(view: view),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.view});
  final OccurrenceView view;

  bool get _postable =>
      view.status == OccurrenceDisplayStatus.due ||
      view.status == OccurrenceDisplayStatus.overdue ||
      view.status == OccurrenceDisplayStatus.scheduled;

  Future<void> _post(
    BuildContext context,
    WidgetRef ref, {
    PostOverrides overrides = const PostOverrides(),
  }) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final result = await ref
        .read(recurringControllerProvider)
        .post(view.occurrence.id, overrides: overrides);
    if (!context.mounted) return;
    result.fold((_) {
      messenger.showSnackBar(SnackBar(content: Text(l.occPosted)));
      router.pop();
    }, (f) => messenger.showSnackBar(SnackBar(content: Text(l.messageFor(f)))));
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.occSkipConfirm),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: l.occSkipReason),
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
            child: Text(l.occSkip),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref
        .read(recurringControllerProvider)
        .skip(
          view.occurrence.id,
          reason: controller.text.trim().isEmpty
              ? null
              : controller.text.trim(),
        );
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l.occSkippedMsg)));
    router.pop();
  }

  Future<void> _snooze(BuildContext context, WidgetRef ref) async {
    final today = ref.read(recurringTodayProvider);
    await ref
        .read(recurringControllerProvider)
        .snooze(view.occurrence.id, today.addDays(7));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).occSnoozed)),
    );
  }

  Future<void> _editBeforePosting(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final currency = view.rule.currencyCode;
    final amountController = TextEditingController(
      text: Money(
        amountMinor: view.expectedAmountMinor,
        currencyCode: currency,
      ).major.toString(),
    );
    var date = view.effectiveDueDate;
    final result = await showDialog<PostOverrides>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.occEditBeforePosting),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: l.recurringAmount),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.commonDate),
                subtitle: Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(ctx).toString(),
                  ).format(date.toDateTime()),
                ),
                trailing: const Icon(Icons.edit_calendar_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: date.toDateTime(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => date = LocalDate.fromDateTime(picked));
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () {
                final money = Money.tryParse(
                  amountController.text,
                  currencyCode: currency,
                );
                Navigator.pop(
                  ctx,
                  PostOverrides(amountMinor: money?.amountMinor, date: date),
                );
              },
              child: Text(l.commonSave),
            ),
          ],
        ),
      ),
    );
    if (result != null && context.mounted) {
      await _post(context, ref, overrides: result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final o = view.occurrence;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(view.rule.name, style: theme.textTheme.titleLarge),
            ),
            Chip(label: Text(view.status.label(l))),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _Row(
          label: l.occExpectedAmount,
          child: MoneyText(
            Money(
              amountMinor: view.expectedAmountMinor,
              currencyCode: view.rule.currencyCode,
            ),
          ),
        ),
        _InfoRow(
          label: l.occOriginalDate,
          value: DateFormat.yMMMd(
            locale,
          ).format(o.originalDueDate.toDateTime()),
        ),
        if (o.snoozedUntil != null)
          _InfoRow(
            label: l.occSnoozedDate,
            value: DateFormat.yMMMd(
              locale,
            ).format(o.snoozedUntil!.toDateTime()),
          ),
        _InfoRow(label: l.recurringType, value: view.type.label(l)),
        if (o.skipReason != null && o.skipReason!.isNotEmpty)
          _InfoRow(label: l.occSkipReason, value: o.skipReason!),
        const SizedBox(height: AppSpacing.lg),
        if (_postable) ...[
          FilledButton.icon(
            onPressed: () => _post(context, ref),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              view.type == RecurringType.income
                  ? l.occMarkReceived
                  : l.occMarkPaid,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed: () => _editBeforePosting(context, ref),
                icon: const Icon(Icons.edit_outlined),
                label: Text(l.occEditBeforePosting),
              ),
              OutlinedButton.icon(
                onPressed: () => _snooze(context, ref),
                icon: const Icon(Icons.snooze),
                label: Text(l.occSnooze1Week),
              ),
              OutlinedButton.icon(
                onPressed: () => _skip(context, ref),
                icon: const Icon(Icons.skip_next),
                label: Text(l.occSkip),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});
  final String label;
  final Widget child;

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
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => _Row(label: label, child: Text(value));
}
