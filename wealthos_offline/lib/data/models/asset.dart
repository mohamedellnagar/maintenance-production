import '../../core/constants/enums.dart';

/// أصل مملوك للمستخدم (نقد، عقار، سيارة، استثمار...).
class Asset {
  Asset({
    this.id,
    required this.name,
    required this.type,
    this.purchaseValue = 0,
    required this.currentValue,
    this.currency = 'AED',
    this.purchaseDate,
    this.ownershipStatus = OwnershipStatus.owned,
    this.notes,
    this.linkedLiabilityId,
    this.lastValuationDate,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String name;
  final AssetType type;
  final double purchaseValue;
  final double currentValue;
  final String currency;
  final DateTime? purchaseDate;
  final OwnershipStatus ownershipStatus;
  final String? notes;
  final int? linkedLiabilityId;
  final DateTime? lastValuationDate;
  final bool isActive; // false عند بيع الأصل
  final DateTime createdAt;

  factory Asset.fromMap(Map<String, dynamic> m) => Asset(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: AssetType.fromKey(m['type'] as String),
        purchaseValue: (m['purchase_value'] as num?)?.toDouble() ?? 0,
        currentValue: (m['current_value'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'AED',
        purchaseDate: m['purchase_date'] == null
            ? null
            : DateTime.tryParse(m['purchase_date'] as String),
        ownershipStatus: OwnershipStatus.fromKey(m['ownership_status'] as String? ?? 'owned'),
        notes: m['notes'] as String?,
        linkedLiabilityId: m['linked_liability_id'] as int?,
        lastValuationDate: m['last_valuation_date'] == null
            ? null
            : DateTime.tryParse(m['last_valuation_date'] as String),
        isActive: (m['is_active'] as int? ?? 1) == 1,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type.name,
        'purchase_value': purchaseValue,
        'current_value': currentValue,
        'currency': currency,
        'purchase_date': purchaseDate?.toIso8601String(),
        'ownership_status': ownershipStatus.name,
        'notes': notes,
        'linked_liability_id': linkedLiabilityId,
        'last_valuation_date': lastValuationDate?.toIso8601String(),
        'is_active': isActive ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  Asset copyWith({
    String? name,
    AssetType? type,
    double? purchaseValue,
    double? currentValue,
    String? currency,
    DateTime? purchaseDate,
    OwnershipStatus? ownershipStatus,
    String? notes,
    int? linkedLiabilityId,
    bool clearLinkedLiability = false,
    DateTime? lastValuationDate,
    bool? isActive,
  }) =>
      Asset(
        id: id,
        name: name ?? this.name,
        type: type ?? this.type,
        purchaseValue: purchaseValue ?? this.purchaseValue,
        currentValue: currentValue ?? this.currentValue,
        currency: currency ?? this.currency,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        ownershipStatus: ownershipStatus ?? this.ownershipStatus,
        notes: notes ?? this.notes,
        linkedLiabilityId:
            clearLinkedLiability ? null : (linkedLiabilityId ?? this.linkedLiabilityId),
        lastValuationDate: lastValuationDate ?? this.lastValuationDate,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );
}

/// سجل تقييم لقيمة أصل عبر الزمن.
class AssetValuation {
  AssetValuation({
    this.id,
    required this.assetId,
    required this.value,
    required this.valuationDate,
    this.note,
  });

  final int? id;
  final int assetId;
  final double value;
  final DateTime valuationDate;
  final String? note;

  factory AssetValuation.fromMap(Map<String, dynamic> m) => AssetValuation(
        id: m['id'] as int?,
        assetId: m['asset_id'] as int,
        value: (m['value'] as num).toDouble(),
        valuationDate: DateTime.parse(m['valuation_date'] as String),
        note: m['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'asset_id': assetId,
        'value': value,
        'valuation_date': valuationDate.toIso8601String(),
        'note': note,
      };
}
