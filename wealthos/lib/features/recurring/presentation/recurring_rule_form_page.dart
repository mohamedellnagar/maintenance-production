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
import '../../accounts/domain/account.dart';
import '../../accounts/domain/account_type.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category.dart';
import '../application/recurring_controller.dart';
import '../application/recurring_providers.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_rule_input.dart';
import '../domain/recurring_type.dart';
import 'recurrence_describe.dart';

class RecurringRuleFormPage extends ConsumerStatefulWidget {
  const RecurringRuleFormPage({super.key, this.ruleId});

  final String? ruleId;
  bool get isEdit => ruleId != null;

  @override
  ConsumerState<RecurringRuleFormPage> createState() =>
      _RecurringRuleFormPageState();
}

class _RecurringRuleFormPageState extends ConsumerState<RecurringRuleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _intervalController = TextEditingController(text: '1');
  final _monthlyDayController = TextEditingController();
  final _yearlyDayController = TextEditingController();
  final _maxController = TextEditingController();
  final _reminderController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  RecurringType _type = RecurringType.expense;
  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;
  final Set<int> _weekdays = {};
  bool _monthlyByOrdinal = false;
  int _ordinal = 1;
  int _ordinalWeekday = 1;
  int _yearlyMonth = 1;
  String? _accountId;
  String? _destinationAccountId;
  String? _categoryId;
  LocalDate _startDate = LocalDate.today();
  LocalDate? _endDate;
  bool _autoCreate = false;
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _amountController,
      _intervalController,
      _monthlyDayController,
      _yearlyDayController,
      _maxController,
      _reminderController,
      _notesController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _initFrom(RecurringRule r, String currency) {
    _type = r.type;
    _frequency = r.frequency;
    _weekdays
      ..clear()
      ..addAll(r.weekdays);
    _monthlyByOrdinal = r.monthlyWeekOrdinal != null;
    _ordinal = r.monthlyWeekOrdinal ?? 1;
    _ordinalWeekday = r.monthlyWeekday ?? 1;
    _yearlyMonth = r.yearlyMonth ?? 1;
    _accountId = r.accountId;
    _destinationAccountId = r.destinationAccountId;
    _categoryId = r.categoryId;
    _startDate = r.startDate;
    _endDate = r.endDate;
    _autoCreate = r.autoCreateTransaction;
    _nameController.text = r.name;
    _amountController.text = Money(
      amountMinor: r.amountMinor,
      currencyCode: currency,
    ).major.toString();
    _intervalController.text = '${r.intervalValue}';
    _monthlyDayController.text = r.monthlyDay?.toString() ?? '';
    _yearlyDayController.text = r.yearlyDay?.toString() ?? '';
    _maxController.text = r.maxOccurrences?.toString() ?? '';
    _reminderController.text = '${r.reminderDaysBefore}';
    _notesController.text = r.notes ?? '';
    _initialized = true;
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
    final input = RecurringRuleInput(
      name: _nameController.text.trim(),
      type: _type,
      amountMinor: amount?.amountMinor ?? 0,
      currencyCode: currency,
      frequency: _frequency,
      intervalValue: int.tryParse(_intervalController.text) ?? 1,
      weekdays: _frequency == RecurrenceFrequency.weekly ? _weekdays : const {},
      accountId: _accountId,
      destinationAccountId: _type.needsDestination
          ? _destinationAccountId
          : null,
      categoryId: _type.usesCategory ? _categoryId : null,
      monthlyDay:
          _frequency == RecurrenceFrequency.monthly && !_monthlyByOrdinal
          ? int.tryParse(_monthlyDayController.text)
          : null,
      monthlyWeekOrdinal:
          _frequency == RecurrenceFrequency.monthly && _monthlyByOrdinal
          ? _ordinal
          : null,
      monthlyWeekday:
          _frequency == RecurrenceFrequency.monthly && _monthlyByOrdinal
          ? _ordinalWeekday
          : null,
      yearlyMonth: _frequency == RecurrenceFrequency.yearly
          ? _yearlyMonth
          : null,
      yearlyDay: _frequency == RecurrenceFrequency.yearly
          ? int.tryParse(_yearlyDayController.text)
          : null,
      startDate: _startDate,
      endDate: _endDate,
      maxOccurrences: _maxController.text.trim().isEmpty
          ? null
          : int.tryParse(_maxController.text),
      autoCreateTransaction: _autoCreate,
      reminderDaysBefore: int.tryParse(_reminderController.text) ?? 0,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() => _submitting = true);
    final controller = ref.read(recurringControllerProvider);
    final result = widget.isEdit
        ? await controller.updateRule(widget.ruleId!, input)
        : await controller.createRule(input);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        messenger.showSnackBar(SnackBar(content: Text(l.recurringSaved)));
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
    final currency = ref.watch(baseCurrencyProvider);
    final accounts = ref.watch(accountsProvider).value ?? const [];

    if (widget.isEdit && !_initialized) {
      final rule = ref.watch(ruleByIdProvider(widget.ruleId!)).value;
      if (rule == null) {
        return Scaffold(
          appBar: AppBar(title: Text(l.recurringRuleDetails)),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      _initFrom(rule, currency);
    }

    final assets = accounts
        .where((a) => a.classification == AccountClassification.asset)
        .toList();
    final liabilities = accounts
        .where((a) => a.classification == AccountClassification.liability)
        .toList();
    final sourceOptions = _type == RecurringType.liabilityPayment
        ? assets
        : accounts;
    final destOptions = _type == RecurringType.liabilityPayment
        ? liabilities
        : accounts;

    return Scaffold(
      appBar: AppBar(title: Text(l.recurringAddRule)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l.recurringName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.errorRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<RecurringType>(
              initialValue: _type,
              decoration: const InputDecoration(),
              items: [
                for (final t in RecurringType.values)
                  DropdownMenuItem(value: t, child: Text(t.label(l))),
              ],
              onChanged: widget.isEdit
                  ? null
                  : (t) => setState(() {
                      _type = t ?? _type;
                      _categoryId = null;
                      _accountId = null;
                      _destinationAccountId = null;
                    }),
            ),
            const SizedBox(height: AppSpacing.lg),
            _AccountDropdown(
              label: l.recurringSourceAccount,
              accounts: sourceOptions,
              value: _accountId,
              hint: _type == RecurringType.liabilityPayment
                  ? l.recurringSelectAsset
                  : null,
              onChanged: (id) => setState(() => _accountId = id),
              validator: (v) => v == null ? l.errorAccountRequired : null,
            ),
            if (_type.needsDestination) ...[
              const SizedBox(height: AppSpacing.lg),
              _AccountDropdown(
                label: l.recurringDestinationAccount,
                accounts: destOptions,
                value: _destinationAccountId,
                hint: _type == RecurringType.liabilityPayment
                    ? l.recurringSelectLiability
                    : null,
                onChanged: (id) => setState(() => _destinationAccountId = id),
                validator: (v) {
                  if (v == null) return l.errorDestinationRequired;
                  if (v == _accountId) return l.errorSameAccountTransfer;
                  return null;
                },
              ),
            ],
            if (_type.usesCategory) ...[
              const SizedBox(height: AppSpacing.lg),
              _CategoryDropdown(
                type: _type == RecurringType.income
                    ? CategoryType.income
                    : CategoryType.expense,
                value: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l.recurringAmount,
                suffixText: currency,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.errorRequired;
                final p = Money.tryParse(v, currencyCode: currency);
                if (p == null) return l.errorInvalidAmount;
                if (p.amountMinor <= 0) return l.errorAmountPositive;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<RecurrenceFrequency>(
              initialValue: _frequency,
              decoration: InputDecoration(labelText: l.recurringFrequency),
              items: [
                for (final f in RecurrenceFrequency.values)
                  DropdownMenuItem(value: f, child: Text(f.label(l))),
              ],
              onChanged: (f) => setState(() => _frequency = f ?? _frequency),
            ),
            ..._scheduleFields(l, locale),
            const SizedBox(height: AppSpacing.lg),
            _DateField(
              label: l.recurringStartDate,
              value: _startDate,
              onPick: (d) => setState(() => _startDate = d),
            ),
            _DateField(
              label: l.recurringEndDate,
              value: _endDate,
              optional: true,
              onPick: (d) => setState(() => _endDate = d),
              onClear: () => setState(() => _endDate = null),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _maxController,
              decoration: InputDecoration(
                labelText: '${l.recurringMaxOccurrences} (${l.commonOptional})',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _reminderController,
              decoration: InputDecoration(labelText: l.recurringReminderDays),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _autoCreate,
              title: Text(l.recurringAutoCreate),
              onChanged: (v) => setState(() => _autoCreate = v),
            ),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: '${l.recurringNotes} (${l.commonOptional})',
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

  List<Widget> _scheduleFields(AppLocalizations l, String locale) {
    switch (_frequency) {
      case RecurrenceFrequency.daily:
        return const [];
      case RecurrenceFrequency.customInterval:
        return [const SizedBox(height: AppSpacing.lg), _intervalField(l)];
      case RecurrenceFrequency.weekly:
        return [
          const SizedBox(height: AppSpacing.lg),
          _intervalField(l),
          const SizedBox(height: AppSpacing.md),
          Text(l.recurringWeekdays),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (var d = 1; d <= 7; d++)
                FilterChip(
                  label: Text(weekdayName(locale, d)),
                  selected: _weekdays.contains(d),
                  onSelected: (s) => setState(() {
                    if (s) {
                      _weekdays.add(d);
                    } else {
                      _weekdays.remove(d);
                    }
                  }),
                ),
            ],
          ),
        ];
      case RecurrenceFrequency.monthly:
        return [
          const SizedBox(height: AppSpacing.lg),
          _intervalField(l),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _monthlyByOrdinal,
            title: Text(l.recurringMonthlyByWeekday),
            subtitle: Text(l.recurringMonthlyByDay),
            onChanged: (v) => setState(() => _monthlyByOrdinal = v),
          ),
          if (_monthlyByOrdinal)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _ordinal,
                    decoration: InputDecoration(labelText: l.recurringOrdinal),
                    items: [
                      DropdownMenuItem(value: 1, child: Text(l.ordinalFirst)),
                      DropdownMenuItem(value: 2, child: Text(l.ordinalSecond)),
                      DropdownMenuItem(value: 3, child: Text(l.ordinalThird)),
                      DropdownMenuItem(value: 4, child: Text(l.ordinalFourth)),
                      DropdownMenuItem(value: -1, child: Text(l.ordinalLast)),
                    ],
                    onChanged: (v) => setState(() => _ordinal = v ?? 1),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _ordinalWeekday,
                    decoration: InputDecoration(labelText: l.recurringWeekday),
                    items: [
                      for (var d = 1; d <= 7; d++)
                        DropdownMenuItem(
                          value: d,
                          child: Text(weekdayName(locale, d)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _ordinalWeekday = v ?? 1),
                  ),
                ),
              ],
            )
          else
            TextFormField(
              controller: _monthlyDayController,
              decoration: InputDecoration(labelText: l.recurringMonthlyDay),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (_monthlyByOrdinal) return null;
                final d = int.tryParse(v ?? '');
                if (d == null || d < 1 || d > 31) return l.errorRequired;
                return null;
              },
            ),
        ];
      case RecurrenceFrequency.yearly:
        return [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _yearlyMonth,
                  decoration: InputDecoration(
                    labelText: l.recurringYearlyMonth,
                  ),
                  items: [
                    for (var m = 1; m <= 12; m++)
                      DropdownMenuItem(
                        value: m,
                        child: Text(
                          DateFormat.MMMM(locale).format(DateTime(2000, m)),
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _yearlyMonth = v ?? 1),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _yearlyDayController,
                  decoration: InputDecoration(labelText: l.recurringYearlyDay),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final d = int.tryParse(v ?? '');
                    if (d == null || d < 1 || d > 31) return l.errorRequired;
                    return null;
                  },
                ),
              ),
            ],
          ),
        ];
    }
  }

  Widget _intervalField(AppLocalizations l) => TextFormField(
    controller: _intervalController,
    decoration: InputDecoration(labelText: l.recurringInterval),
    keyboardType: TextInputType.number,
    validator: (v) {
      final n = int.tryParse(v ?? '');
      if (n == null || n < 1) return l.errorRecurringIntervalInvalid;
      return null;
    },
  );
}

