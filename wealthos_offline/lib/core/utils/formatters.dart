import 'package:intl/intl.dart';

/// دوال تنسيق الأرقام والعملات والنِسب والتواريخ.
class Fmt {
  Fmt._();

  /// تنسيق مبلغ مالي مع رمز العملة، مثال: "12,500 AED".
  static String money(num value, [String currency = '']) {
    final formatted = NumberFormat('#,##0.##', 'en').format(value);
    return currency.isEmpty ? formatted : '$formatted $currency';
  }

  /// تنسيق مختصر للأرقام الكبيرة، مثال: 1.2M / 850K.
  static String compact(num value, [String currency = '']) {
    final f = NumberFormat.compact(locale: 'en').format(value);
    return currency.isEmpty ? f : '$f $currency';
  }

  /// نسبة مئوية، مثال: "23.5%".
  static String percent(num value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  static String date(DateTime d) => DateFormat('yyyy/MM/dd').format(d);

  static String monthYear(DateTime d) => DateFormat('MM/yyyy').format(d);

  static String year(DateTime d) => DateFormat('yyyy').format(d);

  /// تحويل نصّي لتاريخ ISO يُخزَّن في SQLite.
  static String iso(DateTime d) => d.toIso8601String();

  static DateTime? parseIso(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);
}
