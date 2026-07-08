import '../../core/constants/enums.dart';

/// هدف مالي (أول مليون، شراء عقار، صندوق طوارئ...).
class Goal {
  Goal({
    this.id,
    required this.title,
    required this.targetAmount,
    this.currentProgress = 0,
    this.currency = 'AED',
    this.targetDate,
    this.status = GoalStatus.active,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final int? id;
  final String title;
  final double targetAmount;
  final double currentProgress;
  final String currency;
  final DateTime? targetDate;
  final GoalStatus status;
  final String? notes;
  final DateTime createdAt;

  double get progressRatio =>
      targetAmount <= 0 ? 0 : (currentProgress / targetAmount).clamp(0, 1).toDouble();

  /// الادخار الشهري المطلوب للوصول للهدف في موعده.
  double requiredMonthlySaving([DateTime? now]) {
    if (targetDate == null) return 0;
    final ref = now ?? DateTime.now();
    final months = (targetDate!.year - ref.year) * 12 + (targetDate!.month - ref.month);
    if (months <= 0) return 0;
    final remaining = (targetAmount - currentProgress).clamp(0, double.infinity);
    return remaining / months;
  }

  factory Goal.fromMap(Map<String, dynamic> m) => Goal(
        id: m['id'] as int?,
        title: m['title'] as String,
        targetAmount: (m['target_amount'] as num).toDouble(),
        currentProgress: (m['current_progress'] as num?)?.toDouble() ?? 0,
        currency: m['currency'] as String? ?? 'AED',
        targetDate: m['target_date'] == null
            ? null
            : DateTime.tryParse(m['target_date'] as String),
        status: GoalStatus.fromKey(m['status'] as String? ?? 'active'),
        notes: m['notes'] as String?,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'target_amount': targetAmount,
        'current_progress': currentProgress,
        'currency': currency,
        'target_date': targetDate?.toIso8601String(),
        'status': status.name,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  Goal copyWith({
    String? title,
    double? targetAmount,
    double? currentProgress,
    String? currency,
    DateTime? targetDate,
    GoalStatus? status,
    String? notes,
  }) =>
      Goal(
        id: id,
        title: title ?? this.title,
        targetAmount: targetAmount ?? this.targetAmount,
        currentProgress: currentProgress ?? this.currentProgress,
        currency: currency ?? this.currency,
        targetDate: targetDate ?? this.targetDate,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );
}
