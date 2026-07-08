import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/security/encryption_service.dart';
import '../data/database/app_database.dart';
import '../data/models/app_meta.dart';
import '../data/models/asset.dart';
import '../data/models/audit_log.dart';
import '../data/models/contribution.dart';
import '../data/models/expense.dart';
import '../data/models/goal.dart';
import '../data/models/income.dart';
import '../data/models/liability.dart';
import '../data/models/reminder.dart';
import '../data/models/timeline_event.dart';
import '../data/repositories/asset_repository.dart';
import '../data/repositories/audit_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/contribution_repository.dart';
import '../data/repositories/currency_repository.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/goal_repository.dart';
import '../data/repositories/income_repository.dart';
import '../data/repositories/liability_repository.dart';
import '../data/repositories/reminder_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/timeline_repository.dart';
import '../services/backup_service.dart';
import '../services/calculation_engine.dart';
import '../services/chat_command_service.dart';
import '../services/notification_service.dart';
import '../services/pin_service.dart';
import '../services/report_service.dart';

// ---- بنية تحتية (تُهيّأ في main عبر overrides) ----

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

/// يُستبدل في main بنسخة مُهيّأة (init()) قبل runApp.
final encryptionServiceProvider = Provider<EncryptionService>(
  (ref) => throw UnimplementedError('encryptionServiceProvider must be overridden'),
);

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase.instance);

/// يُستبدل في main بنسخة مُهيّأة (init()) قبل runApp.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('notificationServiceProvider must be overridden'),
);

/// عدّاد تحديث عام: أي تعديل يزيده فتُعاد جميع القراءات المرتبطة.
final refreshProvider = StateProvider<int>((ref) => 0);

void bumpRefresh(Ref ref) =>
    ref.read(refreshProvider.notifier).update((v) => v + 1);

void bumpRefreshFromWidget(WidgetRef ref) =>
    ref.read(refreshProvider.notifier).update((v) => v + 1);

// ---- مستودعات ----

final auditRepoProvider =
    Provider((ref) => AuditRepository(ref.watch(appDatabaseProvider)));

final timelineRepoProvider =
    Provider((ref) => TimelineRepository(ref.watch(appDatabaseProvider)));

final settingsRepoProvider =
    Provider((ref) => SettingsRepository(ref.watch(appDatabaseProvider)));

final currencyRepoProvider =
    Provider((ref) => CurrencyRepository(ref.watch(appDatabaseProvider)));

final chatRepoProvider =
    Provider((ref) => ChatRepository(ref.watch(appDatabaseProvider)));

final reminderRepoProvider =
    Provider((ref) => ReminderRepository(ref.watch(appDatabaseProvider)));

final assetRepoProvider = Provider((ref) => AssetRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
      ref.watch(encryptionServiceProvider),
    ));

final liabilityRepoProvider = Provider((ref) => LiabilityRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
      ref.watch(encryptionServiceProvider),
    ));

final incomeRepoProvider = Provider((ref) => IncomeRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
    ));

final expenseRepoProvider = Provider((ref) => ExpenseRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
    ));

final contributionRepoProvider = Provider((ref) => ContributionRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
    ));

final goalRepoProvider = Provider((ref) => GoalRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(auditRepoProvider),
      ref.watch(timelineRepoProvider),
    ));

// ---- خدمات ----

final pinServiceProvider =
    Provider((ref) => PinService(ref.watch(secureStorageProvider)));

final reportServiceProvider = Provider((ref) => ReportService());

final backupServiceProvider = Provider((ref) => BackupService(
      ref.watch(appDatabaseProvider),
      ref.watch(encryptionServiceProvider),
    ));

final calculationEngineProvider = Provider((ref) => CalculationEngine(
      assets: ref.watch(assetRepoProvider),
      liabilities: ref.watch(liabilityRepoProvider),
      income: ref.watch(incomeRepoProvider),
      expenses: ref.watch(expenseRepoProvider),
      contributions: ref.watch(contributionRepoProvider),
      currency: ref.watch(currencyRepoProvider),
      settings: ref.watch(settingsRepoProvider),
    ));

final chatCommandServiceProvider = Provider((ref) => ChatCommandService(
      assets: ref.watch(assetRepoProvider),
      liabilities: ref.watch(liabilityRepoProvider),
      income: ref.watch(incomeRepoProvider),
      settings: ref.watch(settingsRepoProvider),
      engine: ref.watch(calculationEngineProvider),
    ));

// ---- قراءات تفاعلية (تُحدَّث مع refreshProvider) ----

final settingsProvider = FutureProvider<AppSettings>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(settingsRepoProvider).get();
});

final financialSummaryProvider = FutureProvider<FinancialSummary>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(calculationEngineProvider).compute();
});

final netWorthTimelineProvider = FutureProvider<List<NetWorthPoint>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(calculationEngineProvider).netWorthTimeline();
});

final assetsProvider = FutureProvider<List<Asset>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(assetRepoProvider).all();
});

final liabilitiesProvider = FutureProvider<List<Liability>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(liabilityRepoProvider).all();
});

final incomeSourcesProvider = FutureProvider<List<IncomeSource>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(incomeRepoProvider).sources();
});

final expenseCategoriesProvider = FutureProvider<List<ExpenseCategory>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(expenseRepoProvider).categories();
});

final contributionsProvider = FutureProvider<List<Contribution>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(contributionRepoProvider).all();
});

final goalsProvider = FutureProvider<List<Goal>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(goalRepoProvider).all();
});

final remindersProvider = FutureProvider<List<Reminder>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(reminderRepoProvider).all();
});

final timelineProvider = FutureProvider<List<TimelineEvent>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(timelineRepoProvider).all();
});

final auditProvider = FutureProvider<List<AuditLog>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(auditRepoProvider).all();
});

final currenciesProvider = FutureProvider<List<Currency>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(currencyRepoProvider).currencies();
});

final ratesProvider = FutureProvider<List<ExchangeRate>>((ref) {
  ref.watch(refreshProvider);
  return ref.watch(currencyRepoProvider).rates();
});
