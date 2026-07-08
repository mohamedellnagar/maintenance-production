import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../database/app_database.dart';
import '../models/timeline_event.dart';

/// مستودع أحداث المسار الزمني — يسجّل كل حدث مالي مهم.
class TimelineRepository {
  TimelineRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;

  Future<int> add(TimelineEvent event) async {
    final db = await _db;
    return db.insert('timeline_events', event.toMap());
  }

  Future<void> record({
    required TimelineEventType type,
    required String title,
    String? description,
    double? amount,
    String? currency,
    DateTime? eventDate,
    String? refTable,
    int? refId,
  }) async {
    await add(TimelineEvent(
      type: type,
      title: title,
      description: description,
      amount: amount,
      currency: currency,
      eventDate: eventDate ?? DateTime.now(),
      refTable: refTable,
      refId: refId,
    ));
  }

  Future<List<TimelineEvent>> all({int limit = 500}) async {
    final db = await _db;
    final rows = await db.query('timeline_events',
        orderBy: 'event_date DESC, id DESC', limit: limit);
    return rows.map(TimelineEvent.fromMap).toList();
  }

  Future<void> deleteByRef(String table, int refId) async {
    final db = await _db;
    await db.delete('timeline_events',
        where: 'ref_table = ? AND ref_id = ?', whereArgs: [table, refId]);
  }
}
