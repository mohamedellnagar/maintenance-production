/// نماذج الإعدادات والعملات ولقطات التقارير.

/// إعدادات التطبيق العامة وملف المستخدم الأساسي (بدون Login في الـ MVP).
class AppSettings {
  AppSettings({
    this.id = 1,
    this.userName = '',
    this.birthYear,
    this.baseCurrency = 'AED',
    this.analysisStartDate,
    this.onboardingCompleted = false,
    this.pinEnabled = false,
    this.biometricEnabled = false,
    this.autoLockMinutes = 2,
    this.hasFamily = false,
    this.locale = 'ar',
  });

  final int id;
  final String userName;
  final int? birthYear;
  final String baseCurrency;
  final DateTime? analysisStartDate;
  final bool onboardingCompleted;
  final bool pinEnabled;
  final bool biometricEnabled;
  final int autoLockMinutes;
  final bool hasFamily;
  final String locale;

  factory AppSettings.fromMap(Map<String, dynamic> m) => AppSettings(
        id: m['id'] as int? ?? 1,
        userName: m['user_name'] as String? ?? '',
        birthYear: m['birth_year'] as int?,
        baseCurrency: m['base_currency'] as String? ?? 'AED',
        analysisStartDate: m['analysis_start_date'] == null
            ? null
            : DateTime.tryParse(m['analysis_start_date'] as String),
        onboardingCompleted: (m['onboarding_completed'] as int? ?? 0) == 1,
        pinEnabled: (m['pin_enabled'] as int? ?? 0) == 1,
        biometricEnabled: (m['biometric_enabled'] as int? ?? 0) == 1,
        autoLockMinutes: m['auto_lock_minutes'] as int? ?? 2,
        hasFamily: (m['has_family'] as int? ?? 0) == 1,
        locale: m['locale'] as String? ?? 'ar',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_name': userName,
        'birth_year': birthYear,
        'base_currency': baseCurrency,
        'analysis_start_date': analysisStartDate?.toIso8601String(),
        'onboarding_completed': onboardingCompleted ? 1 : 0,
        'pin_enabled': pinEnabled ? 1 : 0,
        'biometric_enabled': biometricEnabled ? 1 : 0,
        'auto_lock_minutes': autoLockMinutes,
        'has_family': hasFamily ? 1 : 0,
        'locale': locale,
      };

  AppSettings copyWith({
    String? userName,
    int? birthYear,
    String? baseCurrency,
    DateTime? analysisStartDate,
    bool? onboardingCompleted,
    bool? pinEnabled,
    bool? biometricEnabled,
    int? autoLockMinutes,
    bool? hasFamily,
    String? locale,
  }) =>
      AppSettings(
        id: id,
        userName: userName ?? this.userName,
        birthYear: birthYear ?? this.birthYear,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        analysisStartDate: analysisStartDate ?? this.analysisStartDate,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        pinEnabled: pinEnabled ?? this.pinEnabled,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
        hasFamily: hasFamily ?? this.hasFamily,
        locale: locale ?? this.locale,
      );
}

/// عملة مدعومة.
class Currency {
  const Currency({required this.code, required this.name, required this.symbol});

  final String code; // AED, EGP, USD...
  final String name;
  final String symbol;

  factory Currency.fromMap(Map<String, dynamic> m) => Currency(
        code: m['code'] as String,
        name: m['name'] as String,
        symbol: m['symbol'] as String? ?? m['code'] as String,
      );

  Map<String, dynamic> toMap() => {'code': code, 'name': name, 'symbol': symbol};

  static const defaults = [
    Currency(code: 'AED', name: 'درهم إماراتي', symbol: 'د.إ'),
    Currency(code: 'EGP', name: 'جنيه مصري', symbol: 'ج.م'),
    Currency(code: 'USD', name: 'دولار أمريكي', symbol: '\$'),
    Currency(code: 'SAR', name: 'ريال سعودي', symbol: 'ر.س'),
  ];
}

/// سعر تحويل عملة إلى العملة الأساسية (يُدخَل يدويًا في الـ MVP).
class ExchangeRate {
  ExchangeRate({
    this.id,
    required this.currencyCode,
    required this.rateToBase,
    required this.updatedAt,
  });

  final int? id;
  final String currencyCode;
  final double rateToBase; // 1 وحدة من العملة = rateToBase من العملة الأساسية
  final DateTime updatedAt;

  factory ExchangeRate.fromMap(Map<String, dynamic> m) => ExchangeRate(
        id: m['id'] as int?,
        currencyCode: m['currency_code'] as String,
        rateToBase: (m['rate_to_base'] as num).toDouble(),
        updatedAt: DateTime.parse(m['updated_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'currency_code': currencyCode,
        'rate_to_base': rateToBase,
        'updated_at': updatedAt.toIso8601String(),
      };
}

/// لقطة محفوظة لتقرير (لعرض السجل التاريخي للتقارير).
class ReportSnapshot {
  ReportSnapshot({
    this.id,
    required this.type,
    required this.payloadJson,
    required this.createdAt,
  });

  final int? id;
  final String type;
  final String payloadJson;
  final DateTime createdAt;

  factory ReportSnapshot.fromMap(Map<String, dynamic> m) => ReportSnapshot(
        id: m['id'] as int?,
        type: m['type'] as String,
        payloadJson: m['payload_json'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type,
        'payload_json': payloadJson,
        'created_at': createdAt.toIso8601String(),
      };
}
