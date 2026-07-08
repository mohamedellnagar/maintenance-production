import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos_offline/core/utils/date_range.dart';
import 'package:wealthos_offline/services/currency_service.dart';

void main() {
  group('CurrencyService', () {
    test('لا يحوّل العملة الأساسية', () {
      final fx = CurrencyService('AED', {'AED': 1.0, 'USD': 3.67});
      expect(fx.toBase(100, 'AED'), 100);
    });

    test('يحوّل عملة أخرى إلى الأساسية', () {
      final fx = CurrencyService('AED', {'AED': 1.0, 'USD': 3.67});
      expect(fx.toBase(100, 'USD'), closeTo(367, 0.001));
    });

    test('يعيد المبلغ كما هو عند غياب السعر', () {
      final fx = CurrencyService('AED', {'AED': 1.0});
      expect(fx.toBase(100, 'EUR'), 100);
    });
  });

  group('DateRangeUtils', () {
    test('فترة مفتوحة تشمل أي تاريخ بعد البداية', () {
      final start = DateTime(2020, 1);
      expect(DateRangeUtils.contains(DateTime(2024, 6), start, null), isTrue);
      expect(DateRangeUtils.contains(DateTime(2019, 6), start, null), isFalse);
    });

    test('فترة مغلقة تحترم الحدّين', () {
      final start = DateTime(2019, 1);
      final end = DateTime(2022, 12);
      expect(DateRangeUtils.contains(DateTime(2021, 3), start, end), isTrue);
      expect(DateRangeUtils.contains(DateTime(2023, 1), start, end), isFalse);
    });

    test('monthsBetween يحسب الفرق بالأشهر', () {
      expect(DateRangeUtils.monthsBetween(DateTime(2020, 1), DateTime(2021, 1)),
          12);
    });
  });
}
