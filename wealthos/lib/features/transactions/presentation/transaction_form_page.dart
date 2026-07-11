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
import '../../accounts/domain/account_balance.dart';
import '../../accounts/domain/balance_calculator.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category.dart';
import '../../settings/application/settings_providers.dart';
import '../application/transactions_providers.dart';
import '../domain/adjustment_calculator.dart';
import '../domain/new_transaction_input.dart';
import '../domain/transaction.dart';
import '../domain/transaction_type.dart';

/// Unified create/edit screen for all transaction types. In edit mode
/// ([transactionId] set) it loads the existing row and updates it atomically.
class TransactionFormPage extends ConsumerStatefulWidget {
  const TransactionFormPage({super.key, this.transactionId});

  final String? transactionId;

  bool get isEdit => transactionId != null;

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _actualBalanceController = TextEditingController();
  final _noteController = TextEditingController();
  final _reasonController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _accountId;
  String? _destinationAccountId;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _amountController.dispose();
    _actualBalanceController.dispose();
    _noteController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _initFromExisting(
    Transaction tx,
    List<Account> accounts,
    List<Transaction> allTx,
  ) {
    _type = tx.type;
    _accountId = tx.accountId;
    _destinationAccountId = tx.destinationAccountId;
    _categoryId = tx.categoryId;
    _date = tx.date;
    _noteController.text = tx.note ?? '';
    _reasonController.text = tx.adjustmentReason ?? '';
    if (tx.type == TransactionType.adjustment) {
      final account = _accountForId(accounts, tx.accountId);
      if (account != null) {
        // Reconstruct the actual balance this adjustment targeted.
        final calc = BalanceCalculator.signedBalanceMinor(
          account,
          allTx,
          excludeTransactionId: tx.id,
        );
        final desiredSigned = calc + tx.amountMinor;
        final actualDisplay = AccountBalance.fromSigned(
          account,
          desiredSigned,
        ).displayBalanceMinor;
        _actualBalanceController.text = _minorToInput(
          actualDisplay,
          account.currencyCode,
        );
      }
    } else {
      _amountController.text = _minorToInput(tx.amountMinor, tx.currencyCode);
    }
    _initialized = true;
  }

  String _minorToInput(int minor, String currencyCode) =>
      Money(amountMinor: minor, currencyCode: currencyCode).major.toString();

