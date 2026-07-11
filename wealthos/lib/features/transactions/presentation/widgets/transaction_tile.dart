import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/enum_labels.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../domain/transaction.dart';
import '../../domain/transaction_type.dart';

/// Compact list row for a single transaction. Colors income/expense by sign;
/// transfers and adjustments are shown neutrally (not cash flow).
class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateText = DateFormat.yMMMd(locale).format(transaction.date);

    final isCashFlow = transaction.type.isCashFlow;
    final signedMoney = _signedMoney();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(_iconFor(transaction.type), size: 20),
      ),
      title: Text(transaction.type.label(l)),
      subtitle: Text(
        transaction.note?.isNotEmpty ?? false
            ? '${transaction.note} · $dateText'
            : dateText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: MoneyText(
        signedMoney,
        colorBySign: isCashFlow,
        style: theme.textTheme.titleMedium,
      ),
    );
  }

  Money _signedMoney() {
    final base = transaction.amount;
    return switch (transaction.type) {
      TransactionType.expense => -base,
      TransactionType.income => base,
      // Transfer/adjustment shown as-is (neutral color).
      TransactionType.transfer => base,
      TransactionType.adjustment => base,
    };
  }

  IconData _iconFor(TransactionType type) => switch (type) {
    TransactionType.income => Icons.south_west,
    TransactionType.expense => Icons.north_east,
    TransactionType.transfer => Icons.swap_horiz,
    TransactionType.adjustment => Icons.tune,
  };
}
