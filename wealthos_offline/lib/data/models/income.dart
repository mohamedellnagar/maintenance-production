import '../../core/constants/enums.dart';

/// مصدر دخل (راتب، عمل حر، دخل تجاري...). قد يملك عدة فترات تاريخية.
class IncomeSource {
  IncomeSource({
    this.id,
    required this.name,
    required this.type,
    this.currency = 'AED',
    this.notes,
    this.isActive = true,
  });

  final int? id;
  final String name;
  final IncomeType type;
  final String currency;
  final String? notes;
  final bool isActive;

  factory IncomeSource.fromMap(Map<String, dynamic> m) => IncomeSource(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: IncomeType.fromKey(m['type'] as String),
        currency: m['currency'] as String? ?? 'AED',
        notes: m['notes'] as String?,
        isActive: (m['is_active'] as int? ?? 1) == 1,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type.name,
        'currency': currency,
        'notes': notes,
        'is_active': isActive ? 1 : 0,
      };

  IncomeSource copyWith({
    String? name,
    IncomeType? type,
    String? currency,
    String? notes,
    bool? isActive,
  }) =>
      IncomeSource(
        id: id,
        name: name ?? this.name,
        type: type ?? this.type,
        currency: currency ?? this.currency,
        notes: notes ?? this.notes,
        isActive: isActive ?? this.isActive,
      );
}

/// فترة تاريخية لقيمة الدخل (Salary History).
/// مثال: من 2019-01 إلى 2022-12 = 5000، ثم من 2023-01 حتى الآن = 10000.
class IncomeHistory {
  IncomeHistory({
    this.id,
    required this.sourceId,
    required this.amount,
    required this.fromDate,
    this.toDate, // null = حتى الآن
    this.note,
  });

  final int? id;
  final int sourceId;
  final double amount; // شهري
  final DateTime fromDate;
  final DateTime? toDate;
  final String? note;

  bool get isCurrent => toDate == null;

  factory IncomeHistory.fromMap(Map<String, dynamic> m) => IncomeHistory(
        id: m['id'] as int?,
        sourceId: m['source_id'] as int,
        amount: (m['amount'] as num).toDouble(),
        fromDate: DateTime.parse(m['from_date'] as String),
        toDate:
            m['to_date'] == null ? null : DateTime.tryParse(m['to_date'] as String),
        note: m['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'source_id': sourceId,
        'amount': amount,
        'from_date': fromDate.toIso8601String(),
        'to_date': toDate?.toIso8601String(),
        'note': note,
      };

  IncomeHistory copyWith({
    double? amount,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearToDate = false,
    String? note,
  }) =>
      IncomeHistory(
        id: id,
        sourceId: sourceId,
        amount: amount ?? this.amount,
        fromDate: fromDate ?? this.fromDate,
        toDate: clearToDate ? null : (toDate ?? this.toDate),
        note: note ?? this.note,
      );
}
