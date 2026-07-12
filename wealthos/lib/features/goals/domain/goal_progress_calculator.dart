import '../../../core/time/local_date.dart';
import '../../accounts/domain/account_type.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_semantic.dart';
import '../../transactions/domain/transaction_type.dart';
import 'financial_goal.dart';
import 'goal_fund_entry.dart';
import 'goal_thresholds.dart';
import 'goal_type.dart';

/// The computed progress of a single goal. All money is integer minor units.
class GoalProgress {
  const GoalProgress({
    required this.fundedMinor,
    required this.targetMinor,
    required this.remainingMinor,
    required this.overfundedMinor,
    required this.fundingRatio,
    required this.trackStatus,
    required this.avgMonthlyContributionMinor,
    this.requiredMonthlyMinor,
    this.projectedCompletion,
  });

  final int fundedMinor;
  final int targetMinor;
  final int remainingMinor;
  final int overfundedMinor;
  final double fundingRatio;
  final GoalTrackStatus trackStatus;
  final int avgMonthlyContributionMinor;

  /// Contribution/month needed to hit the target by [FinancialGoal.targetDate].
  /// Null when the goal has no target date; 0 once fully funded.
  final int? requiredMonthlyMinor;

  /// Estimated completion date from the recent contribution rate, or null when
  /// it cannot be estimated (no recent contributions).
  final LocalDate? projectedCompletion;

  bool get isFunded => fundedMinor >= targetMinor;
  bool get isOverfunded => overfundedMinor > 0;
}

/// Pure goal progress + projection math. Exhaustively unit-tested; never uses
/// `double` for stored money and never guesses precision it does not have.
abstract final class GoalProgressCalculator {
  const GoalProgressCalculator._();

  static GoalProgress compute({
    required FinancialGoal goal,
    required int fundedMinor,
    required List<GoalFundEntry> entries,
    required LocalDate today,
  }) {
    final target = goal.targetAmountMinor;
    final remaining = fundedMinor >= target ? 0 : target - fundedMinor;
    final overfunded = fundedMinor > target ? fundedMinor - target : 0;
    final ratio = target <= 0 ? 0.0 : fundedMinor / target;

    final avgMonthly = _avgMonthlyContribution(entries, today);
    final requiredMonthly = _requiredMonthly(goal, remaining, today);
    final projected = _projectedCompletion(remaining, avgMonthly, today);
    final track = _trackStatus(
      goal: goal,
      funded: fundedMinor,
      target: target,
      entries: entries,
      requiredMonthly: requiredMonthly,
      avgMonthly: avgMonthly,
    );

    return GoalProgress(
      fundedMinor: fundedMinor,
      targetMinor: target,
      remainingMinor: remaining,
      overfundedMinor: overfunded,
      fundingRatio: ratio,
      trackStatus: track,
      avgMonthlyContributionMinor: avgMonthly,
      requiredMonthlyMinor: requiredMonthly,
      projectedCompletion: projected,
    );
  }

  /// Whole calendar months from [today] to [target] (minimum 1). A partial
  /// month (target day-of-month before today's) does not count as a full month.
  static int monthsRemaining(LocalDate today, LocalDate target) {
    var months =
        (target.year * 12 + target.month) - (today.year * 12 + today.month);
    if (target.day < today.day) months -= 1;
    return months < 1 ? 1 : months;
  }

  static int _ceilDiv(int a, int b) => b <= 0 ? 0 : (a + b - 1) ~/ b;

  static int? _requiredMonthly(
    FinancialGoal goal,
    int remaining,
    LocalDate today,
  ) {
    final targetDate = goal.targetDate;
    if (targetDate == null) return null;
    if (remaining <= 0) return 0;
    return _ceilDiv(remaining, monthsRemaining(today, targetDate));
  }

  /// Average of `contribution` entries over the trailing projection window.
  /// Withdrawals and inter-goal transfers are intentionally excluded so a
  /// transfer never reads as new saving.
  static int _avgMonthlyContribution(
    List<GoalFundEntry> entries,
    LocalDate today,
  ) {
    final windowStart = today.addMonths(-GoalThresholds.projectionWindowMonths);
    var sum = 0;
    for (final e in entries) {
      if (e.isDeleted) continue;
      if (e.type != GoalFundEntryType.contribution) continue;
      if (e.entryDate.isBefore(windowStart)) continue;
      if (e.entryDate.isAfter(today)) continue;
      sum += e.amountMinor;
    }
    return sum ~/ GoalThresholds.projectionWindowMonths;
  }

  static LocalDate? _projectedCompletion(
    int remaining,
    int avgMonthly,
    LocalDate today,
  ) {
    if (remaining <= 0) return today;
    if (avgMonthly <= 0) return null;
    return today.addMonths(_ceilDiv(remaining, avgMonthly));
  }

  static GoalTrackStatus _trackStatus({
    required FinancialGoal goal,
    required int funded,
    required int target,
    required List<GoalFundEntry> entries,
    required int? requiredMonthly,
    required int avgMonthly,
  }) {
    if (funded >= target) return GoalTrackStatus.completed;
    if (goal.targetDate == null) return GoalTrackStatus.noTargetDate;
    final everContributed = entries.any(
      (e) => !e.isDeleted && e.type == GoalFundEntryType.contribution,
    );
    if (!everContributed) return GoalTrackStatus.noContributionHistory;
    final required = requiredMonthly ?? 0;
    if (required <= 0) return GoalTrackStatus.onTrack;
    if (avgMonthly >= required * GoalThresholds.aheadRatio) {
      return GoalTrackStatus.ahead;
    }
    if (avgMonthly < required * GoalThresholds.behindRatio) {
      return GoalTrackStatus.behind;
    }
    return GoalTrackStatus.onTrack;
  }

  /// Actual debt reduced on a debt-payoff goal's linked liability *since the
  /// goal was created* — real repayments only (via [TransactionSemantic]),
  /// never earmarking. Returns 0 for non-debt goals or when unlinked.
  static int actualDebtReducedMinor({
    required FinancialGoal goal,
    required List<Transaction> transactions,
    required Map<String, AccountClassification> accountClassifications,
  }) {
    if (goal.type != GoalType.debtPayoff) return 0;
    final liabilityId = goal.linkedLiabilityAccountId;
    if (liabilityId == null) return 0;
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted) continue;
      if (tx.date.isBefore(goal.createdAt)) continue;
      final semantic = TransactionSemanticClassifier.classify(
        type: tx.type,
        sourceClassification: accountClassifications[tx.accountId],
        destinationClassification:
            accountClassifications[tx.destinationAccountId],
      );
      if (semantic != TransactionSemantic.liabilityRepayment) continue;
      final reduces =
          (tx.type == TransactionType.transfer &&
              tx.destinationAccountId == liabilityId) ||
          (tx.type == TransactionType.income && tx.accountId == liabilityId);
      if (reduces) total += tx.amountMinor;
    }
    return total;
  }
}
