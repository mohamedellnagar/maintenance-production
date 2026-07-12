import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/money/currency.dart';
import '../../../core/time/local_date.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/domain/account_type.dart';
import '../../settings/application/settings_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/financial_goal.dart';
import '../domain/goal_allocation_calculator.dart';
import '../domain/goal_fund.dart';
import '../domain/goal_fund_entry.dart';
import '../domain/goal_insights.dart';
import '../domain/goal_progress_calculator.dart';
import '../domain/goal_thresholds.dart';
import '../domain/goal_type.dart';

/// Today as a [LocalDate] (overridden in tests via [clockProvider]).
final goalsTodayProvider = Provider<LocalDate>(
  (ref) => ref.watch(clockProvider)(),
);

final baseCurrencyForGoalsProvider = Provider<String>(
  (ref) =>
      ref.watch(currentSettingsProvider)?.baseCurrency ??
      Currencies.defaultCurrency.code,
);

/// Reconciles every goal fund's cached balance with its ledger once per app
/// launch, so no screen ever reads a stale allocation. The ledger is the source
/// of truth; this only rewrites the cache when it drifted. Returns how many
/// funds were repaired.
final goalsIntegrityBootstrapProvider = FutureProvider<int>(
  (ref) => ref.read(goalsRepositoryProvider).repairAllFunds(),
);

final allGoalsProvider = StreamProvider<List<FinancialGoal>>(
  (ref) => ref.watch(goalsRepositoryProvider).watchGoals(),
);

final goalByIdProvider = StreamProvider.family<FinancialGoal?, String>(
  (ref, id) => ref.watch(goalsRepositoryProvider).watchGoalById(id),
);

final allFundsProvider = StreamProvider<List<GoalFund>>(
  (ref) => ref.watch(goalsRepositoryProvider).watchAllFunds(),
);

final allGoalEntriesProvider = StreamProvider<List<GoalFundEntry>>(
  (ref) => ref.watch(goalsRepositoryProvider).watchAllEntries(),
);

final goalEntriesProvider = StreamProvider.family<List<GoalFundEntry>, String>(
  (ref, goalId) =>
      ref.watch(goalsRepositoryProvider).watchEntriesForGoal(goalId),
);

/// Map of account id → classification (local, to avoid a budgets dependency).
final _classificationsProvider = Provider<Map<String, AccountClassification>>((
  ref,
) {
  final accounts = ref.watch(allAccountsProvider).value ?? const [];
  return {for (final a in accounts) a.id: a.classification};
});

/// Eligible liquid assets that can back goal allocations.
final eligibleLiquidAssetsProvider = Provider<int>((ref) {
  final accounts = ref.watch(allAccountsProvider).value ?? const [];
  final transactions = ref.watch(allTransactionsProvider).value ?? const [];
  return GoalAllocationCalculator.eligibleLiquidAssetsMinor(
    accounts,
    transactions,
  );
});

/// Total money earmarked across all goal funds.
final totalAllocatedProvider = Provider<int>((ref) {
  final funds = ref.watch(allFundsProvider).value ?? const [];
  return GoalAllocationCalculator.totalAllocatedMinor(
    funds.map((f) => f.currentAllocatedMinor),
  );
});

/// Liquid money not yet earmarked.
final unallocatedFundsProvider = Provider<int>(
  (ref) =>
      ref.watch(eligibleLiquidAssetsProvider) -
      ref.watch(totalAllocatedProvider),
);

/// Whether allocations now exceed eligible liquid assets, and by how much.
final allocationShortfallProvider = Provider<({bool has, int amountMinor})>((
  ref,
) {
  final eligible = ref.watch(eligibleLiquidAssetsProvider);
  final allocated = ref.watch(totalAllocatedProvider);
  return (
    has: GoalAllocationCalculator.hasShortfall(
      eligibleLiquidMinor: eligible,
      totalAllocatedMinor: allocated,
    ),
    amountMinor: GoalAllocationCalculator.shortfallMinor(
      eligibleLiquidMinor: eligible,
      totalAllocatedMinor: allocated,
    ),
  );
});

/// A goal joined with its fund balance, progress and (for debt goals) actual
/// debt reduced. Reacts to goals, funds, entries and transactions.
class GoalView {
  const GoalView({
    required this.goal,
    required this.fundedMinor,
    required this.progress,
    required this.actualDebtReducedMinor,
  });

