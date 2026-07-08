import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/reminder.dart';

/// مستودع التنبيهات المحلية.
class ReminderRepository {
  ReminderRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;
  static const _table = 'reminders';

  Future<List<Reminder>> all({bool pendingOnly = false}) async {
    final db = await _db;
    final rows = await db.query(
      _table,
      where: pendingOnly ? 'is_done = 0' : null,
      orderBy: 'due_date ASC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<List<Reminder>> upcoming({int days = 30}) async {
    final db = await _db;
    final now = DateTime.now();
    final until = now.add(Duration(days: days));
    final rows = await db.query(
      _table,
      where: 'is_done = 0 AND due_date <= ?',
      whereArgs: [until.toIso8601String()],
      orderBy: 'due_date ASC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<int> create(Reminder r) async {
    final db = await _db;
    return db.insert(_table, r.toMap());
  }

  Future<void> markDone(int id, bool done) async {
    final db = await _db;
    await db.update(_table, {'is_done': done ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
