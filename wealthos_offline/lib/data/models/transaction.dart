/// حركة مالية عامة (اختيارية) — لتسجيل التدفقات النقدية المنفصلة
/// (إيداع، سحب، تحويل) التي لا ترتبط مباشرة بأصل أو التزام واحد.
class FinancialTransaction {
  FinancialTransaction({
    this.id,
    required this.title,
    required this.amount, // موجب = دخل، سالب = مصروف
    this.currency = 'AED',
    required this.date,
    this.category,
    this.refTable,
    this.refId,
    this.notes,
  });

  final int? id;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final String? category;
  final String? refTable;
  final int? refId;
  final String? notes;

  bool get isInflow => amount >= 0;

  factory FinancialTransaction.fromMap(Map<String, dynamic> m) => FinancialTransaction(
        id: m['id'] as int?,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'AED',
        date: DateTime.parse(m['date'] as String),
        category: m['category'] as String?,
        refTable: m['ref_table'] as String?,
        refId: m['ref_id'] as int?,
        notes: m['notes'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'amount': amount,
        'currency': currency,
        'date': date.toIso8601String(),
        'category': category,
        'ref_table': refTable,
        'ref_id': refId,
        'notes': notes,
      };
}
