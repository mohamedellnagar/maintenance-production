import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import 'currency.dart';

/// Thrown when an arithmetic or comparison operation mixes two currencies.
class CurrencyMismatchException implements Exception {
  const CurrencyMismatchException(this.a, this.b);

  final String a;
  final String b;

  @override
  String toString() =>
      'CurrencyMismatchException: cannot combine "$a" with "$b"';
}

/// Thrown when user-entered text cannot be interpreted as a monetary amount.
class MoneyParseException implements Exception {
  const MoneyParseException(this.input);

  final String input;

  @override
  String toString() => 'MoneyParseException: "$input" is not a valid amount';
}

/// Immutable monetary value stored as an integer number of *minor units*
/// (e.g. fils/cents) together with its currency.
///
/// Money is never represented with [double]; all arithmetic is exact integer
/// arithmetic. Parsing from user text goes through [Decimal] to avoid binary
/// floating-point rounding before the value is quantised to minor units.
class Money implements Comparable<Money> {
  const Money({required this.amountMinor, required this.currencyCode});

  /// A zero value in the given currency.
  const Money.zero(this.currencyCode) : amountMinor = 0;

  /// Amount expressed in the currency's smallest unit. May be negative
  /// (e.g. a liability balance or an overdrawn account).
  final int amountMinor;

  /// ISO-4217 code this amount is denominated in.
  final String currencyCode;

  CurrencyInfo get _currency => Currencies.byCodeOrDefault(currencyCode);

  bool get isZero => amountMinor == 0;
  bool get isNegative => amountMinor < 0;
  bool get isPositive => amountMinor > 0;

  /// The absolute value, preserving the currency.
  Money get abs =>
      Money(amountMinor: amountMinor.abs(), currencyCode: currencyCode);

  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money(
      amountMinor: amountMinor + other.amountMinor,
      currencyCode: currencyCode,
    );
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money(
      amountMinor: amountMinor - other.amountMinor,
      currencyCode: currencyCode,
    );
  }

  Money operator -() =>
      Money(amountMinor: -amountMinor, currencyCode: currencyCode);

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other);
    return amountMinor.compareTo(other.amountMinor);
  }

  /// The amount as a [Decimal] in major units — for display/formatting only,
  /// never for storage.
  Decimal get major =>
      (Decimal.fromInt(amountMinor) /
              Decimal.fromInt(_currency.minorUnitsPerMajor))
          .toDecimal();

  /// Formats the value for display, e.g. `1,234.50 د.إ`.
  ///
  /// [locale] controls digit grouping and decimal separator. When [symbol]
  /// is false only the number is returned (useful inside compact widgets).
  String format({String? locale, bool symbol = true}) {
    final currency = _currency;
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol ? '${currency.symbol} ' : '',
      decimalDigits: currency.decimalDigits,
    );
    // NumberFormat expects a number; feed it the exact decimal string so no
    // binary floating-point rounding is introduced.
    final text = formatter.format(major.toDouble()).trim();
    return text;
  }

  @override
  String toString() => format();

  void _assertSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw CurrencyMismatchException(currencyCode, other.currencyCode);
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.amountMinor == amountMinor &&
      other.currencyCode == currencyCode;

  @override
  int get hashCode => Object.hash(amountMinor, currencyCode);

  /// Parses free-form user input (e.g. `"1,234.5"`, `"1234"`, `"-50.25"`)
  /// into a [Money] value in [currencyCode].
  ///
  /// Rules:
  /// * surrounding whitespace and thousands separators (`,`) are ignored;
  /// * both `.` and Arabic-Indic digits are accepted;
  /// * the fractional part must not exceed the currency's decimal digits;
  /// * empty/invalid input throws [MoneyParseException].
  ///
  /// The result is exact: the major-unit decimal is multiplied by
  /// 10^decimalDigits using integer-safe [Decimal] arithmetic.
  static Money parse(String input, {required String currencyCode}) {
    final currency = Currencies.byCodeOrDefault(currencyCode);
    final normalized = _normalizeDigits(input).replaceAll(',', '').trim();
    if (normalized.isEmpty || normalized == '-' || normalized == '.') {
      throw MoneyParseException(input);
    }
    final Decimal value;
    try {
      value = Decimal.parse(normalized);
    } on FormatException {
      throw MoneyParseException(input);
    }
    final scaled = value * Decimal.fromInt(currency.minorUnitsPerMajor);
    if (!scaled.isInteger) {
      // More fractional digits than the currency supports.
      throw MoneyParseException(input);
    }
    return Money(
      amountMinor: scaled.toBigInt().toInt(),
      currencyCode: currencyCode,
    );
  }

  /// Like [parse] but returns null instead of throwing.
  static Money? tryParse(String input, {required String currencyCode}) {
    try {
      return parse(input, currencyCode: currencyCode);
    } on MoneyParseException {
      return null;
    }
  }

  /// Maps Arabic-Indic digits to ASCII so the parser accepts both.
  static String _normalizeDigits(String input) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final index = arabicIndic.indexOf(char);
      if (index >= 0) {
        buffer.write(index.toString());
      } else if (char == '٫' || char == '،') {
        // Arabic decimal separator / thousands separator.
        buffer.write(char == '٫' ? '.' : ',');
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }
}
