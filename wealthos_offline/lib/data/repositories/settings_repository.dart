import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/app_meta.dart';

/// مستودع إعدادات التطبيق وملف المستخدم الأساسي (صف واحد id=1).
class SettingsRepository {
  SettingsRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;

  Future<AppSettings> get() async {
    final db = await _db;
    final rows = await db.query('app_settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      final fresh = AppSettings();
      await db.insert('app_settings', fresh.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return fresh;
    }
    return AppSettings.fromMap(rows.first);
  }

  Future<void> save(AppSettings settings) async {
    final db = await _db;
    await db.update('app_settings', settings.toMap(), where: 'id = 1');
  }

  Future<void> completeOnboarding() async {
    final current = await get();
    await save(current.copyWith(onboardingCompleted: true));
  }
}
