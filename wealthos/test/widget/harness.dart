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
import 'package:wealthos/features/goals/application/goals_providers.dart';
import 'package:wealthos/features/goals/domain/financial_goal.dart';
import 'package:wealthos/features/goals/domain/goal_fund.dart';
import 'package:wealthos/features/recurring/application/recurring_providers.dart';
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
/// so tests exercise UI without touching live Drift streams (which keeps them
/// fast and free of pending-timer flakiness). Real database behaviour is
/// covered by the database tests. Pass data or [withRealDatabase] to customise.
class TestHarness {
  TestHarness() : database = AppDatabase.forTesting(NativeDatabase.memory());

  final AppDatabase database;

  Widget wrap(
    Widget child, {
    Locale locale = const Locale('en'),
    bool withRealDatabase = false,
    List<Account> accounts = const [],
    List<Transaction> transactions = const [],
    List<Category> categories = const [],
    Map<String, Transaction> transactionsById = const {},
    List<FinancialGoal> goals = const [],
    List<GoalFund> goalFunds = const [],
    List<Override> extraOverrides = const [],
    Brightness brightness = Brightness.light,
    double textScale = 1.0,
  }) {
    final overrides = <Override>[
      appDatabaseProvider.overrideWithValue(database),
      if (!withRealDatabase) ...[
        settingsProvider.overrideWith((ref) => Stream.value(_testSettings)),
        accountsProvider.overrideWith(
          (ref) => Stream.value(accounts.where((a) => !a.isArchived).toList()),
        ),
        allAccountsProvider.overrideWith((ref) => Stream.value(accounts)),
        allTransactionsProvider.overrideWith(
          (ref) => Stream.value(transactions),
        ),
        categoriesByTypeProvider.overrideWith(
          (ref, type) =>
              Stream.value(categories.where((c) => c.type == type).toList()),
        ),
        transactionByIdProvider.overrideWith(
          (ref, id) => Stream.value(transactionsById[id]),
        ),
        // Recurring streams default to empty so pages that embed recurring
        // cards (dashboard, budget) don't touch live Drift streams.
        allRulesProvider.overrideWith((ref) => Stream.value(const [])),
        allOccurrencesProvider.overrideWith((ref) => Stream.value(const [])),
        recurringBootstrapProvider.overrideWith((ref) async {}),
        // Goals streams default to the passed data (empty by default) so pages
        // that embed goals cards don't touch live Drift streams.
        allGoalsProvider.overrideWith((ref) => Stream.value(goals)),
        allFundsProvider.overrideWith((ref) => Stream.value(goalFunds)),
        allGoalEntriesProvider.overrideWith((ref) => Stream.value(const [])),
        goalsIntegrityBootstrapProvider.overrideWith((ref) async => 0),
      ],
      ...extraOverrides,
    ];

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: locale,
        theme: ThemeData(brightness: brightness),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: widget!,
        ),
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
