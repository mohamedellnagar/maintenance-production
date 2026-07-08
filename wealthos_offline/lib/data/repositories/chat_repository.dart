import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/chat_message.dart';

/// مستودع رسائل المساعد الذكي.
class ChatRepository {
  ChatRepository(this._appDb);
  final AppDatabase _appDb;

  Future<Database> get _db => _appDb.database;
  static const _table = 'chat_messages';

  Future<List<ChatMessage>> all() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'created_at ASC, id ASC');
    return rows.map(ChatMessage.fromMap).toList();
  }

  Future<int> add(ChatMessage m) async {
    final db = await _db;
    return db.insert(_table, m.toMap());
  }

  Future<void> clear() async {
    final db = await _db;
    await db.delete(_table);
  }
}