class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown({
    required this.label,
    required this.accounts,
    required this.value,
    required this.onChanged,
    required this.validator,
    this.hint,
  });

  final String label;
  final List<Account> accounts;
  final String? value;
  final String? hint;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final valid = accounts.any((a) => a.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      initialValue: valid,
      decoration: InputDecoration(labelText: label),
      hint: hint == null ? null : Text(hint!),
      items: [
        for (final a in accounts)
          DropdownMenuItem(value: a.id, child: Text(a.name)),
      ],
      onChanged: onChanged,
      validator: validator,
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
      decoration: InputDecoration(labelText: l.recurringCategory),
      items: [
        for (final c in categories)
          DropdownMenuItem(value: c.id, child: Text(c.localizedName(language))),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? l.errorBudgetCategoryRequired : null,
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
    this.optional = false,
    this.onClear,
  });

  final String label;
  final LocalDate? value;
  final bool optional;
  final ValueChanged<LocalDate> onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(optional ? '$label (${l.commonOptional})' : label),
      subtitle: Text(
        value == null
            ? '—'
            : DateFormat.yMMMd(locale).format(value!.toDateTime()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (optional && value != null && onClear != null)
            IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
          IconButton(
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value?.toDateTime() ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) onPick(LocalDate.fromDateTime(picked));
            },
          ),
        ],
      ),
    );
  }
}
