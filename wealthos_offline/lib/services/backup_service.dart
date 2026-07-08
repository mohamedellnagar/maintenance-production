import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/security/encryption_service.dart';
import '../data/database/app_database.dart';

/// خدمة النسخ الاحتياطي والاستعادة — ملف مشفّر محلي بالكامل (بدون سحابة).
class BackupService {
  BackupService(this._appDb, this._enc);

  final AppDatabase _appDb;
  final EncryptionService _enc;

  /// الجداول التي تُصدَّر (بترتيب يحترم القيود المرجعية عند الاستيراد).
  static const _tables = [
    'app_settings',
    'currencies',
    'exchange_rates',
    'income_sources',
    'income_history',
    'expense_categories',
    'expense_history',
    'assets',
    'asset_valuations',
    'liabilities',
    'liability_payments',
    'contributions',
    'transactions',
    'timeline_events',
    'goals',
    'reminders',
    'chat_messages',
    'reports_snapshots',
    'audit_logs',
  ];

  /// الجداول التي تحتوي حقل `notes` مشفّرًا بمفتاح الجهاز.
  static const _encryptedNoteTables = {'assets', 'liabilities'};

  /// تصدير نسخة احتياطية مشفّرة بكلمة مرور. يعيد مسار الملف المُنشأ.
  ///
  /// تُفكّ الحقول المشفّرة بمفتاح الجهاز إلى نص صريح داخل الحمولة (المحمية
  /// أصلًا بكلمة مرور المستخدم)، حتى تكون النسخة قابلة للاستعادة على أي جهاز
  /// آخر لا يملك نفس مفتاح الجهاز.
  Future<File> exportBackup(String password) async {
    final db = await _appDb.database;
    final data = <String, dynamic>{
      'app': 'WealthOS',
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'tables': <String, dynamic>{},
    };
    for (final table in _tables) {
      final rows = await db.query(table);
      if (_encryptedNoteTables.contains(table)) {
        data['tables'][table] = rows.map((row) {
          final m = Map<String, dynamic>.from(row);
          m['notes'] = _enc.decryptText(m['notes'] as String?);
          return m;
        }).toList();
      } else {
        data['tables'][table] = rows;
      }
    }
    final payload = _enc.encryptWithPassword(jsonEncode(data), password);

    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(dir.path, 'wealthos_backup_$stamp.wbak'));
    await file.writeAsString(payload);
    return file;
  }

  /// استيراد نسخة احتياطية مشفّرة واستبدال البيانات الحالية.
  /// يرمي استثناءً إذا كانت كلمة المرور خاطئة أو الملف تالفًا.
  Future<void> importBackup(String encryptedContent, String password) async {
    final decrypted = _enc.decryptWithPassword(encryptedContent, password);
    final data = jsonDecode(decrypted) as Map<String, dynamic>;
    final tables = data['tables'] as Map<String, dynamic>;

    final db = await _appDb.database;
    await db.transaction((txn) async {
      // مسح البيانات الحالية (عكس ترتيب القيود).
      for (final table in _tables.reversed) {
        await txn.delete(table);
      }
      // إدراج البيانات المستعادة (مع إعادة تشفير الملاحظات بمفتاح هذا الجهاز).
      for (final table in _tables) {
        final rows = tables[table] as List<dynamic>?;
        if (rows == null) continue;
        final reEncrypt = _encryptedNoteTables.contains(table);
        for (final row in rows) {
          final m = Map<String, dynamic>.from(row as Map);
          if (reEncrypt && m['notes'] != null) {
            m['notes'] = _enc.encryptText(m['notes'] as String?);
          }
          await txn.insert(table, m);
        }
      }
    });
  }
}
