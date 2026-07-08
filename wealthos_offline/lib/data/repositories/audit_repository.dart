import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../database/app_database.dart';
import '../models/audit_log.dart';

/// مستودع سجل التدقيق — يسجّل كل تعديل (إنشاء/تحديث/حذف) على البيانات.
class AuditRepository {
  AuditRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;

  Future<void> log({
    required String table,
    int? recordId,
    required AuditAction action,
    AuditSource source = AuditSource.manual,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? summary,
  }) async {
    final db = await _db;
    final entry = AuditLog(
      tableName: table,
      recordId: recordId,
      action: action,
      source: source,
      oldValue: oldValue == null ? null : jsonEncode(oldValue),
      newValue: newValue == null ? null : jsonEncode(newValue),
      summary: summary,
    );
    await db.insert('audit_logs', entry.toMap());
  }

  Future<List<AuditLog>> all({int limit = 200}) async {
    final db = await _db;
    final rows = await db.query('audit_logs',
        orderBy: 'created_at DESC, id DESC', limit: limit);
    return rows.map(AuditLog.fromMap).toList();
  }
}
