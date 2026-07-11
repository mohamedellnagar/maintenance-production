import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/money/currency.dart';
import '../domain/app_settings.dart';

/// Reads and writes the single-row [AppSettings]. The row is created lazily
/// with sensible defaults the first time it is read.
class SettingsRepository {
  SettingsRepository(this._db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  static const int _rowId = 1;

  Future<AppSettings> getOrCreate() async {
    final existing = await _row();
    if (existing != null) return _toDomain(existing);
    final now = _now();
    await _db
        .into(_db.appSettingsTable)
        .insert(
          AppSettingsTableCompanion.insert(
            id: const Value(_rowId),
            baseCurrency: Currencies.defaultCurrency.code,
            languageCode: 'ar',
            themeMode: const Value('system'),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    final created = await _row();
    return _toDomain(created!);
  }

  Stream<AppSettings?> watch() =>
      (_db.select(_db.appSettingsTable)..where((t) => t.id.equals(_rowId)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _toDomain(row));

  Future<void> update({
    String? baseCurrency,
    String? languageCode,
    AppThemeMode? themeMode,
    bool? biometricEnabled,
    bool? onboardingCompleted,
  }) async {
    await getOrCreate();
    await (_db.update(
      _db.appSettingsTable,
    )..where((t) => t.id.equals(_rowId))).write(
      AppSettingsTableCompanion(
        baseCurrency: baseCurrency == null
            ? const Value.absent()
            : Value(baseCurrency),
        languageCode: languageCode == null
            ? const Value.absent()
            : Value(languageCode),
        themeMode: themeMode == null
            ? const Value.absent()
            : Value(themeMode.name),
        biometricEnabled: biometricEnabled == null
            ? const Value.absent()
            : Value(biometricEnabled),
        onboardingCompleted: onboardingCompleted == null
            ? const Value.absent()
            : Value(onboardingCompleted),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<AppSettingsTableData?> _row() => (_db.select(
    _db.appSettingsTable,
  )..where((t) => t.id.equals(_rowId))).getSingleOrNull();

  AppSettings _toDomain(AppSettingsTableData row) => AppSettings(
    baseCurrency: row.baseCurrency,
    languageCode: row.languageCode,
    themeMode: AppThemeMode.fromName(row.themeMode),
    biometricEnabled: row.biometricEnabled,
    onboardingCompleted: row.onboardingCompleted,
  );
}
