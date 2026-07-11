import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../application/accounts_providers.dart';
import '../domain/account.dart';
import '../domain/balance_calculator.dart';

class AccountDetailPage extends ConsumerWidget {
  const AccountDetailPage({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final accountAsync = ref.watch(accountByIdProvider(accountId));

    return Scaffold(
      appBar: AppBar(title: Text(accountAsync.value?.name ?? l.accountsTitle)),
      body: accountAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (account) {
          if (account == null) {
            return Center(child: Text(l.errorAccountNotFound));
          }
          return _DetailBody(account: account);
        },
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.account});
  final Account account;

  Future<void> _toggleArchive(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final router = GoRouter.of(context);
    if (!account.isArchived) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.accountsArchive),
          content: Text(l.accountsArchiveWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.accountsArchive),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ref
        .read(accountsRepositoryProvider)
        .setArchived(account.id, archived: !account.isArchived);
    router.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(
      accountTransactionsProvider(account.id),
    );
    final allTransactions = ref.watch(allTransactionsProvider).value;
    final balance = allTransactions == null
        ? null
        : BalanceCalculator.balanceOf(account, allTransactions);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.accountsCurrentBalance,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (balance == null)
                  const CircularProgressIndicator()
                else
                  MoneyText(
                    balance,
                    colorBySign: account.isLiability,
                    style: theme.textTheme.headlineMedium,
                  ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    Chip(label: Text(account.type.label(l))),
                    Chip(label: Text(account.classification.label(l))),
                    if (account.isArchived)
                      Chip(label: Text(l.accountsArchived)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => _toggleArchive(context, ref),
          icon: Icon(
            account.isArchived
                ? Icons.unarchive_outlined
                : Icons.archive_outlined,
          ),
          label: Text(
            account.isArchived ? l.accountsUnarchive : l.accountsArchive,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l.accountsRecentActivity, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        transactionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l.errorUnexpected),
          data: (transactions) {
            if (transactions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(l.dashboardNoTransactions),
              );
            }
            return Column(
              children: [
                for (final tx in transactions) TransactionTile(transaction: tx),
              ],
            );
          },
        ),
      ],
    );
  }
}
