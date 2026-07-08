import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../database/app_database.dart';
import '../models/goal.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع الأهداف المالية.
class GoalRepository {
  GoalRepository(this._appDb, this._audit, this._timeline);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;

  Future<Database> get _db => _appDb.database;
  static const _table = 'goals';

  Future<List<Goal>> all() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'created_at DESC');
    return rows.map(Goal.fromMap).toList();
  }

  Future<int> create(Goal g, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final id = await db.insert(_table, g.toMap());
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: g.toMap(),
      summary: 'هدف جديد: ${g.title}',
    );
    await _timeline.record(
      type: TimelineEventType.goalCreated,
      title: 'هدف: ${g.title}',
      amount: g.targetAmount,
      currency: g.currency,
      refTable: _table,
      refId: id,
    );
    return id;
  }

  Future<void> update(Goal g) async {
    final db = await _db;
    final old = await _byId(g.id!);
    await db.update(_table, g.toMap(), where: 'id = ?', whereArgs: [g.id]);
    await _audit.log(
      table: _table,
      recordId: g.id,
      action: AuditAction.update,
      source: AuditSource.manual,
      oldValue: old?.toMap(),
      newValue: g.toMap(),
      summary: 'تحديث هدف: ${g.title}',
    );
    if ((old == null || old.status != GoalStatus.achieved) &&
        g.status == GoalStatus.achieved) {
      await _timeline.record(
        type: TimelineEventType.goalAchieved,
        title: 'تحقّق هدف: ${g.title}',
        amount: g.targetAmount,
        currency: g.currency,
        refTable: _table,
        refId: g.id,
      );
    }
  }

  Future<Goal?> _byId(int id) async {
    final db = await _db;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Goal.fromMap(rows.first);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    await _timeline.deleteByRef(_table, id);
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.delete,
      source: AuditSource.manual,
      summary: 'حذف هدف #$id',
    );
  }
}
