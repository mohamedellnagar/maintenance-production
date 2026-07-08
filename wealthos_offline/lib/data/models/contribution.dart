/// مساهمة عائلية دفعها المستخدم لكنها ليست أصلًا مملوكًا له
/// (مثل المشاركة في بناء بيت العائلة). تظهر في التقارير ولا تدخل في صافي الثروة.
class Contribution {
  Contribution({
    this.id,
    required this.title,
    required this.amount,
    this.currency = 'AED',
    this.date,
    this.beneficiary,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String title;
  final double amount;
  final String currency;
  final DateTime? date;
  final String? beneficiary; // المستفيد (العائلة، الأخ...)
  final String? notes;
  final DateTime createdAt;

  factory Contribution.fromMap(Map<String, dynamic> m) => Contribution(
        id: m['id'] as int?,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'AED',
        date: m['date'] == null ? null : DateTime.tryParse(m['date'] as String),
        beneficiary: m['beneficiary'] as String?,
        notes: m['notes'] as String?,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'amount': amount,
        'currency': currency,
        'date': date?.toIso8601String(),
        'beneficiary': beneficiary,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  Contribution copyWith({
    String? title,
    double? amount,
    String? currency,
    DateTime? date,
    String? beneficiary,
    String? notes,
  }) =>
      Contribution(
        id: id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        date: date ?? this.date,
        beneficiary: beneficiary ?? this.beneficiary,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );
}
