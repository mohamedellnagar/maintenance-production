import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/app_meta.dart';

/// مستودع العملات وأسعار التحويل (تُدخَل يدويًا في الـ MVP).
class CurrencyRepository {
  CurrencyRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;

  Future<List<Currency>> currencies() async {
    final db = await _db;
    final rows = await db.query('currencies', orderBy: 'code ASC');
    return rows.map(Currency.fromMap).toList();
  }

  Future<void> addCurrency(Currency c) async {
    final db = await _db;
    await db.insert('currencies', c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ExchangeRate>> rates() async {
    final db = await _db;
    final rows = await db.query('exchange_rates');
    return rows.map(ExchangeRate.fromMap).toList();
  }

  /// خريطة code -> rateToBase. العملة الأساسية تساوي 1.
  Future<Map<String, double>> rateMap(String baseCurrency) async {
    final list = await rates();
    final map = <String, double>{baseCurrency: 1.0};
    for (final r in list) {
      map[r.currencyCode] = r.rateToBase;
    }
    return map;
  }

  Future<void> setRate(String code, double rateToBase) async {
    final db = await _db;
    await db.insert(
      'exchange_rates',
      ExchangeRate(
        currencyCode: code,
        rateToBase: rateToBase,
        updatedAt: DateTime.now(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
