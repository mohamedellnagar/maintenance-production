import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/widgets/money_text.dart';
import '../../domain/goal_fund_entry.dart';
import '../../domain/goal_type.dart';

/// One row in a goal's fund ledger: type, signed amount, date, note, and its
/// soft-delete state. The sign communicates direction (not color alone).
class GoalFundEntryTile extends StatelessWidget {
  const GoalFundEntryTile({
    required this.entry,
    required this.currencyCode,
    this.trailing,
    super.key,
  });

  final GoalFundEntry entry;
  final String currencyCode;
  final Widget? trailing;

  String _typeLabel(AppLocalizations l) => switch (entry.type) {
    GoalFundEntryType.contribution => l.goalContribution,
    GoalFundEntryType.withdrawal => l.goalWithdraw,
    GoalFundEntryType.transferIn => '${l.goalTransfer} ←',
    GoalFundEntryType.transferOut => '${l.goalTransfer} →',
    GoalFundEntryType.adjustment => l.transactionTypeAdjustment,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    // Positive when it adds to the fund; negative when it removes.
    final signed = entry.signedEffectMinor == 0 && entry.isDeleted
        ? (entry.type.increasesByType ? entry.amountMinor : -entry.amountMinor)
        : entry.signedEffectMinor;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        _typeLabel(l),
        style: entry.isDeleted
            ? theme.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : null,
      ),
      subtitle: Text(
        [
          DateFormat.yMMMd(locale).format(entry.entryDate.toDateTime()),
          if (entry.note != null && entry.note!.isNotEmpty) entry.note!,
          if (entry.isDeleted) l.goalEntryDeleted,
        ].join(' · '),
      ),
      trailing:
          trailing ??
          MoneyText(
            Money(amountMinor: signed, currencyCode: currencyCode),
            colorBySign: true,
          ),
    );
  }
}
