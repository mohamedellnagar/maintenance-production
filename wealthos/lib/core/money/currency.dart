/// Metadata for a supported currency.
///
/// The first release ships a single base currency (AED). The type is kept
/// deliberately small but is the extension point for multi-currency support
/// in a later phase.
class CurrencyInfo {
  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.decimalDigits,
    required this.nameEn,
    required this.nameAr,
  });

  /// ISO-4217 code, e.g. `AED`.
  final String code;

  /// Display symbol, e.g. `د.إ`.
  final String symbol;

  /// Number of minor-unit digits (2 => amounts stored in fils/cents).
  final int decimalDigits;

  final String nameEn;
  final String nameAr;

  /// 10^decimalDigits — the number of minor units in one major unit.
  int get minorUnitsPerMajor {
    var factor = 1;
    for (var i = 0; i < decimalDigits; i++) {
      factor *= 10;
    }
    return factor;
  }
}

/// Registry of currencies the app knows about.
///
/// Only [aed] is selectable in the current phase; the others exist so the
/// formatter and parser already behave correctly once selection is unlocked.
class Currencies {
  const Currencies._();

  static const CurrencyInfo aed = CurrencyInfo(
    code: 'AED',
    symbol: 'د.إ',
    decimalDigits: 2,
    nameEn: 'UAE Dirham',
    nameAr: 'درهم إماراتي',
  );

  static const CurrencyInfo usd = CurrencyInfo(
    code: 'USD',
    symbol: r'$',
    decimalDigits: 2,
    nameEn: 'US Dollar',
    nameAr: 'دولار أمريكي',
  );

  static const CurrencyInfo sar = CurrencyInfo(
    code: 'SAR',
    symbol: 'ر.س',
    decimalDigits: 2,
    nameEn: 'Saudi Riyal',
    nameAr: 'ريال سعودي',
  );

  static const List<CurrencyInfo> all = <CurrencyInfo>[aed, usd, sar];

  /// The only currency selectable in the current release.
  static const CurrencyInfo defaultCurrency = aed;

  static CurrencyInfo? find(String code) {
    for (final currency in all) {
      if (currency.code == code) return currency;
    }
    return null;
  }

  /// Like [find] but falls back to [defaultCurrency] for unknown codes so the
  /// UI never crashes on legacy or unexpected data.
  static CurrencyInfo byCodeOrDefault(String code) =>
      find(code) ?? defaultCurrency;
}
