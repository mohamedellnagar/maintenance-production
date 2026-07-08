import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../database/app_database.dart';
import '../models/contribution.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع المساهمات العائلية (لا تدخل ضمن صافي الثروة).
class ContributionRepository {
  ContributionRepository(this._appDb, this._audit, this._timeline);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;

  Future<Database> get _db => _appDb.database;
  static const _table = 'contributions';

  Future<List<Contribution>> all() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'date DESC, id DESC');
    return rows.map(Contribution.fromMap).toList();
  }

  Future<int> create(Contribution c,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final id = await db.insert(_table, c.toMap());
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: c.toMap(),
      summary: 'مساهمة عائلية: ${c.title}',
    );
    await _timeline.record(
      type: TimelineEventType.contributionMade,
      title: 'مساهمة: ${c.title}',
      amount: c.amount,
      currency: c.currency,
      eventDate: c.date ?? c.createdAt,
      refTable: _table,
      refId: id,
    );
    return id;
  }

  Future<void> update(Contribution c) async {
    final db = await _db;
    await db.update(_table, c.toMap(), where: 'id = ?', whereArgs: [c.id]);
    await _audit.log(
      table: _table,
      recordId: c.id,
      action: AuditAction.update,
      source: AuditSource.manual,
      newValue: c.toMap(),
      summary: 'تحديث مساهمة: ${c.title}',
    );
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
      summary: 'حذف مساهمة #$id',
    );
  }
}
