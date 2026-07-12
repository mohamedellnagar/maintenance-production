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
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account_type.dart';
import '../application/goals_controller.dart';
import '../application/goals_providers.dart';
import '../domain/goal_input.dart';
import '../domain/goal_type.dart';

class GoalFormPage extends ConsumerStatefulWidget {
  const GoalFormPage({super.key, this.goalId});

  final String? goalId;
  bool get isEdit => goalId != null;

  @override
  ConsumerState<GoalFormPage> createState() => _GoalFormPageState();
}

class _GoalFormPageState extends ConsumerState<GoalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _initialController = TextEditingController();
  final _notesController = TextEditingController();

  GoalType _type = GoalType.custom;
  GoalPriority _priority = GoalPriority.medium;
  LocalDate? _targetDate;
  String? _liabilityAccountId;
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _initialController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(String currency) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;
    final router = GoRouter.of(context);

    final amount = Money.tryParse(
      _amountController.text,
      currencyCode: currency,
    );
    final initial = _initialController.text.trim().isEmpty
        ? null
        : Money.tryParse(_initialController.text, currencyCode: currency);
    final input = GoalInput(
      name: _nameController.text.trim(),
      type: _type,
      targetAmountMinor: amount?.amountMinor ?? 0,
      currencyCode: currency,
      priority: _priority,
      targetDate: _targetDate,
      linkedLiabilityAccountId: _type == GoalType.debtPayoff
          ? _liabilityAccountId
          : null,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() => _submitting = true);
    final controller = ref.read(goalsControllerProvider);
    final result = widget.isEdit
        ? await controller.updateGoal(widget.goalId!, input)
        : await controller.createGoal(
            input,
            initialAllocationMinor: initial?.amountMinor,
          );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        messenger.showSnackBar(SnackBar(content: Text(l.goalSaved)));
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
    final locale = Localizations.localeOf(context).toString();
    final currency = ref.watch(baseCurrencyForGoalsProvider);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final liabilities = accounts
        .where((a) => a.classification == AccountClassification.liability)
        .toList();

    if (widget.isEdit && !_initialized) {
      final goal = ref.watch(goalByIdProvider(widget.goalId!)).value;
      if (goal == null) {
        return Scaffold(
          appBar: AppBar(title: Text(l.goalDetailsTitle)),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      _type = goal.type;
      _priority = goal.priority;
      _targetDate = goal.targetDate;
      _liabilityAccountId = goal.linkedLiabilityAccountId;
      _nameController.text = goal.name;
      _amountController.text = Money(
        amountMinor: goal.targetAmountMinor,
        currencyCode: currency,
      ).major.toString();
      _notesController.text = goal.notes ?? '';
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? l.commonEdit : l.goalAdd)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            DropdownButtonFormField<GoalType>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l.goalType),
              items: [
                for (final t in GoalType.values)
                  DropdownMenuItem(value: t, child: Text(t.label(l))),
              ],
              onChanged: widget.isEdit
                  ? null
                  : (t) => setState(() {
                      _type = t ?? _type;
                      if (_type != GoalType.debtPayoff) {
                        _liabilityAccountId = null;
                      }
                    }),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l.goalName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.errorRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l.goalAmount,
                suffixText: currency,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.errorRequired;
                final p = Money.tryParse(v, currencyCode: currency);
                if (p == null) return l.errorInvalidAmount;
                if (p.amountMinor <= 0) return l.errorGoalTargetInvalid;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<GoalPriority>(
              initialValue: _priority,
              decoration: InputDecoration(labelText: l.goalPriority),
              items: [
                for (final p in GoalPriority.values)
                  DropdownMenuItem(value: p, child: Text(p.label(l))),
              ],
              onChanged: (p) => setState(() => _priority = p ?? _priority),
            ),
            if (_type == GoalType.debtPayoff) ...[
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue:
                    liabilities.any((a) => a.id == _liabilityAccountId)
                    ? _liabilityAccountId
                    : null,
                decoration: InputDecoration(labelText: l.goalLinkedLiability),
                hint: Text(l.goalSelectLiability),
                items: [
                  for (final a in liabilities)
                    DropdownMenuItem(value: a.id, child: Text(a.name)),
                ],
                onChanged: (id) => setState(() => _liabilityAccountId = id),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${l.goalTargetDate} (${l.commonOptional})'),
              subtitle: Text(
                _targetDate == null
                    ? l.goalNoTargetDate
                    : DateFormat.yMMMd(
                        locale,
                      ).format(_targetDate!.toDateTime()),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_targetDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _targetDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar_outlined),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            _targetDate?.toDateTime() ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(
                          () => _targetDate = LocalDate.fromDateTime(picked),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            if (!widget.isEdit) ...[
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _initialController,
                decoration: InputDecoration(
                  labelText: '${l.goalInitialAllocation} (${l.commonOptional})',
                  suffixText: currency,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: '${l.goalNotes} (${l.commonOptional})',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _submitting ? null : () => _submit(currency),
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
