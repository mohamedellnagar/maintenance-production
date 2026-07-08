import '../../core/constants/enums.dart';

/// التزام مالي (قرض، بطاقة، قسط، متبقي عقار، دين شخصي).
class Liability {
  Liability({
    this.id,
    required this.name,
    required this.type,
    this.originalAmount = 0,
    required this.remainingAmount,
    this.currency = 'AED',
    this.startDate,
    this.dueDate,
    this.monthlyPayment = 0,
    this.linkedAssetId,
    this.status = LiabilityStatus.active,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String name;
  final LiabilityType type;
  final double originalAmount;
  final double remainingAmount;
  final String currency;
  final DateTime? startDate;
  final DateTime? dueDate;
  final double monthlyPayment;
  final int? linkedAssetId;
  final LiabilityStatus status;
  final String? notes;
  final DateTime createdAt;

  factory Liability.fromMap(Map<String, dynamic> m) => Liability(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: LiabilityType.fromKey(m['type'] as String),
        originalAmount: (m['original_amount'] as num?)?.toDouble() ?? 0,
        remainingAmount: (m['remaining_amount'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'AED',
        startDate: m['start_date'] == null
            ? null
            : DateTime.tryParse(m['start_date'] as String),
        dueDate:
            m['due_date'] == null ? null : DateTime.tryParse(m['due_date'] as String),
        monthlyPayment: (m['monthly_payment'] as num?)?.toDouble() ?? 0,
        linkedAssetId: m['linked_asset_id'] as int?,
        status: LiabilityStatus.fromKey(m['status'] as String? ?? 'active'),
        notes: m['notes'] as String?,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type.name,
        'original_amount': originalAmount,
        'remaining_amount': remainingAmount,
        'currency': currency,
        'start_date': startDate?.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'monthly_payment': monthlyPayment,
        'linked_asset_id': linkedAssetId,
        'status': status.name,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  Liability copyWith({
    String? name,
    LiabilityType? type,
    double? originalAmount,
    double? remainingAmount,
    String? currency,
    DateTime? startDate,
    DateTime? dueDate,
    double? monthlyPayment,
    int? linkedAssetId,
    bool clearLinkedAsset = false,
    LiabilityStatus? status,
    String? notes,
  }) =>
      Liability(
        id: id,
        name: name ?? this.name,
        type: type ?? this.type,
        originalAmount: originalAmount ?? this.originalAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        currency: currency ?? this.currency,
        startDate: startDate ?? this.startDate,
        dueDate: dueDate ?? this.dueDate,
        monthlyPayment: monthlyPayment ?? this.monthlyPayment,
        linkedAssetId: clearLinkedAsset ? null : (linkedAssetId ?? this.linkedAssetId),
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );
}

/// دفعة سداد على التزام.
class LiabilityPayment {
  LiabilityPayment({
    this.id,
    required this.liabilityId,
    required this.amount,
    required this.paymentDate,
    this.note,
  });

  final int? id;
  final int liabilityId;
  final double amount;
  final DateTime paymentDate;
  final String? note;

  factory LiabilityPayment.fromMap(Map<String, dynamic> m) => LiabilityPayment(
        id: m['id'] as int?,
        liabilityId: m['liability_id'] as int,
        amount: (m['amount'] as num).toDouble(),
        paymentDate: DateTime.parse(m['payment_date'] as String),
        note: m['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'liability_id': liabilityId,
        'amount': amount,
        'payment_date': paymentDate.toIso8601String(),
        'note': note,
      };
}
