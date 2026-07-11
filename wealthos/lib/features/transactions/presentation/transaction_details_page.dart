import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/enum_labels.dart';
import '../../../core/localization/failure_l10n.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/money/money.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/money_text.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account.dart';
import '../../categories/application/categories_providers.dart';
import '../application/transactions_providers.dart';
import '../domain/transaction.dart';
import '../domain/transaction_effect.dart';
import '../domain/transaction_semantic.dart';
import '../domain/transaction_type.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final txAsync = ref.watch(transactionByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: Text(l.transactionDetailsTitle)),
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorUnexpected)),
        data: (tx) {
          if (tx == null) {
            return Center(child: Text(l.errorTransactionNotFound));
          }
          return _DetailsBody(transaction: tx);
        },
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.transaction});
  final Transaction transaction;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.transactionDelete),
        content: Text(l.transactionDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final repo = ref.read(transactionsRepositoryProvider);
    final result = await repo.softDelete(transaction.id);
    result.fold(
      (_) => messenger.showSnackBar(
        SnackBar(
          content: Text(l.transactionDeleted),
          action: SnackBarAction(
            label: l.commonUndo,
            onPressed: () => repo.restore(transaction.id),
          ),
        ),
      ),
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(transactionsRepositoryProvider)
        .restore(transaction.id);
    result.fold(
      (_) => messenger.showSnackBar(
        SnackBar(content: Text(l.transactionRestored)),
      ),
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l.messageFor(failure))),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final accounts = ref.watch(allAccountsProvider).value ?? const [];
    final byId = {for (final a in accounts) a.id: a};

    final source = _lookup(byId, transaction.accountId);
    final destination = _lookup(byId, transaction.destinationAccountId);
    final semantic = TransactionSemanticClassifier.classify(
      type: transaction.type,
      sourceClassification: source?.classification,
      destinationClassification: destination?.classification,
    );

    final dateFmt = DateFormat.yMMMd(locale).add_jm();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        semantic.label(l),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Chip(
                      label: Text(
                        transaction.isDeleted
                            ? l.transactionStatusDeleted
                            : l.transactionStatusActive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                MoneyText(
                  transaction.amount.abs,
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _InfoRow(label: l.transactionAccount, value: source?.name ?? '—'),
        if (transaction.type == TransactionType.transfer)
          _InfoRow(
            label: l.transactionToAccount,
            value: destination?.name ?? '—',
          ),
        if (transaction.type.isCashFlow && transaction.categoryId != null)
          _CategoryRow(categoryId: transaction.categoryId!),
        _InfoRow(
          label: l.commonDate,
          value: DateFormat.yMMMd(locale).format(transaction.date),
        ),
        if (transaction.note != null && transaction.note!.isNotEmpty)
          _InfoRow(label: l.commonNote, value: transaction.note!),
        if (transaction.adjustmentReason != null)
          _InfoRow(
            label: l.transactionAdjustmentReason,
            value: transaction.adjustmentReason!,
          ),
        _InfoRow(
          label: l.transactionCreatedAt,
          value: dateFmt.format(transaction.createdAt),
        ),
        _InfoRow(
          label: l.transactionUpdatedAt,
          value: dateFmt.format(transaction.updatedAt),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l.transactionEffect, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ..._effectRows(context, byId),
        const SizedBox(height: AppSpacing.xl),
        if (transaction.isDeleted)
          FilledButton.icon(
            onPressed: () => _restore(context, ref),
            icon: const Icon(Icons.restore),
            label: Text(l.transactionRestore),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    AppRoutes.editTransactionPath(transaction.id),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l.commonEdit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _delete(context, ref),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l.commonDelete),
                ),
              ),
            ],
          ),
      ],
    );
  }

  List<Widget> _effectRows(BuildContext context, Map<String, Account> byId) {
    final rows = <Widget>[];
    void addFor(String? accountId) {
      if (accountId == null) return;
      final account = byId[accountId];
      if (account == null) return;
      final delta = TransactionEffect.deltaFor(transaction, accountId);
      if (delta == 0 && transaction.isDeleted) return;
      rows.add(
        _EffectRow(
          accountName: account.name,
          delta: Money(
            amountMinor: delta,
            currencyCode: transaction.currencyCode,
          ),
        ),
      );
    }

    addFor(transaction.accountId);
    if (transaction.type == TransactionType.transfer) {
      addFor(transaction.destinationAccountId);
    }
    if (rows.isEmpty) {
      rows.add(_InfoRow(label: '', value: '—'));
    }
    return rows;
  }

  Account? _lookup(Map<String, Account> byId, String? id) =>
      id == null ? null : byId[id];
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow({required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final category = ref.watch(categoryByIdProvider(categoryId)).value;
    return _InfoRow(
      label: l.transactionCategory,
      value: category?.localizedName(language) ?? '—',
    );
  }
}

class _EffectRow extends StatelessWidget {
  const _EffectRow({required this.accountName, required this.delta});
  final String accountName;
  final Money delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(accountName, style: theme.textTheme.bodyLarge)),
          MoneyText(
            delta,
            colorBySign: true,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
