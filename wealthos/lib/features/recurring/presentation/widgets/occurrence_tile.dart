import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/enum_labels.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/money_text.dart';
import '../../application/recurring_providers.dart';
import '../../domain/recurring_type.dart';

/// A tappable row for one occurrence, with a textual status chip (never color
/// alone) and a type icon.
class OccurrenceTile extends StatelessWidget {
  const OccurrenceTile({required this.view, super.key});

  final OccurrenceView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateText = DateFormat.yMMMd(
      locale,
    ).format(view.effectiveDueDate.toDateTime());

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      onTap: () =>
          context.push(AppRoutes.occurrenceDetailPath(view.occurrence.id)),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(_iconFor(view.type), size: 20),
      ),
      title: Text(view.rule.name),
      subtitle: Text('${view.type.label(l)} · $dateText'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MoneyText(
            Money(
              amountMinor: view.expectedAmountMinor,
              currencyCode: view.rule.currencyCode,
            ),
            style: theme.textTheme.titleMedium,
          ),
          Text(
            view.status.label(l),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _statusColor(theme),
            ),
          ),
        ],
      ),
    );
  }

  Color? _statusColor(ThemeData theme) => switch (view.status) {
    OccurrenceDisplayStatus.overdue => AppColors.negative(theme.brightness),
    OccurrenceDisplayStatus.paid => AppColors.positive(theme.brightness),
    OccurrenceDisplayStatus.due => theme.colorScheme.primary,
    _ => theme.colorScheme.onSurfaceVariant,
  };

  IconData _iconFor(RecurringType type) => switch (type) {
    RecurringType.income => Icons.south_west,
    RecurringType.expense => Icons.north_east,
    RecurringType.transfer => Icons.swap_horiz,
    RecurringType.liabilityPayment => Icons.credit_card,
  };
}
