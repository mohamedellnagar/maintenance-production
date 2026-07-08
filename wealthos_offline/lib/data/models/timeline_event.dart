import '../../core/constants/enums.dart';

/// حدث في المسار المالي الزمني للمستخدم.
class TimelineEvent {
  TimelineEvent({
    this.id,
    required this.type,
    required this.title,
    this.description,
    this.amount,
    this.currency,
    required this.eventDate,
    this.refTable,
    this.refId,
  });

  final int? id;
  final TimelineEventType type;
  final String title;
  final String? description;
  final double? amount;
  final String? currency;
  final DateTime eventDate;
  final String? refTable; // الجدول المصدر (assets, liabilities...)
  final int? refId;

  factory TimelineEvent.fromMap(Map<String, dynamic> m) => TimelineEvent(
        id: m['id'] as int?,
        type: TimelineEventType.fromKey(m['type'] as String),
        title: m['title'] as String,
        description: m['description'] as String?,
        amount: (m['amount'] as num?)?.toDouble(),
        currency: m['currency'] as String?,
        eventDate: DateTime.parse(m['event_date'] as String),
        refTable: m['ref_table'] as String?,
        refId: m['ref_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'amount': amount,
        'currency': currency,
        'event_date': eventDate.toIso8601String(),
        'ref_table': refTable,
        'ref_id': refId,
      };
}
