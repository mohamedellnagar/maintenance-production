import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/budget_controller.dart';
import '../application/budgets_providers.dart';

class BudgetCreatePage extends ConsumerStatefulWidget {
  const BudgetCreatePage({super.key});

  @override
  ConsumerState<BudgetCreatePage> createState() => _BudgetCreatePageState();
}

class _BudgetCreatePageState extends ConsumerState<BudgetCreatePage> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    await action();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _createEmpty() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final month = ref.read(selectedBudgetMonthProvider);
    await _run(() async {
      final result = await ref
          .read(budgetControllerProvider)
          .createEmpty(month.year, month.month);
      if (!mounted) return;
      result.fold(
        (_) => router.pop(),
        (failure) => messenger.showSnackBar(
          SnackBar(content: Text(l.messageFor(failure))),
        ),
      );
    });
  }

  Future<void> _copyPrevious() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final month = ref.read(selectedBudgetMonthProvider);
    await _run(() async {
      final result = await ref
          .read(budgetControllerProvider)
          .copyPrevious(month.year, month.month);
      if (!mounted) return;
      result.fold(
        (data) {
          if (data.skipped > 0) {
            messenger.showSnackBar(
              SnackBar(content: Text(l.budgetCopiedSkipped(data.skipped))),
            );
          }
          router.pop();
        },
        (failure) => messenger.showSnackBar(
          SnackBar(content: Text(l.messageFor(failure))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.budgetCreateTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          FilledButton.icon(
            onPressed: _busy ? null : _createEmpty,
            icon: const Icon(Icons.add),
            label: Text(l.budgetCreateEmpty),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _busy ? null : _copyPrevious,
            icon: const Icon(Icons.copy_all_outlined),
            label: Text(l.budgetCopyPrevious),
          ),
          if (_busy) ...[
            const SizedBox(height: AppSpacing.lg),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
