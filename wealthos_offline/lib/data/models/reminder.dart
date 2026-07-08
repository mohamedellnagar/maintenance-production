import '../../core/constants/enums.dart';

/// تنبيه محلي (Offline) — قسط قادم، مراجعة شهرية...
class Reminder {
  Reminder({
    this.id,
    required this.type,
    required this.title,
    this.body,
    required this.dueDate,
    this.isDone = false,
    this.refTable,
    this.refId,
  });

  final int? id;
  final ReminderType type;
  final String title;
  final String? body;
  final DateTime dueDate;
  final bool isDone;
  final String? refTable;
  final int? refId;

  factory Reminder.fromMap(Map<String, dynamic> m) => Reminder(
        id: m['id'] as int?,
        type: ReminderType.fromKey(m['type'] as String),
        title: m['title'] as String,
        body: m['body'] as String?,
        dueDate: DateTime.parse(m['due_date'] as String),
        isDone: (m['is_done'] as int? ?? 0) == 1,
        refTable: m['ref_table'] as String?,
        refId: m['ref_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type.name,
        'title': title,
        'body': body,
        'due_date': dueDate.toIso8601String(),
        'is_done': isDone ? 1 : 0,
        'ref_table': refTable,
        'ref_id': refId,
      };

  Reminder copyWith({bool? isDone, DateTime? dueDate, String? title, String? body}) =>
      Reminder(
        id: id,
        type: type,
        title: title ?? this.title,
        body: body ?? this.body,
        dueDate: dueDate ?? this.dueDate,
        isDone: isDone ?? this.isDone,
        refTable: refTable,
        refId: refId,
      );
}
