import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// طبقة الوصول لقاعدة البيانات المحلية (SQLite) عبر sqflite.
///
/// تنشئ جميع الجداول العشرين وتدير الترقيات. لا يوجد أي اتصال بالشبكة —
/// كل البيانات محفوظة محليًا على الجهاز.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'wealthos.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// فتح قاعدة بيانات في مسار محدد (يُستخدم للاختبارات مع sqflite_common_ffi).
  Future<Database> openAt(String path) async {
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    // مكان الترقيات المستقبلية للمخطط.
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final stmt in _schema) {
      batch.execute(stmt);
    }
    _seedCurrencies(batch);
    // صف الإعدادات الافتراضي.
    batch.insert('app_settings', {
      'id': 1,
      'user_name': '',
      'base_currency': 'AED',
      'onboarding_completed': 0,
      'pin_enabled': 0,
      'biometric_enabled': 0,
      'auto_lock_minutes': 2,
      'has_family': 0,
      'locale': 'ar',
    });
    await batch.commit(noResult: true);
  }

  void _seedCurrencies(Batch batch) {
    const seed = [
      ['AED', 'درهم إماراتي', 'د.إ'],
      ['EGP', 'جنيه مصري', 'ج.م'],
      ['USD', 'دولار أمريكي', '\$'],
      ['SAR', 'ريال سعودي', 'ر.س'],
    ];
    for (final c in seed) {
      batch.insert('currencies', {'code': c[0], 'name': c[1], 'symbol': c[2]},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  /// جميع عبارات إنشاء الجداول.
  static const List<String> _schema = [
    '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL DEFAULT '',
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )''',
    '''
    CREATE TABLE app_settings (
      id INTEGER PRIMARY KEY,
      user_name TEXT NOT NULL DEFAULT '',
      birth_year INTEGER,
      base_currency TEXT NOT NULL DEFAULT 'AED',
      analysis_start_date TEXT,
      onboarding_completed INTEGER NOT NULL DEFAULT 0,
      pin_enabled INTEGER NOT NULL DEFAULT 0,
      biometric_enabled INTEGER NOT NULL DEFAULT 0,
      auto_lock_minutes INTEGER NOT NULL DEFAULT 2,
      has_family INTEGER NOT NULL DEFAULT 0,
      locale TEXT NOT NULL DEFAULT 'ar'
    )''',
    '''
    CREATE TABLE currencies (
      code TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      symbol TEXT NOT NULL
    )''',
    '''
    CREATE TABLE exchange_rates (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      currency_code TEXT NOT NULL,
      rate_to_base REAL NOT NULL,
      updated_at TEXT NOT NULL,
      UNIQUE(currency_code)
    )''',
    '''
    CREATE TABLE income_sources (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      notes TEXT,
      is_active INTEGER NOT NULL DEFAULT 1
    )''',
    '''
    CREATE TABLE income_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      source_id INTEGER NOT NULL,
      amount REAL NOT NULL,
      from_date TEXT NOT NULL,
      to_date TEXT,
      note TEXT,
      FOREIGN KEY(source_id) REFERENCES income_sources(id) ON DELETE CASCADE
    )''',
    '''
    CREATE TABLE expense_categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      notes TEXT,
      is_active INTEGER NOT NULL DEFAULT 1
    )''',
    '''
    CREATE TABLE expense_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER NOT NULL,
      amount REAL NOT NULL,
      from_date TEXT NOT NULL,
      to_date TEXT,
      note TEXT,
      FOREIGN KEY(category_id) REFERENCES expense_categories(id) ON DELETE CASCADE
    )''',
    '''
    CREATE TABLE assets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      purchase_value REAL NOT NULL DEFAULT 0,
      current_value REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      purchase_date TEXT,
      ownership_status TEXT NOT NULL DEFAULT 'owned',
      notes TEXT,
      linked_liability_id INTEGER,
      last_valuation_date TEXT,
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE asset_valuations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      asset_id INTEGER NOT NULL,
      value REAL NOT NULL,
      valuation_date TEXT NOT NULL,
      note TEXT,
      FOREIGN KEY(asset_id) REFERENCES assets(id) ON DELETE CASCADE
    )''',
    '''
    CREATE TABLE liabilities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      original_amount REAL NOT NULL DEFAULT 0,
      remaining_amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      start_date TEXT,
      due_date TEXT,
      monthly_payment REAL NOT NULL DEFAULT 0,
      linked_asset_id INTEGER,
      status TEXT NOT NULL DEFAULT 'active',
      notes TEXT,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE liability_payments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      liability_id INTEGER NOT NULL,
      amount REAL NOT NULL,
      payment_date TEXT NOT NULL,
      note TEXT,
      FOREIGN KEY(liability_id) REFERENCES liabilities(id) ON DELETE CASCADE
    )''',
    '''
    CREATE TABLE contributions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      date TEXT,
      beneficiary TEXT,
      notes TEXT,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'AED',
      date TEXT NOT NULL,
      category TEXT,
      ref_table TEXT,
      ref_id INTEGER,
      notes TEXT
    )''',
    '''
    CREATE TABLE timeline_events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      amount REAL,
      currency TEXT,
      event_date TEXT NOT NULL,
      ref_table TEXT,
      ref_id INTEGER
    )''',
    '''
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      target_amount REAL NOT NULL,
      current_progress REAL NOT NULL DEFAULT 0,
      currency TEXT NOT NULL DEFAULT 'AED',
      target_date TEXT,
      status TEXT NOT NULL DEFAULT 'active',
      notes TEXT,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE reminders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      body TEXT,
      due_date TEXT NOT NULL,
      is_done INTEGER NOT NULL DEFAULT 0,
      ref_table TEXT,
      ref_id INTEGER
    )''',
    '''
    CREATE TABLE chat_messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      role TEXT NOT NULL,
      text TEXT NOT NULL,
      intent TEXT,
      action_applied INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE reports_snapshots (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      payload_json TEXT NOT NULL,
      created_at TEXT NOT NULL
    )''',
    '''
    CREATE TABLE audit_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      record_id INTEGER,
      action TEXT NOT NULL,
      source TEXT NOT NULL,
      old_value TEXT,
      new_value TEXT,
      summary TEXT,
      created_at TEXT NOT NULL
    )''',
    'CREATE INDEX idx_income_hist_source ON income_history(source_id)',
    'CREATE INDEX idx_expense_hist_cat ON expense_history(category_id)',
    'CREATE INDEX idx_timeline_date ON timeline_events(event_date)',
    'CREATE INDEX idx_audit_created ON audit_logs(created_at)',
    'CREATE INDEX idx_valuations_asset ON asset_valuations(asset_id)',
    'CREATE INDEX idx_payments_liability ON liability_payments(liability_id)',
  ];
}
