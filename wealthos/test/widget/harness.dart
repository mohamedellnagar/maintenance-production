import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/database/app_database.dart';
import 'package:wealthos/core/di/providers.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/accounts/application/accounts_providers.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/categories/application/categories_providers.dart';
import 'package:wealthos/features/categories/domain/category.dart';
import 'package:wealthos/features/settings/application/settings_providers.dart';
import 'package:wealthos/features/settings/domain/app_settings.dart';
import 'package:wealthos/features/transactions/application/transactions_providers.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';

const _testSettings = AppSettings(
  baseCurrency: 'AED',
  languageCode: 'en',
  themeMode: AppThemeMode.system,
  biometricEnabled: false,
  onboardingCompleted: true,
);

/// Builds a [ProviderScope] + [MaterialApp] around [child] for widget tests.
///
/// By default the data providers are overridden with fixed, synchronous values
/// (empty accounts/transactions/categories, ready settings) so tests exercise
/// UI behaviour without touching live Drift streams — which keeps them fast and
/// free of pending-timer flakiness. Real database behaviour is covered by the
/// database tests. Pass [withRealDatabase] to use an in-memory DB instead (for
/// flows like onboarding that write settings).
class TestHarness {
  TestHarness() : database = AppDatabase.forTesting(NativeDatabase.memory());

  final AppDatabase database;

  Widget wrap(
    Widget child, {
    Locale locale = const Locale('en'),
    bool withRealDatabase = false,
    List<Override> overrides = const [],
  }) {
    final baseOverrides = <Override>[
      appDatabaseProvider.overrideWithValue(database),
      if (!withRealDatabase) ...[
        settingsProvider.overrideWith((ref) => Stream.value(_testSettings)),
        accountsProvider.overrideWith((ref) => Stream.value(const <Account>[])),
        allAccountsProvider.overrideWith(
          (ref) => Stream.value(const <Account>[]),
        ),
        allTransactionsProvider.overrideWith(
          (ref) => Stream.value(const <Transaction>[]),
        ),
        categoriesByTypeProvider.overrideWith(
          (ref, type) => Stream.value(const <Category>[]),
        ),
      ],
    ];

    return ProviderScope(
      overrides: [...baseOverrides, ...overrides],
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }

  Future<void> dispose() => database.close();
}

/// Pumps a bounded number of frames to let overridden providers emit their
/// first value. Deliberately avoids [WidgetTester.pumpAndSettle], which never
/// returns while an indeterminate progress spinner is on screen.
Future<void> pumpUntilStable(
  WidgetTester tester, {
  int frames = 6,
  Duration step = const Duration(milliseconds: 40),
}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(step);
  }
}
