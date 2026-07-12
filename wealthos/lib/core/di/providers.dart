import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/accounts/data/accounts_repository.dart';
import '../../features/budgets/data/budgets_repository.dart';
import '../../features/categories/data/categories_repository.dart';
import '../../features/goals/data/goals_repository.dart';
import '../../features/recurring/application/recurrence_generation_service.dart';
import '../../features/recurring/data/recurring_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/transactions/data/transactions_repository.dart';
import '../database/app_database.dart';
import '../security/biometric_service.dart';
import '../time/local_date.dart';

/// The single app database instance. Overridden in tests with an in-memory DB.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final accountsRepositoryProvider = Provider<AccountsRepository>(
  (ref) => AccountsRepository(ref.watch(appDatabaseProvider)),
);

final categoriesRepositoryProvider = Provider<CategoriesRepository>(
  (ref) => CategoriesRepository(ref.watch(appDatabaseProvider)),
);

final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => TransactionsRepository(ref.watch(appDatabaseProvider)),
);

final budgetsRepositoryProvider = Provider<BudgetsRepository>(
  (ref) => BudgetsRepository(ref.watch(appDatabaseProvider)),
);

/// Injectable "today" clock (overridden in tests for deterministic dates).
final clockProvider = Provider<Clock>((ref) => systemToday);

final recurringRepositoryProvider = Provider<RecurringRepository>(
  (ref) => RecurringRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(transactionsRepositoryProvider),
  ),
);

final recurrenceGenerationServiceProvider =
    Provider<RecurrenceGenerationService>(
      (ref) => RecurrenceGenerationService(
        repository: ref.watch(recurringRepositoryProvider),
        today: ref.watch(clockProvider),
        autoCreateEnabled: () async =>
            (await ref.read(settingsRepositoryProvider).getOrCreate())
                .autoCreateRecurringEnabled,
      ),
    );

final goalsRepositoryProvider = Provider<GoalsRepository>(
  (ref) => GoalsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(accountsRepositoryProvider),
    ref.watch(transactionsRepositoryProvider),
  ),
);

final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricService(),
);
