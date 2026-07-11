import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/enum_labels.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../accounts/application/accounts_providers.dart';
import '../../../accounts/domain/account_type.dart';
import '../../domain/transaction.dart';
import '../../domain/transaction_semantic.dart';
import '../../domain/transaction_type.dart';

/// Compact, tappable list row for a single transaction. Labels use the
/// human-meaningful [TransactionSemantic] (e.g. "Repayment" for a transfer into
/// a liability). Income/expense are colored by sign; other types are neutral.
class TransactionTile extends ConsumerWidget {
  const TransactionTile({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateText = DateFormat.yMMMd(locale).format(transaction.date);

    final accounts = ref.watch(allAccountsProvider).value ?? const [];
    AccountClassification? classFor(String? id) {
      if (id == null) return null;
      for (final a in accounts) {
        if (a.id == id) return a.classification;
      }
      return null;
    }

    final semantic = TransactionSemanticClassifier.classify(
      type: transaction.type,
      sourceClassification: classFor(transaction.accountId),
      destinationClassification: classFor(transaction.destinationAccountId),
    );

    final isCashFlow = transaction.type.isCashFlow;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      onTap: () =>
          context.push(AppRoutes.transactionDetailPath(transaction.id)),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(_iconFor(transaction.type), size: 20),
      ),
      title: Text(semantic.label(l)),
      subtitle: Text(
        transaction.note?.isNotEmpty ?? false
            ? '${transaction.note} · $dateText'
            : dateText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: MoneyText(
        _signedMoney(),
        colorBySign: isCashFlow,
        style: theme.textTheme.titleMedium,
      ),
    );
  }

  Money _signedMoney() {
    final base = transaction.amount.abs;
    return switch (transaction.type) {
      TransactionType.expense => -base,
      TransactionType.income => base,
      TransactionType.transfer => base,
      TransactionType.adjustment => transaction.amount,
    };
  }

  IconData _iconFor(TransactionType type) => switch (type) {
    TransactionType.income => Icons.south_west,
    TransactionType.expense => Icons.north_east,
    TransactionType.transfer => Icons.swap_horiz,
    TransactionType.adjustment => Icons.tune,
  };
}