  Account? _accountForId(List<Account> accounts, String? id) {
    if (id == null) return null;
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return null;
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

  Future<void> _submit(
    String currency,
    List<Account> accounts,
    List<Transaction> allTx,
  ) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;

    final int amountMinor;
    if (_type == TransactionType.adjustment) {
      final delta = _adjustmentDelta(accounts, allTx);
      if (delta == null || delta == 0) {
        messenger.showSnackBar(
          SnackBar(content: Text(l.errorAdjustmentNoChange)),
        );
        return;
      }
      amountMinor = delta;
    } else {
      final money = Money.tryParse(
        _amountController.text,
        currencyCode: currency,
      );
      if (money == null) {
        messenger.showSnackBar(SnackBar(content: Text(l.errorInvalidAmount)));
        return;
      }
      amountMinor = money.amountMinor;
    }

    final router = GoRouter.of(context);
    setState(() => _submitting = true);
    final input = NewTransactionInput(
      type: _type,
      amountMinor: amountMinor,
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

    final repo = ref.read(transactionsRepositoryProvider);
    final result = widget.isEdit
        ? await repo.update(widget.transactionId!, input)
        : await repo.create(input);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit ? l.transactionUpdated : l.transactionSaved,
            ),
          ),
        );
        router.pop();
      },
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }

  /// The signed delta an adjustment would store, or null if inputs incomplete.
  int? _adjustmentDelta(List<Account> accounts, List<Transaction> allTx) {
    final account = _accountForId(accounts, _accountId);
    if (account == null) return null;
    final actual = Money.tryParse(
      _actualBalanceController.text,
      currencyCode: account.currencyCode,
    );
    if (actual == null) return null;
    final calc = BalanceCalculator.signedBalanceMinor(
      account,
      allTx,
      excludeTransactionId: widget.transactionId,
    );
    return AdjustmentCalculator.delta(
      classification: account.classification,
      actualDisplayMinor: actual.amountMinor,
      calculatedSignedMinor: calc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currency = ref.watch(currentSettingsProvider)?.baseCurrency ?? 'AED';
    final accountsAsync = ref.watch(allAccountsProvider);
    final txAsync = ref.watch(allTransactionsProvider);
    final allAccounts = accountsAsync.value ?? const [];
    final allTx = txAsync.value ?? const [];

    // Load existing transaction once, in edit mode — only after all inputs are
    // available so the adjustment actual-balance can be reconstructed.
    if (widget.isEdit && !_initialized) {
      final existing = ref
          .watch(transactionByIdProvider(widget.transactionId!))
          .value;
      if (existing == null || !accountsAsync.hasValue || !txAsync.hasValue) {
        return Scaffold(
          appBar: AppBar(title: Text(l.transactionEdit)),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      _initFromExisting(existing, allAccounts, allTx);
    }

    // Selectable accounts: non-archived plus any currently-selected account.
    final selectable = allAccounts
        .where(
          (a) =>
              !a.isArchived ||
              a.id == _accountId ||
              a.id == _destinationAccountId,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? l.transactionEdit : l.transactionAdd),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            _TypeSelector(
              value: _type,
              onChanged: (t) => setState(() {
                _type = t;
                // Re-validate context after a type change: clear now-invalid
                // fields so no stale rights survive.
                _categoryId = null;
                if (t != TransactionType.transfer) _destinationAccountId = null;
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_type != TransactionType.adjustment)
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l.commonAmount,
                  suffixText: currency,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.errorRequired;
                  final parsed = Money.tryParse(v, currencyCode: currency);
                  if (parsed == null) return l.errorInvalidAmount;
                  if (parsed.amountMinor <= 0) return l.errorAmountPositive;
                  return null;
                },
              ),
            const SizedBox(height: AppSpacing.lg),
            _AccountDropdown(
              label: _type == TransactionType.transfer
                  ? l.transactionFromAccount
                  : l.transactionAccount,
              accounts: selectable,
              value: _accountId,
              onChanged: (id) => setState(() => _accountId = id),
              validator: (v) => v == null ? l.errorAccountRequired : null,
            ),
            if (_type == TransactionType.transfer) ...[
              const SizedBox(height: AppSpacing.lg),
              _AccountDropdown(
                label: l.transactionToAccount,
                accounts: selectable,
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
            if (_type == TransactionType.adjustment)
              _AdjustmentSection(
                account: _accountForId(selectable, _accountId),
                allTransactions: allTx,
                excludeTransactionId: widget.transactionId,
                actualController: _actualBalanceController,
                reasonController: _reasonController,
                onChanged: () => setState(() {}),
              ),
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
              onPressed: _submitting
                  ? null
                  : () => _submit(currency, selectable, allTx),
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

class _AdjustmentSection extends StatelessWidget {
  const _AdjustmentSection({
    required this.account,
    required this.allTransactions,
    required this.excludeTransactionId,
    required this.actualController,
    required this.reasonController,
    required this.onChanged,
  });

  final Account? account;
  final List<Transaction> allTransactions;
  final String? excludeTransactionId;
  final TextEditingController actualController;
  final TextEditingController reasonController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();

    AccountBalance? calculated;
    int? differenceDisplay;
    if (account != null) {
      final signed = BalanceCalculator.signedBalanceMinor(
        account!,
        allTransactions,
        excludeTransactionId: excludeTransactionId,
      );
      calculated = AccountBalance.fromSigned(account!, signed);
      final actual = Money.tryParse(
        actualController.text,
        currencyCode: account!.currencyCode,
      );
      if (actual != null) {
        differenceDisplay = actual.amountMinor - calculated.displayBalanceMinor;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        if (calculated != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.transactionCalculatedBalance,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    calculated.display.format(locale: locale),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: actualController,
          decoration: InputDecoration(
            labelText: l.transactionActualBalance,
            helperText: l.transactionAdjustmentHint,
            helperMaxLines: 3,
            suffixText: account?.currencyCode,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged(),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l.errorRequired;
            if (account == null) return l.errorAccountRequired;
            final parsed = Money.tryParse(
              v,
              currencyCode: account!.currencyCode,
            );
            if (parsed == null) return l.errorInvalidAmount;
            return null;
          },
        ),
        if (differenceDisplay != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l.transactionDifference}: '
            '${Money(amountMinor: differenceDisplay, currencyCode: account!.currencyCode).format(locale: locale)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: differenceDisplay == 0
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.primary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: reasonController,
          decoration: InputDecoration(labelText: l.transactionAdjustmentReason),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? l.errorAdjustmentReasonRequired
              : null,
        ),
      ],
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
    // Keep the current value only if it is still a valid option.
    final validValue = categories.any((c) => c.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      initialValue: validValue,
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
