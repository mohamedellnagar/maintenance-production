import '../../../core/time/local_date.dart';
import 'goal_type.dart';

/// A single movement in a goal's fund ledger. Always stores a positive
/// [amountMinor]; its effect on the balance comes from [type] (and [direction]
/// for adjustments). The ledger — not the cached fund balance — is the truth.
class GoalFundEntry {
  const GoalFundEntry({
    required this.id,
    required this.goalId,
    required this.type,
    required this.amountMinor,
    required this.entryDate,
    required this.createdAt,
    this.direction,
    this.linkedTransactionId,
    this.relatedGoalId,
    this.note,
    this.deletedAt,
  });

  final String id;
  final String goalId;
  final GoalFundEntryType type;

  /// Only set (and required) for [GoalFundEntryType.adjustment].
  final AdjustmentDirection? direction;
  final int amountMinor;
  final String? linkedTransactionId;

  /// The other goal in a transfer (cross-linked both ways).
  final String? relatedGoalId;
  final LocalDate entryDate;
  final String? note;
  final DateTime createdAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  /// The signed effect this entry has on the fund balance (0 when deleted).
  int get signedEffectMinor {
    if (isDeleted) return 0;
    final increases = switch (type) {
      GoalFundEntryType.contribution || GoalFundEntryType.transferIn => true,
      GoalFundEntryType.withdrawal || GoalFundEntryType.transferOut => false,
      GoalFundEntryType.adjustment => direction == AdjustmentDirection.increase,
    };
    return increases ? amountMinor : -amountMinor;
  }
}
