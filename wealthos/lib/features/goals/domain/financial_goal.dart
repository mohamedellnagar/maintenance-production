import '../../../core/time/local_date.dart';
import 'goal_type.dart';

/// A financial goal: a target the user saves toward. It never holds real money
/// (that lives in accounts); it only stores the target and lifecycle. Progress
/// is tracked by its [GoalFund].
class FinancialGoal {
  const FinancialGoal({
    required this.id,
    required this.name,
    required this.type,
    required this.targetAmountMinor,
    required this.currencyCode,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.targetDate,
    this.linkedLiabilityAccountId,
    this.notes,
    this.completedAt,
    this.cancelledAt,
  });

  final String id;
  final String name;
  final GoalType type;
  final int targetAmountMinor;
  final String currencyCode;

  /// Optional deadline (a [LocalDate]). Drives required-monthly and on-track.
  final LocalDate? targetDate;
  final GoalPriority priority;
  final GoalStatus status;

  /// For a [GoalType.debtPayoff] goal, the liability this repays (optional).
  final String? linkedLiabilityAccountId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
}
