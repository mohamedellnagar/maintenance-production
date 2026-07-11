import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/account_balance.dart';
import '../../domain/account_type.dart';

/// Renders an [AccountBalance] using its domain-computed *display* value
/// (liabilities show their outstanding debt as a positive figure). All sign
/// conversion happens in the domain; this widget only picks a color.
class AccountBalanceText extends StatelessWidget {
  const AccountBalanceText(this.balance, {super.key, this.style});

  final AccountBalance balance;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final brightness = Theme.of(context).brightness;
    final text = balance.display.format(locale: locale);

    Color? color;
    if (balance.classification == AccountClassification.liability) {
      // Outstanding debt is shown in the "negative" tone; a cleared liability
      // stays neutral.
      color = balance.displayBalanceMinor > 0
          ? AppColors.negative(brightness)
          : null;
    } else if (balance.signedBalanceMinor < 0) {
      // Overdrawn asset.
      color = AppColors.negative(brightness);
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