  final FinancialGoal goal;
  final int fundedMinor;
  final GoalProgress progress;
  final int actualDebtReducedMinor;
}

final goalViewsProvider = Provider<List<GoalView>>((ref) {
  final goals = ref.watch(allGoalsProvider).value ?? const [];
  final funds = ref.watch(allFundsProvider).value ?? const [];
  final entries = ref.watch(allGoalEntriesProvider).value ?? const [];
  final transactions = ref.watch(allTransactionsProvider).value ?? const [];
  final classifications = ref.watch(_classificationsProvider);
  final today = ref.watch(goalsTodayProvider);

  final fundByGoal = {for (final f in funds) f.goalId: f.currentAllocatedMinor};
  final entriesByGoal = <String, List<GoalFundEntry>>{};
  for (final e in entries) {
    entriesByGoal.putIfAbsent(e.goalId, () => []).add(e);
  }

  return goals.map((goal) {
    final funded = fundByGoal[goal.id] ?? 0;
    final goalEntries = entriesByGoal[goal.id] ?? const <GoalFundEntry>[];
    final progress = GoalProgressCalculator.compute(
      goal: goal,
      fundedMinor: funded,
      entries: goalEntries,
      today: today,
    );
    final debtReduced = GoalProgressCalculator.actualDebtReducedMinor(
      goal: goal,
      transactions: transactions,
      accountClassifications: classifications,
    );
    return GoalView(
      goal: goal,
      fundedMinor: funded,
      progress: progress,
      actualDebtReducedMinor: debtReduced,
    );
  }).toList();
});

final goalViewByIdProvider = Provider.family<GoalView?, String>((ref, id) {
  for (final v in ref.watch(goalViewsProvider)) {
    if (v.goal.id == id) return v;
  }
  return null;
});

List<GoalView> _byStatus(List<GoalView> views, bool Function(GoalView) test) =>
    views.where(test).toList();

final activeGoalViewsProvider = Provider<List<GoalView>>(
  (ref) => _byStatus(
    ref.watch(goalViewsProvider),
    (v) => v.goal.status == GoalStatus.active,
  ),
);
final pausedGoalViewsProvider = Provider<List<GoalView>>(
  (ref) => _byStatus(
    ref.watch(goalViewsProvider),
    (v) => v.goal.status == GoalStatus.paused,
  ),
);
final completedGoalViewsProvider = Provider<List<GoalView>>(
  (ref) => _byStatus(
    ref.watch(goalViewsProvider),
    (v) => v.goal.status == GoalStatus.completed,
  ),
);
final archivedGoalViewsProvider = Provider<List<GoalView>>(
  (ref) => _byStatus(
    ref.watch(goalViewsProvider),
    (v) => v.goal.status == GoalStatus.archived,
  ),
);

/// Aggregated figures for the Goals summary + dashboard card.
class GoalsSummary {
  const GoalsSummary({
    required this.currencyCode,
    required this.totalTargetMinor,
    required this.totalAllocatedMinor,
    required this.totalRemainingMinor,
    required this.unallocatedMinor,
    required this.hasShortfall,
    required this.shortfallMinor,
    required this.activeCount,
    required this.behindCount,
    this.nearestGoal,
  });

  final String currencyCode;
  final int totalTargetMinor;
  final int totalAllocatedMinor;
  final int totalRemainingMinor;
  final int unallocatedMinor;
  final bool hasShortfall;
  final int shortfallMinor;
  final int activeCount;
  final int behindCount;
  final GoalView? nearestGoal;
}

