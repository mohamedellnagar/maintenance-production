import 'goal_fund_entry.dart';

/// The cached allocation bucket for a goal (1:1). [currentAllocatedMinor] is a
/// materialized copy of the ledger sum, kept in sync on every write and
/// rebuildable via [balanceFromEntries].
class GoalFund {
  const GoalFund({
    required this.id,
    required this.goalId,
    required this.currentAllocatedMinor,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String goalId;
  final int currentAllocatedMinor;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Recomputes a fund balance from its ledger — the source of truth. Deleted
  /// entries contribute zero (via [GoalFundEntry.signedEffectMinor]).
  static int balanceFromEntries(Iterable<GoalFundEntry> entries) =>
      entries.fold(0, (sum, e) => sum + e.signedEffectMinor);
}
