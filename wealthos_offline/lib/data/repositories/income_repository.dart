import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../../core/utils/date_range.dart';
import '../database/app_database.dart';
import '../models/income.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع الدخل — مصادر الدخل + فتراتها التاريخية (Salary History).
class IncomeRepository {
  IncomeRepository(this._appDb, this._audit, this._timeline);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;

  Future<Database> get _db => _appDb.database;

  Future<List<IncomeSource>> sources() async {
    final db = await _db;
    final rows = await db.query('income_sources', orderBy: 'id DESC');
    return rows.map(IncomeSource.fromMap).toList();
  }

  Future<IncomeSource?> sourceById(int id) async {
    final db = await _db;
    final rows =
        await db.query('income_sources', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return IncomeSource.fromMap(rows.first);
  }

  Future<int> createSource(IncomeSource s,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final id = await db.insert('income_sources', s.toMap());
    await _audit.log(
      table: 'income_sources',
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: s.toMap(),
      summary: 'إضافة مصدر دخل: ${s.name}',
    );
    return id;
  }

  Future<void> updateSource(IncomeSource s,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    await db.update('income_sources', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
    await _audit.log(
      table: 'income_sources',
      recordId: s.id,
      action: AuditAction.update,
      source: source,
      newValue: s.toMap(),
      summary: 'تحديث مصدر دخل: ${s.name}',
    );
  }

  Future<void> deleteSource(int id) async {
    final db = await _db;
    await db.delete('income_sources', where: 'id = ?', whereArgs: [id]);
    await _audit.log(
      table: 'income_sources',
      recordId: id,
      action: AuditAction.delete,
      source: AuditSource.manual,
      summary: 'حذف مصدر دخل #$id',
    );
  }

  Future<List<IncomeHistory>> history(int sourceId) async {
    final db = await _db;
    final rows = await db.query('income_history',
        where: 'source_id = ?', whereArgs: [sourceId], orderBy: 'from_date ASC');
    return rows.map(IncomeHistory.fromMap).toList();
  }

  Future<List<IncomeHistory>> allHistory() async {
    final db = await _db;
    final rows = await db.query('income_history', orderBy: 'from_date ASC');
    return rows.map(IncomeHistory.fromMap).toList();
  }

  /// إضافة فترة راتب جديدة، وإغلاق الفترة الحالية المفتوحة تلقائيًا.
  Future<int> addHistory(IncomeHistory h,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    // أغلق الفترة المفتوحة السابقة عند بدء فترة جديدة.
    if (h.isCurrent) {
      final open = await db.query('income_history',
          where: 'source_id = ? AND to_date IS NULL', whereArgs: [h.sourceId]);
      for (final row in open) {
        final existing = IncomeHistory.fromMap(row);
        final closeDate = DateTime(h.fromDate.year, h.fromDate.month, 0);
        if (closeDate.isAfter(existing.fromDate)) {
          await db.update('income_history', {'to_date': closeDate.toIso8601String()},
              where: 'id = ?', whereArgs: [existing.id]);
        }
      }
    }
    final id = await db.insert('income_history', h.toMap());
    final src = await sourceById(h.sourceId);
    await _audit.log(
      table: 'income_history',
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: h.toMap(),
      summary: 'تغيّر الدخل إلى ${h.amount} من ${h.fromDate.year}/${h.fromDate.month}',
    );
    await _timeline.record(
      type: TimelineEventType.salaryChanged,
      title: 'تغيّر ${src?.name ?? 'الدخل'} إلى ${h.amount}',
      amount: h.amount,
      currency: src?.currency,
      eventDate: h.fromDate,
      refTable: 'income_sources',
      refId: h.sourceId,
    );
    return id;
  }

  Future<void> deleteHistory(int id) async {
    final db = await _db;
    await db.delete('income_history', where: 'id = ?', whereArgs: [id]);
  }

  /// قيمة الدخل الشهري الفعّال في تاريخ معيّن (بجمع كل الفترات المطابقة).
  Future<double> monthlyIncomeAt(DateTime date) async {
    final all = await allHistory();
    double total = 0;
    for (final h in all) {
      if (DateRangeUtils.contains(date, h.fromDate, h.toDate)) {
        total += h.amount;
      }
    }
    return total;
  }

  /// الدخل الشهري الحالي.
  Future<double> currentMonthlyIncome() => monthlyIncomeAt(DateTime.now());
}
