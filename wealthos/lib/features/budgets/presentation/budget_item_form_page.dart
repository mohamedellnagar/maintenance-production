import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account.dart';
import '../../accounts/domain/account_type.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category.dart';
import '../../goals/application/goals_providers.dart';
import '../application/budget_controller.dart';
import '../application/budgets_providers.dart';
import '../domain/budget_item.dart';
import '../domain/budget_item_input.dart';

class BudgetItemFormPage extends ConsumerStatefulWidget {
  const BudgetItemFormPage({super.key, this.itemId});

  final String? itemId;
  bool get isEdit => itemId != null;

  @override
  ConsumerState<BudgetItemFormPage> createState() => _BudgetItemFormPageState();
}

class _BudgetItemFormPageState extends ConsumerState<BudgetItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  BudgetItemType _type = BudgetItemType.expense;
  String? _categoryId;
  String? _accountId;
  String? _linkedGoalId;
  bool _rollover = false;
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initFrom(BudgetItem item) {
    _type = item.type;
    _categoryId = item.categoryId;
    _accountId = item.accountId;
    _linkedGoalId = item.linkedGoalId;
    _rollover = item.rolloverEnabled;
    _nameController.text = item.customName ?? '';
    _notesController.text = item.notes ?? '';
    _amountController.text = Money(
      amountMinor: item.assignedAmountMinor,
      currencyCode: 'AED',
    ).major.toString();
    _initialized = true;
  }

  Future<void> _submit(String currency, String? budgetId) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (!widget.isEdit && budgetId == null) return;
    final router = GoRouter.of(context);

    final assigned = Money.tryParse(
      _amountController.text,
      currencyCode: currency,
    );
    final input = BudgetItemInput(
      type: _type,
      assignedAmountMinor: assigned?.amountMinor ?? 0,
      categoryId: _type.usesCategory ? _categoryId : null,
      accountId: _type == BudgetItemType.debtPayment ? _accountId : null,
      customName: _type == BudgetItemType.saving
          ? (_nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim())
          : null,
      linkedGoalId: _type == BudgetItemType.saving ? _linkedGoalId : null,
      rolloverEnabled: _type == BudgetItemType.expense && _rollover,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() => _submitting = true);
    final controller = ref.read(budgetControllerProvider);
    final result = widget.isEdit
        ? await controller.updateItem(widget.itemId!, input)
        : await controller.addItem(budgetId!, input);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        messenger.showSnackBar(SnackBar(content: Text(l.budgetItemSaved)));
        router.pop();
      },
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currency = ref.watch(baseCurrencyProvider);
    final month = ref.watch(selectedBudgetMonthProvider);
    final budgetId = ref.watch(budgetViewProvider(month)).value?.budget.id;

    if (widget.isEdit && !_initialized) {
      final item = ref.watch(budgetItemByIdProvider(widget.itemId!)).value;
      if (item == null) {
        return Scaffold(
          appBar: AppBar(title: Text(l.budgetItemDetailsTitle)),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      _initFrom(item);
    }

    final accounts = ref.watch(accountsProvider).value ?? const [];
    final liabilityAccounts = accounts
        .where((a) => a.classification == AccountClassification.liability)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.budgetAddItem)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            DropdownButtonFormField<BudgetItemType>(
              initialValue: _type,
              decoration: const InputDecoration(),
              items: [
                for (final t in BudgetItemType.values)
                  DropdownMenuItem(value: t, child: Text(t.label(l))),
              ],
              // Type is fixed after creation to keep unique/hierarchy rules simple.
              onChanged: widget.isEdit
                  ? null
                  : (t) => setState(() {
                      _type = t ?? _type;
                      _categoryId = null;
                      _accountId = null;
                    }),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_type == BudgetItemType.expense ||
                _type == BudgetItemType.incomePlan)
              _CategoryDropdown(
                type: _type == BudgetItemType.incomePlan
                    ? CategoryType.income
                    : CategoryType.expense,
                value: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
            if (_type == BudgetItemType.debtPayment)
              _LiabilityDropdown(
                accounts: liabilityAccounts,
                value: _accountId,
                onChanged: (id) => setState(() => _accountId = id),
              ),
            if (_type == BudgetItemType.saving) ...[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l.budgetItemName),
              ),
              const SizedBox(height: AppSpacing.md),
              _GoalDropdown(
                value: _linkedGoalId,
                onChanged: (id) => setState(() => _linkedGoalId = id),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: switch (_type) {
                  BudgetItemType.incomePlan => l.budgetExpectedAmount,
                  BudgetItemType.debtPayment => l.budgetPlannedPayment,
                  _ => l.budgetAssignedAmount,
                },
                suffixText: currency,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.errorRequired;
                final parsed = Money.tryParse(v, currencyCode: currency);
                if (parsed == null) return l.errorInvalidAmount;
                if (parsed.amountMinor < 0) {
                  return l.errorBudgetAssignedNegative;
                }
                return null;
              },
            ),
            if (_type == BudgetItemType.expense) ...[
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _rollover,
                title: Text(l.budgetRolloverEnabled),
                onChanged: (v) => setState(() => _rollover = v),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: '${l.budgetItemNotes} (${l.commonOptional})',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _submitting ? null : () => _submit(currency, budgetId),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown({
    required this.type,
    required this.value,
    required this.onChanged,
  });

  final CategoryType type;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final categories =
        ref.watch(categoriesByTypeProvider(type)).value ?? const [];
    final valid = categories.any((c) => c.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      initialValue: valid,
      decoration: InputDecoration(
        labelText: type == CategoryType.income
            ? l.budgetSelectIncomeCategory
            : l.budgetSelectExpenseCategory,
      ),
      items: [
        for (final c in categories)
          DropdownMenuItem(value: c.id, child: Text(c.localizedName(language))),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? l.errorBudgetCategoryRequired : null,
    );
  }
}

class _GoalDropdown extends ConsumerWidget {
  const _GoalDropdown({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final goals = ref.watch(activeGoalViewsProvider);
    final valid = goals.any((g) => g.goal.id == value) ? value : null;
    return DropdownButtonFormField<String?>(
      initialValue: valid,
      decoration: InputDecoration(labelText: l.budgetLinkedGoal),
      items: [
        DropdownMenuItem(value: null, child: Text(l.budgetLinkGoalNone)),
        for (final g in goals)
          DropdownMenuItem(value: g.goal.id, child: Text(g.goal.name)),
      ],
      onChanged: onChanged,
    );
  }
}

class _LiabilityDropdown extends StatelessWidget {
  const _LiabilityDropdown({
    required this.accounts,
    required this.value,
    required this.onChanged,
  });

  final List<Account> accounts;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final valid = accounts.any((a) => a.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      initialValue: valid,
      decoration: InputDecoration(labelText: l.budgetSelectLiability),
      items: [
        for (final a in accounts)
          DropdownMenuItem(value: a.id, child: Text(a.name)),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? l.errorBudgetLiabilityRequired : null,
    );
  }
}
