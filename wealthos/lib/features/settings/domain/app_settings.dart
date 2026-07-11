enum AppThemeMode {
  system,
  light,
  dark;

  static AppThemeMode fromName(String value) => AppThemeMode.values.firstWhere(
    (e) => e.name == value,
    orElse: () => AppThemeMode.system,
  );
}

/// Immutable snapshot of user-wide settings.
class AppSettings {
  const AppSettings({
    required this.baseCurrency,
    required this.languageCode,
    required this.themeMode,
    required this.biometricEnabled,
    required this.onboardingCompleted,
    this.autoCreateRecurringEnabled = false,
  });

  final String baseCurrency;
  final String languageCode;
  final AppThemeMode themeMode;
  final bool biometricEnabled;
  final bool onboardingCompleted;

  /// Whether opted-in recurring rules may auto-post due occurrences. Off by
  /// default; the user turns it on explicitly in Settings.
  final bool autoCreateRecurringEnabled;

  AppSettings copyWith({
    String? baseCurrency,
    String? languageCode,
    AppThemeMode? themeMode,
    bool? biometricEnabled,
    bool? onboardingCompleted,
    bool? autoCreateRecurringEnabled,
  }) => AppSettings(
    baseCurrency: baseCurrency ?? this.baseCurrency,
    languageCode: languageCode ?? this.languageCode,
    themeMode: themeMode ?? this.themeMode,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    autoCreateRecurringEnabled:
        autoCreateRecurringEnabled ?? this.autoCreateRecurringEnabled,
  );
}
