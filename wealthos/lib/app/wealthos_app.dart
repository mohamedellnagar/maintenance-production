import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/routing/app_router.dart';
import '../core/security/app_lock_gate.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/domain/app_settings.dart';

/// Root widget: wires routing, theming, localization and the app-lock gate.
class WealthOSApp extends ConsumerWidget {
  const WealthOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final settings = ref.watch(currentSettingsProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode(settings?.themeMode),
      locale: settings == null ? null : Locale(settings.languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) =>
          AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }

  ThemeMode _themeMode(AppThemeMode? mode) => switch (mode) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
