import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../../categories/domain/category.dart';
import '../application/budget_controller.dart';
import '../application/budgets_providers.dart';
import '../domain/budget.dart';
import '../domain/budget_calculator.dart';

class CloseMonthPage extends ConsumerStatefulWidget {
  const CloseMonthPage({super.key});

  @override
  ConsumerState<CloseMonthPage> createState() => _CloseMonthPageState();
}

class _CloseMonthPageState extends ConsumerState<CloseMonthPage> {
  final _selected = <String>{};
  bool _initialized = false;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final month = ref.watch(selectedBudgetMonthProvider);
    final view = ref.watch(budgetViewProvider(month)).value;
    final categories = ref.watch(allCategoriesProvider).value ?? const [];
    final byId = {for (final c in categories) c.id: c};

    if (view == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.budgetCloseTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currency = view.summary.currencyCode;
    // Candidates: expense items with rollover enabled and a positive remaining.
    final candidates = view.expenses
        .where((e) => e.item.rolloverEnabled && e.remainingMinor > 0)
        .toList();
    if (!_initialized) {
      _selected.addAll(candidates.map((e) => e.item.id));
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.budgetCloseTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Text(l.budgetCloseReview),
          const SizedBox(height: AppSpacing.md),
          _Line(
            label: l.budgetActualIncome,
            money: Money(
              amountMinor: view.summary.actualIncomeMinor,
              currencyCode: currency,
            ),
          ),
          _Line(
            label: l.budgetActualExpense,
            money: Money(
              amountMinor: view.summary.totalActualExpenseMinor,
              currencyCode: currency,
            ),
          ),
          _Line(
            label: l.budgetTotalRemaining,
            money: Money(
              amountMinor: view.summary.totalRemainingMinor,
              currencyCode: currency,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (candidates.isNotEmpty) ...[
            Text(
              l.budgetCloseSelectRollover,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (final e in candidates)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _selected.contains(e.item.id),
                onChanged: (v) => setState(() {
                  if (v ?? false) {
                    _selected.add(e.item.id);
                  } else {
                    _selected.remove(e.item.id);
                  }
                }),
                title: Text(_categoryName(byId, e, context)),
                secondary: MoneyText(
                  Money(amountMinor: e.remainingMinor, currencyCode: currency),
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _submitting
                ? null
                : () => _close(context, candidates, view.budget, view.summary),
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.budgetCloseConfirm),
          ),
        ],
      ),
    );
  }

  String _categoryName(
    Map<String, Category> byId,
    ExpenseItemResult result,
    BuildContext context,
  ) {
    final language = Localizations.localeOf(context).languageCode;
    return byId[result.item.categoryId]?.localizedName(language) ?? '—';
  }

  Future<void> _close(
    BuildContext context,
    List<ExpenseItemResult> candidates,
    Budget budget,
    BudgetSummary summary,
  ) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    setState(() => _submitting = true);
    final selectedResults = candidates
        .where((e) => _selected.contains(e.item.id))
        .toList();
    final result = await ref
        .read(budgetControllerProvider)
        .closeMonth(
          budget: budget,
          selectedRolloverItems: selectedResults,
          summary: summary,
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) => router.pop(),
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.money});
  final String label;
  final Money money;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), MoneyText(money)],
      ),
    );
  }
}
