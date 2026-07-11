import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/currency.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_spacing.dart';
import '../../accounts/data/accounts_repository.dart';
import '../../accounts/domain/account_type.dart';
import '../../settings/application/settings_providers.dart';

/// Three-step onboarding: language → base currency → first account.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  final _nameController = TextEditingController();
  final _openingController = TextEditingController();

  int _step = 0;
  String _language = 'ar';
  String _currency = Currencies.defaultCurrency.code;
  AccountType _type = AccountType.cash;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _openingController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _finish() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _submitting = true);

    await ref.read(settingsControllerProvider).setLanguage(_language);
    await ref.read(settingsControllerProvider).setBaseCurrency(_currency);

    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final opening = _openingController.text.trim().isEmpty
          ? 0
          : (Money.tryParse(
                  _openingController.text,
                  currencyCode: _currency,
                )?.amountMinor ??
                0);
      final result = await ref
          .read(accountsRepositoryProvider)
          .create(
            NewAccountInput(
              name: name,
              type: _type,
              classification: _type.defaultClassification,
              currencyCode: _currency,
              openingBalanceMinor: opening,
            ),
          );
      if (result.isFailure && mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l.messageFor(result.failureOrNull!))),
        );
      }
    }

    await ref.read(settingsControllerProvider).completeOnboarding();
    // The router redirect takes over once onboardingCompleted flips.
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: _StepIndicator(step: _step),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [_languageStep(l), _currencyStep(l), _accountStep(l)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: _step < 2
                  ? FilledButton(onPressed: _next, child: Text(l.commonNext))
                  : FilledButton(
                      onPressed: _submitting ? null : _finish,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.onboardingFinish),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageStep(AppLocalizations l) => _StepScaffold(
    title: l.onboardingLanguageTitle,
    subtitle: l.onboardingLanguageSubtitle,
    children: [
      _ChoiceTile(
        label: l.languageArabic,
        selected: _language == 'ar',
        onTap: () {
          setState(() => _language = 'ar');
          ref.read(settingsControllerProvider).setLanguage('ar');
        },
      ),
      _ChoiceTile(
        label: l.languageEnglish,
        selected: _language == 'en',
        onTap: () {
          setState(() => _language = 'en');
          ref.read(settingsControllerProvider).setLanguage('en');
        },
      ),
    ],
  );

  Widget _currencyStep(AppLocalizations l) => _StepScaffold(
    title: l.onboardingCurrencyTitle,
    subtitle: l.onboardingCurrencySubtitle,
    children: [
      for (final currency in Currencies.all)
        _ChoiceTile(
          label: '${currency.code} · ${currency.nameEn}',
          selected: _currency == currency.code,
          // Only the default currency is selectable in this phase.
          enabled: currency.code == Currencies.defaultCurrency.code,
          onTap: () => setState(() => _currency = currency.code),
        ),
    ],
  );

  Widget _accountStep(AppLocalizations l) => _StepScaffold(
    title: l.onboardingAccountTitle,
    subtitle: l.onboardingAccountSubtitle,
    children: [
      TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: l.accountsName),
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: AppSpacing.lg),
      DropdownButtonFormField<AccountType>(
        initialValue: _type,
        decoration: InputDecoration(labelText: l.accountsType),
        items: [
          for (final type in AccountType.values)
            DropdownMenuItem(value: type, child: Text(type.label(l))),
        ],
        onChanged: (value) => setState(() => _type = value ?? _type),
      ),
      const SizedBox(height: AppSpacing.lg),
      TextField(
        controller: _openingController,
        decoration: InputDecoration(
          labelText: '${l.accountsOpeningBalance} (${l.commonOptional})',
          suffixText: _currency,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ],
  );
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...children,
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: selected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: enabled ? 1 : 0.4,
                    child: Text(label, style: theme.textTheme.titleMedium),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? AppSpacing.sm : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i <= step
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}
