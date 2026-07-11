import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/settings_providers.dart';
import '../domain/app_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(currentSettingsProvider);
    final controller = ref.read(settingsControllerProvider);

    if (settings == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(l.settingsLanguage),
          RadioGroup<String>(
            groupValue: settings.languageCode,
            onChanged: (v) => controller.setLanguage(v ?? 'ar'),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'ar',
                  title: Text(l.languageArabic),
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l.languageEnglish),
                ),
              ],
            ),
          ),
          const Divider(),
          _SectionHeader(l.settingsTheme),
          RadioGroup<AppThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (v) => controller.setThemeMode(v ?? AppThemeMode.system),
            child: Column(
              children: [
                RadioListTile<AppThemeMode>(
                  value: AppThemeMode.system,
                  title: Text(l.settingsThemeSystem),
                ),
                RadioListTile<AppThemeMode>(
                  value: AppThemeMode.light,
                  title: Text(l.settingsThemeLight),
                ),
                RadioListTile<AppThemeMode>(
                  value: AppThemeMode.dark,
                  title: Text(l.settingsThemeDark),
                ),
              ],
            ),
          ),
          const Divider(),
          _SectionHeader(l.settingsSecurity),
          SwitchListTile(
            value: settings.biometricEnabled,
            title: Text(l.settingsBiometricLock),
            subtitle: Text(l.settingsBiometricSubtitle),
            onChanged: (v) => _onBiometricChanged(ref, enabled: v),
          ),
          const Divider(),
          _SectionHeader(l.settingsAbout),
          ListTile(
            title: Text(l.settingsCurrency),
            trailing: Text(settings.baseCurrency),
          ),
          ListTile(
            title: Text(l.settingsVersion),
            trailing: const Text('1.0.0'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _onBiometricChanged(
    WidgetRef ref, {
    required bool enabled,
  }) async {
    // Persist the flag in both the secure store and settings so the lock gate
    // and the UI stay consistent.
    await ref.read(biometricServiceProvider).setEnabled(enabled: enabled);
    await ref
        .read(settingsControllerProvider)
        .setBiometricEnabled(enabled: enabled);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.lg,
        AppSpacing.screen,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
