import '../../core/constants/enums.dart';

/// فئة مصروف (معيشة، إيجار، سفر...). قد تملك عدة فترات تاريخية.
class ExpenseCategory {
  ExpenseCategory({
    this.id,
    required this.name,
    required this.type,
    this.currency = 'AED',
    this.notes,
    this.isActive = true,
  });

  final int? id;
  final String name;
  final ExpenseType type;
  final String currency;
  final String? notes;
  final bool isActive;

  factory ExpenseCategory.fromMap(Map<String, dynamic> m) => ExpenseCategory(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: ExpenseType.fromKey(m['type'] as String),
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

  ExpenseCategory copyWith({
    String? name,
    ExpenseType? type,
    String? currency,
    String? notes,
    bool? isActive,
  }) =>
      ExpenseCategory(
        id: id,
        name: name ?? this.name,
        type: type ?? this.type,
        currency: currency ?? this.currency,
        notes: notes ?? this.notes,
        isActive: isActive ?? this.isActive,
      );
}

/// فترة تاريخية لقيمة المصروف (Expense History).
/// مثال: من 2019 إلى 2022 = 1800، ثم من 2023 حتى الآن = 10000.
class ExpenseHistory {
  ExpenseHistory({
    this.id,
    required this.categoryId,
    required this.amount,
    required this.fromDate,
    this.toDate,
    this.note,
  });

  final int? id;
  final int categoryId;
  final double amount; // شهري
  final DateTime fromDate;
  final DateTime? toDate;
  final String? note;

  bool get isCurrent => toDate == null;

  factory ExpenseHistory.fromMap(Map<String, dynamic> m) => ExpenseHistory(
        id: m['id'] as int?,
        categoryId: m['category_id'] as int,
        amount: (m['amount'] as num).toDouble(),
        fromDate: DateTime.parse(m['from_date'] as String),
        toDate:
            m['to_date'] == null ? null : DateTime.tryParse(m['to_date'] as String),
        note: m['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'category_id': categoryId,
        'amount': amount,
        'from_date': fromDate.toIso8601String(),
        'to_date': toDate?.toIso8601String(),
        'note': note,
      };

  ExpenseHistory copyWith({
    double? amount,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearToDate = false,
    String? note,
  }) =>
      ExpenseHistory(
        id: id,
        categoryId: categoryId,
        amount: amount ?? this.amount,
        fromDate: fromDate ?? this.fromDate,
        toDate: clearToDate ? null : (toDate ?? this.toDate),
        note: note ?? this.note,
      );
}
