import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/money/money.dart';

void main() {
  const aed = 'AED';

  group('Money arithmetic', () {
    test('addition sums minor units', () {
      final a = Money(amountMinor: 10050, currencyCode: aed);
      final b = Money(amountMinor: 2500, currencyCode: aed);
      expect((a + b).amountMinor, 12550);
    });

    test('subtraction can go negative', () {
      final a = Money(amountMinor: 1000, currencyCode: aed);
      final b = Money(amountMinor: 2500, currencyCode: aed);
      final result = a - b;
      expect(result.amountMinor, -1500);
      expect(result.isNegative, isTrue);
    });

    test('unary minus negates', () {
      final a = Money(amountMinor: 500, currencyCode: aed);
      expect((-a).amountMinor, -500);
    });

    test('abs returns magnitude', () {
      final a = Money(amountMinor: -750, currencyCode: aed);
      expect(a.abs.amountMinor, 750);
    });
  });

  group('Money comparison', () {
    test('comparison operators work', () {
      final a = Money(amountMinor: 100, currencyCode: aed);
      final b = Money(amountMinor: 200, currencyCode: aed);
      expect(a < b, isTrue);
      expect(b > a, isTrue);
      expect(a <= Money(amountMinor: 100, currencyCode: aed), isTrue);
      expect(a >= Money(amountMinor: 100, currencyCode: aed), isTrue);
    });

    test('equality by value', () {
      expect(
        Money(amountMinor: 100, currencyCode: aed),
        Money(amountMinor: 100, currencyCode: aed),
      );
    });
  });

  group('Currency mismatch', () {
    test('addition across currencies throws', () {
      final a = Money(amountMinor: 100, currencyCode: 'AED');
      final b = Money(amountMinor: 100, currencyCode: 'USD');
      expect(() => a + b, throwsA(isA<CurrencyMismatchException>()));
    });

    test('comparison across currencies throws', () {
      final a = Money(amountMinor: 100, currencyCode: 'AED');
      final b = Money(amountMinor: 100, currencyCode: 'USD');
      expect(() => a.compareTo(b), throwsA(isA<CurrencyMismatchException>()));
    });
  });

  group('Money.parse', () {
    test('parses plain decimal to minor units', () {
      expect(Money.parse('100.50', currencyCode: aed).amountMinor, 10050);
    });

    test('parses integer with no fraction', () {
      expect(Money.parse('1234', currencyCode: aed).amountMinor, 123400);
    });

    test('ignores thousands separators', () {
      expect(Money.parse('1,234.50', currencyCode: aed).amountMinor, 123450);
    });

    test('parses negative values', () {
      expect(Money.parse('-50.25', currencyCode: aed).amountMinor, -5025);
    });

    test('parses Arabic-Indic digits', () {
      expect(Money.parse('١٠٠٫٥٠', currencyCode: aed).amountMinor, 10050);
    });

    test('rejects too many fractional digits', () {
      expect(
        () => Money.parse('1.234', currencyCode: aed),
        throwsA(isA<MoneyParseException>()),
      );
    });

    test('rejects empty and garbage input', () {
      expect(
        () => Money.parse('', currencyCode: aed),
        throwsA(isA<MoneyParseException>()),
      );
      expect(
        () => Money.parse('abc', currencyCode: aed),
        throwsA(isA<MoneyParseException>()),
      );
    });

    test('tryParse returns null instead of throwing', () {
      expect(Money.tryParse('nope', currencyCode: aed), isNull);
      expect(Money.tryParse('9.99', currencyCode: aed)?.amountMinor, 999);
    });
  });

  group('Money.format', () {
    test('formats with grouping and currency symbol', () {
      final money = Money(amountMinor: 123450, currencyCode: aed);
      final text = money.format(locale: 'en');
      expect(text, contains('1,234.50'));
    });
  });
}
