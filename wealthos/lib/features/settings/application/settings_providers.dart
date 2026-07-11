import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../domain/app_settings.dart';

/// Ensures the settings row exists, then streams it. Emits null only briefly
/// before the row is created.
final settingsProvider = StreamProvider<AppSettings?>((ref) async* {
  final repo = ref.watch(settingsRepositoryProvider);
  await repo.getOrCreate();
  yield* repo.watch();
});

/// Convenience: the resolved settings once loaded, or null while loading.
final currentSettingsProvider = Provider<AppSettings?>(
  (ref) => ref.watch(settingsProvider).value,
);

/// Imperative settings mutations.
final settingsControllerProvider = Provider<SettingsController>(
  (ref) => SettingsController(ref),
);

class SettingsController {
  SettingsController(this._ref);
  final Ref _ref;

  Future<void> setLanguage(String code) =>
      _ref.read(settingsRepositoryProvider).update(languageCode: code);

  Future<void> setBaseCurrency(String code) =>
      _ref.read(settingsRepositoryProvider).update(baseCurrency: code);

  Future<void> setThemeMode(AppThemeMode mode) =>
      _ref.read(settingsRepositoryProvider).update(themeMode: mode);

  Future<void> setBiometricEnabled({required bool enabled}) =>
      _ref.read(settingsRepositoryProvider).update(biometricEnabled: enabled);

  Future<void> setAutoCreateRecurringEnabled({required bool enabled}) => _ref
      .read(settingsRepositoryProvider)
      .update(autoCreateRecurringEnabled: enabled);

  Future<void> completeOnboarding() =>
      _ref.read(settingsRepositoryProvider).update(onboardingCompleted: true);
}
