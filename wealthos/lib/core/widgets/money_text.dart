import 'package:flutter/material.dart';

import '../money/money.dart';
import '../theme/app_colors.dart';

/// Renders a [Money] amount with optional semantic coloring.
///
/// Color is never the only cue: when [colorBySign] is on, a leading + / −
/// icon accompanies the hue so the meaning is clear without color perception.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.money, {
    super.key,
    this.style,
    this.colorBySign = false,
    this.showSignIcon = false,
  });

  final Money money;
  final TextStyle? style;

  /// Tint positive amounts green and negative amounts red.
  final bool colorBySign;

  /// Prefix a directional arrow icon when [colorBySign] is enabled.
  final bool showSignIcon;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final brightness = Theme.of(context).brightness;
    final text = money.abs.format(locale: locale);

    Color? color;
    IconData? icon;
    if (colorBySign && !money.isZero) {
      final positive = money.isPositive;
      color = positive
          ? AppColors.positive(brightness)
          : AppColors.negative(brightness);
      icon = positive ? Icons.arrow_upward : Icons.arrow_downward;
    }

    final resolvedStyle = (style ?? const TextStyle()).copyWith(color: color);
    final display = colorBySign && money.isNegative ? '- $text' : text;

    if (showSignIcon && icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 2),
          Text(display, style: resolvedStyle),
        ],
      );
    }
    return Text(display, style: resolvedStyle);
  }
}
