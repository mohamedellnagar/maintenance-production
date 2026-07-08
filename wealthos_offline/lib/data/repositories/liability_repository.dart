import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../../core/security/encryption_service.dart';
import '../database/app_database.dart';
import '../models/liability.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع الالتزامات — CRUD + سجل دفعات + تدقيق + مسار زمني.
class LiabilityRepository {
  LiabilityRepository(this._appDb, this._audit, this._timeline, this._enc);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;
  final EncryptionService _enc;

  Future<Database> get _db => _appDb.database;
  static const _table = 'liabilities';

  Liability _decrypt(Liability l) => l.copyWith(notes: _enc.decryptText(l.notes));

  /// يُزيل الحقول الحساسة قبل تسجيلها في سجل التدقيق.
  Map<String, dynamic> _redact(Map<String, dynamic> m) =>
      {...m}..remove('notes');

  Future<List<Liability>> all() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'created_at DESC');
    return rows.map(Liability.fromMap).map(_decrypt).toList();
  }

  Future<List<Liability>> active() async {
    final db = await _db;
    final rows = await db.query(_table,
        where: "status = 'active'", orderBy: 'due_date ASC');
    return rows.map(Liability.fromMap).map(_decrypt).toList();
  }

  Future<Liability?> byId(int id) async {
    final db = await _db;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _decrypt(Liability.fromMap(rows.first));
  }

  Future<int> create(Liability l, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final toStore = l.copyWith(notes: _enc.encryptText(l.notes));
    final id = await db.insert(_table, toStore.toMap());
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: _redact(l.toMap()),
      summary: 'إضافة التزام: ${l.name}',
    );
    await _timeline.record(
      type: TimelineEventType.liabilityAdded,
      title: 'التزام جديد: ${l.name}',
      amount: l.remainingAmount,
      currency: l.currency,
      eventDate: l.startDate ?? l.createdAt,
      refTable: _table,
      refId: id,
    );
    return id;
  }

  Future<void> update(Liability l, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final old = await byId(l.id!);
    final toStore = l.copyWith(notes: _enc.encryptText(l.notes));
    await db.update(_table, toStore.toMap(), where: 'id = ?', whereArgs: [l.id]);
    await _audit.log(
      table: _table,
      recordId: l.id,
      action: AuditAction.update,
      source: source,
      oldValue: old == null ? null : _redact(old.toMap()),
      newValue: _redact(l.toMap()),
      summary: 'تحديث التزام: ${l.name}',
    );
  }

  Future<void> delete(int id, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final l = await byId(id);
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    await _timeline.deleteByRef(_table, id);
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.delete,
      source: source,
      oldValue: l == null ? null : _redact(l.toMap()),
      summary: 'حذف التزام: ${l?.name ?? id}',
    );
  }

  /// تسجيل دفعة سداد: يخفّض المتبقي، ويعلّم الالتزام مسدّدًا إذا وصل صفرًا.
  Future<void> addPayment(int liabilityId, double amount,
      {DateTime? date, String? note, AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final l = await byId(liabilityId);
    if (l == null) return;
    await db.insert('liability_payments', LiabilityPayment(
      liabilityId: liabilityId,
      amount: amount,
      paymentDate: date ?? DateTime.now(),
      note: note,
    ).toMap());
    final newRemaining = (l.remainingAmount - amount).clamp(0, double.infinity).toDouble();
    final newStatus =
        newRemaining <= 0 ? LiabilityStatus.paidOff : l.status;
    await db.update(
      _table,
      {'remaining_amount': newRemaining, 'status': newStatus.name},
      where: 'id = ?',
      whereArgs: [liabilityId],
    );
    await _audit.log(
      table: _table,
      recordId: liabilityId,
      action: AuditAction.update,
      source: source,
      summary: 'سداد دفعة $amount على ${l.name}',
    );
    await _timeline.record(
      type: TimelineEventType.paymentMade,
      title: 'سداد دفعة على ${l.name}',
      amount: amount,
      currency: l.currency,
      eventDate: date ?? DateTime.now(),
      refTable: _table,
      refId: liabilityId,
    );
  }

  Future<List<LiabilityPayment>> payments(int liabilityId) async {
    final db = await _db;
    final rows = await db.query('liability_payments',
        where: 'liability_id = ?', whereArgs: [liabilityId], orderBy: 'payment_date DESC');
    return rows.map(LiabilityPayment.fromMap).toList();
  }
}
