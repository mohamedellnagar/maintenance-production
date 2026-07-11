import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/money_text.dart';
import '../application/accounts_providers.dart';
import '../domain/account.dart';

class AccountsListPage extends ConsumerWidget {
  const AccountsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.accountsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addAccount),
        icon: const Icon(Icons.add),
        label: Text(l.accountsAdd),
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_outlined,
              title: l.accountsEmptyTitle,
              message: l.accountsEmptyMessage,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.addAccount),
                icon: const Icon(Icons.add),
                label: Text(l.accountsAdd),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screen),
            itemCount: accounts.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _AccountCard(account: accounts[i]),
          );
        },
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.account});
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final balance = ref.watch(accountBalanceProvider(account));

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        onTap: () => context.push(AppRoutes.accountDetailPath(account.id)),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            account.isLiability
                ? Icons.credit_card
                : Icons.account_balance_wallet,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(account.name),
        subtitle: Text(account.type.label(l)),
        trailing: balance == null
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : MoneyText(
                balance,
                colorBySign: account.isLiability,
                style: theme.textTheme.titleMedium,
              ),
      ),
    );
  }
}
