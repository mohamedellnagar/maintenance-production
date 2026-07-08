import 'package:flutter/material.dart';

/// لوحة الألوان الأساسية للتطبيق.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0E7C66); // أخضر مالي راقٍ
  static const Color primaryDark = Color(0xFF0A5A4A);
  static const Color accent = Color(0xFFD4A017); // ذهبي
  static const Color background = Color(0xFFF5F7F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A2327);
  static const Color textSecondary = Color(0xFF6B7A80);

  static const Color positive = Color(0xFF1E8E3E); // أخضر (أصول/دخل)
  static const Color negative = Color(0xFFC5221F); // أحمر (التزامات/مصروف)
  static const Color neutral = Color(0xFF3B7DD8);

  /// ألوان مخطط توزيع الأصول.
  static const List<Color> chartPalette = [
    Color(0xFF0E7C66),
    Color(0xFFD4A017),
    Color(0xFF3B7DD8),
    Color(0xFF8E44AD),
    Color(0xFFE67E22),
    Color(0xFF16A085),
    Color(0xFFC0392B),
    Color(0xFF2C3E50),
    Color(0xFF7F8C8D),
    Color(0xFF27AE60),
  ];

  static Color colorForIndex(int i) => chartPalette[i % chartPalette.length];
}
