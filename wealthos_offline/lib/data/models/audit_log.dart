import '../../core/constants/enums.dart';

/// سجل تدقيق لأي تعديل يتم على البيانات.
class AuditLog {
  AuditLog({
    this.id,
    required this.tableName,
    this.recordId,
    required this.action,
    required this.source,
    this.oldValue,
    this.newValue,
    this.summary,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String tableName;
  final int? recordId;
  final AuditAction action;
  final AuditSource source;
  final String? oldValue; // JSON
  final String? newValue; // JSON
  final String? summary; // وصف عربي مختصر للتغيير
  final DateTime createdAt;

  factory AuditLog.fromMap(Map<String, dynamic> m) => AuditLog(
        id: m['id'] as int?,
        tableName: m['table_name'] as String,
        recordId: m['record_id'] as int?,
        action: AuditAction.fromKey(m['action'] as String),
        source: AuditSource.fromKey(m['source'] as String),
        oldValue: m['old_value'] as String?,
        newValue: m['new_value'] as String?,
        summary: m['summary'] as String?,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'table_name': tableName,
        'record_id': recordId,
        'action': action.name,
        'source': source.name,
        'old_value': oldValue,
        'new_value': newValue,
        'summary': summary,
        'created_at': createdAt.toIso8601String(),
      };
}