final goalsSummaryProvider = Provider<GoalsSummary>((ref) {
  final views = ref.watch(goalViewsProvider);
  final currency = ref.watch(baseCurrencyForGoalsProvider);
  final active = views.where((v) => v.goal.status.countsInSummary).toList();
  final activeOnly = active
      .where((v) => v.goal.status == GoalStatus.active)
      .toList();
  final shortfall = ref.watch(allocationShortfallProvider);

  var totalTarget = 0;
  var totalRemaining = 0;
  for (final v in active) {
    totalTarget += v.goal.targetAmountMinor;
    totalRemaining += v.progress.remainingMinor;
  }
  final behind = active
      .where((v) => v.progress.trackStatus == GoalTrackStatus.behind)
      .length;

  // Nearest to completion: the active, not-yet-funded goal with the highest
  // funding ratio.
  GoalView? nearest;
  for (final v in activeOnly) {
    if (v.progress.isFunded) continue;
    if (nearest == null ||
        v.progress.fundingRatio > nearest.progress.fundingRatio) {
      nearest = v;
    }
  }

  return GoalsSummary(
    currencyCode: currency,
    totalTargetMinor: totalTarget,
    totalAllocatedMinor: ref.watch(totalAllocatedProvider),
    totalRemainingMinor: totalRemaining,
    unallocatedMinor: ref.watch(unallocatedFundsProvider),
    hasShortfall: shortfall.has,
    shortfallMinor: shortfall.amountMinor,
    activeCount: activeOnly.length,
    behindCount: behind,
    nearestGoal: nearest,
  );
});

/// In-app goals insights (shortfall, behind, near completion, completed,
/// stalled, deadline-soon, overfunded, emergency-fund low).
final goalInsightsProvider = Provider<List<GoalInsight>>((ref) {
  final views = ref.watch(goalViewsProvider);
  final today = ref.watch(goalsTodayProvider);
  final shortfall = ref.watch(allocationShortfallProvider).has;
  final entriesByGoal = <String, List<GoalFundEntry>>{};
  for (final e
      in ref.watch(allGoalEntriesProvider).value ?? const <GoalFundEntry>[]) {
    entriesByGoal.putIfAbsent(e.goalId, () => []).add(e);
  }

  final snapshots = views
      .where((v) => v.goal.status.countsInSummary || v.progress.isFunded)
      .map((v) {
        final goalEntries = entriesByGoal[v.goal.id] ?? const <GoalFundEntry>[];
        int? daysSince;
        for (final e in goalEntries) {
          if (e.isDeleted || e.type != GoalFundEntryType.contribution) {
            continue;
          }
          final days = today.epochDay - e.entryDate.epochDay;
          if (days >= 0 && (daysSince == null || days < daysSince)) {
            daysSince = days;
          }
        }
        final targetDate = v.goal.targetDate;
        final deadlineSoon =
            targetDate != null &&
            !v.progress.isFunded &&
            targetDate.epochDay - today.epochDay >= 0 &&
            targetDate.epochDay - today.epochDay <=
                GoalThresholds.deadlineSoonDays &&
            v.progress.remainingMinor > v.progress.fundedMinor;
        return GoalInsightSnapshot(
          goalId: v.goal.id,
          goalName: v.goal.name,
          type: v.goal.type,
          track: v.progress.trackStatus,
          fundingRatio: v.progress.fundingRatio,
          isCompleted:
              v.goal.status == GoalStatus.completed || v.progress.isFunded,
          isOverfunded: v.progress.isOverfunded,
          deadlineSoonWithLargeRemaining: deadlineSoon,
          daysSinceLastContribution: daysSince,
        );
      })
      .toList();

  return GoalInsightBuilder.build(
    goals: snapshots,
    allocationShortfall: shortfall,
  );
});

/// Contribution / withdrawal totals for a goal within a calendar month — used
/// by the Budget screen for a linked saving item.
class GoalMonthActivity {
  const GoalMonthActivity({
    required this.contributedMinor,
    required this.withdrawnMinor,
  });
  final int contributedMinor;
  final int withdrawnMinor;
}

final goalMonthActivityProvider =
    Provider.family<GoalMonthActivity, ({String goalId, int year, int month})>((
      ref,
      key,
    ) {
      final entries = ref.watch(allGoalEntriesProvider).value ?? const [];
      var contributed = 0;
      var withdrawn = 0;
      for (final e in entries) {
        if (e.isDeleted || e.goalId != key.goalId) continue;
        if (e.entryDate.year != key.year || e.entryDate.month != key.month) {
          continue;
        }
        if (e.type == GoalFundEntryType.contribution) {
          contributed += e.amountMinor;
        } else if (e.type == GoalFundEntryType.withdrawal) {
          withdrawn += e.amountMinor;
        }
      }
      return GoalMonthActivity(
        contributedMinor: contributed,
        withdrawnMinor: withdrawn,
      );
    });
