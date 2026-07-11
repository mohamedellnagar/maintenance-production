import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category.dart';
import '../../settings/application/settings_providers.dart';
import '../domain/new_transaction_input.dart';
import '../domain/transaction_type.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _reasonController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _accountId;
  String? _destinationAccountId;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit(String currency) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;
    final router = GoRouter.of(context);

    final money = Money.tryParse(
      _amountController.text,
      currencyCode: currency,
    );
    if (money == null) {
      messenger.showSnackBar(SnackBar(content: Text(l.errorInvalidAmount)));
      return;
    }

    setState(() => _submitting = true);
    final input = NewTransactionInput(
      type: _type,
      amountMinor: money.amountMinor,
      currencyCode: currency,
      date: _date,
      accountId: _accountId,
      destinationAccountId: _type == TransactionType.transfer
          ? _destinationAccountId
          : null,
      categoryId: _type.isCashFlow ? _categoryId : null,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      adjustmentReason: _type == TransactionType.adjustment
          ? _reasonController.text.trim()
          : null,
    );

    final result = await ref.read(transactionsRepositoryProvider).create(input);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        messenger.showSnackBar(SnackBar(content: Text(l.transactionSaved)));
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
    final currency = ref.watch(currentSettingsProvider)?.baseCurrency ?? 'AED';
    final accounts = ref.watch(accountsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l.transactionAdd)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            _TypeSelector(
              value: _type,
              onChanged: (t) => setState(() {
                _type = t;
                _categoryId = null;
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l.commonAmount,
                suffixText: currency,
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: _type == TransactionType.adjustment,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.errorRequired;
                final parsed = Money.tryParse(v, currencyCode: currency);
                if (parsed == null) return l.errorInvalidAmount;
                if (_type != TransactionType.adjustment &&
                    parsed.amountMinor <= 0) {
                  return l.errorAmountPositive;
                }
                if (_type == TransactionType.adjustment &&
                    parsed.amountMinor == 0) {
                  return l.errorAmountPositive;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _AccountDropdown(
              label: _type == TransactionType.transfer
                  ? l.transactionFromAccount
                  : l.transactionAccount,
              accounts: accounts,
              value: _accountId,
              onChanged: (id) => setState(() => _accountId = id),
              validator: (v) => v == null ? l.errorAccountRequired : null,
            ),
            if (_type == TransactionType.transfer) ...[
              const SizedBox(height: AppSpacing.lg),
              _AccountDropdown(
                label: l.transactionToAccount,
                accounts: accounts,
                value: _destinationAccountId,
                onChanged: (id) => setState(() => _destinationAccountId = id),
                validator: (v) {
                  if (v == null) return l.errorDestinationRequired;
                  if (v == _accountId) return l.errorSameAccountTransfer;
                  return null;
                },
              ),
            ],
            if (_type.isCashFlow) ...[
              const SizedBox(height: AppSpacing.lg),
              _CategoryDropdown(
                type: _type == TransactionType.income
                    ? CategoryType.income
                    : CategoryType.expense,
                value: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
            ],
            if (_type == TransactionType.adjustment) ...[
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: l.transactionAdjustmentReason,
                  helperText: l.transactionAdjustmentHint,
                  helperMaxLines: 3,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l.errorAdjustmentReasonRequired
                    : null,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: _pickDate,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l.commonDate),
              subtitle: Text(
                DateFormat.yMMMd(
                  Localizations.localeOf(context).toString(),
                ).format(_date),
              ),
              trailing: const Icon(Icons.edit_calendar_outlined),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: '${l.commonNote} (${l.commonOptional})',
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

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.value, required this.onChanged});

  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SegmentedButton<TransactionType>(
      segments: [
        for (final type in TransactionType.values)
          ButtonSegment(value: type, label: Text(type.label(l))),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown({
    required this.label,
    required this.accounts,
    required this.value,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final List<Account> accounts;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      hint: Text(l.transactionSelectAccount),
      items: [
        for (final account in accounts)
          DropdownMenuItem(value: account.id, child: Text(account.name)),
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
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: '${l.transactionCategory} (${l.commonOptional})',
      ),
      hint: Text(l.transactionSelectCategory),
      items: [
        for (final category in categories)
          DropdownMenuItem(
            value: category.id,
            child: Text(category.localizedName(language)),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
