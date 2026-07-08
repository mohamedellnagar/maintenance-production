import 'package:sqflite/sqflite.dart';

import '../../core/constants/enums.dart';
import '../../core/utils/date_range.dart';
import '../database/app_database.dart';
import '../models/expense.dart';
import 'audit_repository.dart';
import 'timeline_repository.dart';

/// مستودع المصروفات — فئات المصروف + فتراتها التاريخية (Expense History).
class ExpenseRepository {
  ExpenseRepository(this._appDb, this._audit, this._timeline);

  final AppDatabase _appDb;
  final AuditRepository _audit;
  final TimelineRepository _timeline;

  Future<Database> get _db => _appDb.database;

  Future<List<ExpenseCategory>> categories() async {
    final db = await _db;
    final rows = await db.query('expense_categories', orderBy: 'id DESC');
    return rows.map(ExpenseCategory.fromMap).toList();
  }

  Future<ExpenseCategory?> categoryById(int id) async {
    final db = await _db;
    final rows = await db.query('expense_categories',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return ExpenseCategory.fromMap(rows.first);
  }

  Future<int> createCategory(ExpenseCategory c,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    final id = await db.insert('expense_categories', c.toMap());
    await _audit.log(
      table: 'expense_categories',
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: c.toMap(),
      summary: 'إضافة فئة مصروف: ${c.name}',
    );
    return id;
  }

  Future<void> updateCategory(ExpenseCategory c,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    await db.update('expense_categories', c.toMap(),
        where: 'id = ?', whereArgs: [c.id]);
    await _audit.log(
      table: 'expense_categories',
      recordId: c.id,
      action: AuditAction.update,
      source: source,
      newValue: c.toMap(),
      summary: 'تحديث فئة مصروف: ${c.name}',
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await _db;
    await db.delete('expense_categories', where: 'id = ?', whereArgs: [id]);
    await _audit.log(
      table: 'expense_categories',
      recordId: id,
      action: AuditAction.delete,
      source: AuditSource.manual,
      summary: 'حذف فئة مصروف #$id',
    );
  }

  Future<List<ExpenseHistory>> history(int categoryId) async {
    final db = await _db;
    final rows = await db.query('expense_history',
        where: 'category_id = ?', whereArgs: [categoryId], orderBy: 'from_date ASC');
    return rows.map(ExpenseHistory.fromMap).toList();
  }

  Future<List<ExpenseHistory>> allHistory() async {
    final db = await _db;
    final rows = await db.query('expense_history', orderBy: 'from_date ASC');
    return rows.map(ExpenseHistory.fromMap).toList();
  }

  Future<int> addHistory(ExpenseHistory h,
      {AuditSource source = AuditSource.manual}) async {
    final db = await _db;
    if (h.isCurrent) {
      final open = await db.query('expense_history',
          where: 'category_id = ? AND to_date IS NULL', whereArgs: [h.categoryId]);
      for (final row in open) {
        final existing = ExpenseHistory.fromMap(row);
        final closeDate = DateTime(h.fromDate.year, h.fromDate.month, 0);
        if (closeDate.isAfter(existing.fromDate)) {
          await db.update('expense_history',
              {'to_date': closeDate.toIso8601String()},
              where: 'id = ?', whereArgs: [existing.id]);
        } else {
          // فترة قديمة تبدأ في نفس شهر الجديدة: استُبدلت قبل أن تسري — تُحذف.
          await db.delete('expense_history',
              where: 'id = ?', whereArgs: [existing.id]);
        }
      }
    }
    final id = await db.insert('expense_history', h.toMap());
    final cat = await categoryById(h.categoryId);
    await _audit.log(
      table: 'expense_history',
      recordId: id,
      action: AuditAction.create,
      source: source,
      newValue: h.toMap(),
      summary: 'تغيّر المصروف إلى ${h.amount} من ${h.fromDate.year}/${h.fromDate.month}',
    );
    await _timeline.record(
      type: TimelineEventType.expenseChanged,
      title: 'تغيّر ${cat?.name ?? 'المصروف'} إلى ${h.amount}',
      amount: h.amount,
      currency: cat?.currency,
      eventDate: h.fromDate,
      refTable: 'expense_categories',
      refId: h.categoryId,
    );
    return id;
  }

  Future<void> deleteHistory(int id) async {
    final db = await _db;
    await db.delete('expense_history', where: 'id = ?', whereArgs: [id]);
  }

  /// إجمالي المصروف الشهري الفعّال في تاريخ معيّن.
  ///
  /// لكل فئة فترةٌ واحدة فعّالة فقط (الأحدث بدايةً عند التداخل)، ثم تُجمع
  /// الفئات معًا — تفاديًا لازدواج الحساب.
  Future<double> monthlyExpenseAt(DateTime date) async {
    final all = await allHistory();
    final byCategory = <int, ExpenseHistory>{};
    for (final h in all) {
      if (!DateRangeUtils.contains(date, h.fromDate, h.toDate)) continue;
      final current = byCategory[h.categoryId];
      // الأحدث بدايةً يفوز؛ وعند تساوي البداية يفوز الأحدث إدخالًا (id أكبر).
      if (current == null ||
          h.fromDate.isAfter(current.fromDate) ||
          (h.fromDate == current.fromDate &&
              (h.id ?? 0) > (current.id ?? 0))) {
        byCategory[h.categoryId] = h;
      }
    }
    return byCategory.values.fold<double>(0, (sum, h) => sum + h.amount);
  }

  Future<double> currentMonthlyExpense() => monthlyExpenseAt(DateTime.now());
}
