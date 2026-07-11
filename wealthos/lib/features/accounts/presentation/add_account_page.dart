import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../settings/application/settings_providers.dart';
import '../data/accounts_repository.dart';
import '../domain/account_type.dart';

class AddAccountPage extends ConsumerStatefulWidget {
  const AddAccountPage({super.key});

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _openingController = TextEditingController();
  final _institutionController = TextEditingController();

  AccountType _type = AccountType.cash;
  AccountClassification _classification =
      AccountType.cash.defaultClassification;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _openingController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  void _onTypeChanged(AccountType? type) {
    if (type == null) return;
    setState(() {
      _type = type;
      // Non-`other` types have a fixed classification.
      if (!type.classificationIsUserSelectable) {
        _classification = type.defaultClassification;
      }
    });
  }

  Future<void> _submit(String currency) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;
    final router = GoRouter.of(context);

    setState(() => _submitting = true);

    var openingMinor = 0;
    final raw = _openingController.text.trim();
    if (raw.isNotEmpty) {
      openingMinor = Money.parse(raw, currencyCode: currency).amountMinor;
      // For liabilities the user enters the amount owed (positive); store it as
      // a negative net-worth contribution so one balance formula fits all.
      if (_classification == AccountClassification.liability) {
        openingMinor = -openingMinor;
      }
    }

    final result = await ref
        .read(accountsRepositoryProvider)
        .create(
          NewAccountInput(
            name: _nameController.text,
            type: _type,
            classification: _classification,
            currencyCode: currency,
            openingBalanceMinor: openingMinor,
            institutionName: _institutionController.text.trim().isEmpty
                ? null
                : _institutionController.text.trim(),
          ),
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currency = ref.watch(currentSettingsProvider)?.baseCurrency ?? 'AED';
    final isLiability = _classification == AccountClassification.liability;

    return Scaffold(
      appBar: AppBar(title: Text(l.accountsAdd)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l.accountsName),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.errorRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<AccountType>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l.accountsType),
              items: [
                for (final type in AccountType.values)
                  DropdownMenuItem(value: type, child: Text(type.label(l))),
              ],
              onChanged: _onTypeChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<AccountClassification>(
              initialValue: _classification,
              decoration: InputDecoration(labelText: l.accountsClassification),
              items: [
                for (final c in AccountClassification.values)
                  DropdownMenuItem(value: c, child: Text(c.label(l))),
              ],
              // Only `other` allows a manual classification choice.
              onChanged: _type.classificationIsUserSelectable
                  ? (c) =>
                        setState(() => _classification = c ?? _classification)
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _openingController,
              decoration: InputDecoration(
                labelText: isLiability
                    ? '${l.accountsOwedAmount} (${l.commonOptional})'
                    : '${l.accountsOpeningBalance} (${l.commonOptional})',
                suffixText: currency,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                return Money.tryParse(v, currencyCode: currency) == null
                    ? l.errorInvalidAmount
                    : null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _institutionController,
              decoration: InputDecoration(labelText: l.accountsInstitution),
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
