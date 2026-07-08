import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../../core/security/encryption_service.dart';
import '../database/app_database.dart';
import '../models/asset.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع الأصول — CRUD + سجل تقييمات + تدقيق + مسار زمني + تشفير الملاحظات.
class AssetRepository {
  AssetRepository(this._appDb, this._audit, this._timeline, this._enc);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;
  final EncryptionService _enc;

  Future<Database> get _db => _appDb.database;
  static const _table = 'assets';

  Asset _decrypt(Asset a) => a.copyWith(notes: _enc.decryptText(a.notes));

  Future<List<Asset>> all({bool activeOnly = true}) async {
    final db = await _db;
    final rows = await db.query(
      _table,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'created_at DESC',
    );
    return rows.map(Asset.fromMap).map(_decrypt).toList();
  }

  Future<Asset?> byId(int id) async {
    final db = await _db;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _decrypt(Asset.fromMap(rows.first));
  }

  Future<int> create(Asset asset, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final toStore = asset.copyWith(notes: _enc.encryptText(asset.notes));
    final id = await db.insert(_table, toStore.toMap());
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: asset.toMap(),
      summary: 'إضافة أصل: ${asset.name}',
    );
    await _timeline.record(
      type: TimelineEventType.assetPurchased,
      title: 'شراء ${asset.type.label}: ${asset.name}',
      amount: asset.currentValue,
      currency: asset.currency,
      eventDate: asset.purchaseDate ?? asset.createdAt,
      refTable: _table,
      refId: id,
    );
    return id;
  }

  Future<void> update(Asset asset, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final old = await byId(asset.id!);
    final toStore = asset.copyWith(notes: _enc.encryptText(asset.notes));
    await db.update(_table, toStore.toMap(), where: 'id = ?', whereArgs: [asset.id]);
    await _audit.log(
      table: _table,
      recordId: asset.id,
      action: AuditAction.update,
      source: source,
      oldValue: old?.toMap(),
      newValue: asset.toMap(),
      summary: 'تحديث أصل: ${asset.name}',
    );
    // إذا تغيّرت القيمة الحالية سجّل حدث تحديث تقييم.
    if (old != null && old.currentValue != asset.currentValue) {
      await addValuation(asset.id!, asset.currentValue,
          date: asset.lastValuationDate ?? DateTime.now());
      await _timeline.record(
        type: TimelineEventType.assetValueUpdated,
        title: 'تحديث قيمة ${asset.name}',
        amount: asset.currentValue,
        currency: asset.currency,
        refTable: _table,
        refId: asset.id,
      );
    }
  }

  /// بيع أصل: يُلغى تفعيله ويُسجَّل حدث بيع.
  Future<void> sell(int id, double soldValue,
      {DateTime? date, AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final asset = await byId(id);
    if (asset == null) return;
    await db.update(_table, {'is_active': 0},
        where: 'id = ?', whereArgs: [id]);
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.update,
      source: source,
      oldValue: asset.toMap(),
      summary: 'بيع أصل: ${asset.name} بمبلغ $soldValue',
    );
    await _timeline.record(
      type: TimelineEventType.assetSold,
      title: 'بيع ${asset.name}',
      amount: soldValue,
      currency: asset.currency,
      eventDate: date ?? DateTime.now(),
      refTable: _table,
      refId: id,
    );
  }

  Future<void> delete(int id, {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final asset = await byId(id);
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    await _timeline.deleteByRef(_table, id);
    await _audit.log(
      table: _table,
      recordId: id,
      action: AuditAction.delete,
      source: source,
      oldValue: asset?.toMap(),
      summary: 'حذف أصل: ${asset?.name ?? id}',
    );
  }

  Future<void> addValuation(int assetId, double value, {DateTime? date}) async {
    final db = await _db;
    await db.insert('asset_valuations', AssetValuation(
      assetId: assetId,
      value: value,
      valuationDate: date ?? DateTime.now(),
    ).toMap());
  }

  Future<List<AssetValuation>> valuations(int assetId) async {
    final db = await _db;
    final rows = await db.query('asset_valuations',
        where: 'asset_id = ?', whereArgs: [assetId], orderBy: 'valuation_date ASC');
    return rows.map(AssetValuation.fromMap).toList();
  }
}
