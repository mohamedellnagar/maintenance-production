import 'package:flutter/material.dart';

/// Semantic colors for financial meaning. Money direction is always paired with
/// an icon/label as well — color is never the sole signal (accessibility).
///
/// The positive/negative hues are chosen to remain distinguishable for the most
/// common forms of color-vision deficiency (teal-green vs. warm red).
abstract final class AppColors {
  static const Color seed = Color(0xFF1B6C5A);

  static const Color positiveLight = Color(0xFF0F7A52); // gains / income
  static const Color negativeLight = Color(0xFFB3261E); // losses / expense
  static const Color positiveDark = Color(0xFF4ADE9A);
  static const Color negativeDark = Color(0xFFFF8A80);

  /// Positive color for the given brightness.
  static Color positive(Brightness b) =>
      b == Brightness.dark ? positiveDark : positiveLight;

  /// Negative color for the given brightness.
  static Color negative(Brightness b) =>
      b == Brightness.dark ? negativeDark : negativeLight;
}
