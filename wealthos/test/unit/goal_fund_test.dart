import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/goals/domain/goal_fund.dart';
import 'package:wealthos/features/goals/domain/goal_fund_entry.dart';
import 'package:wealthos/features/goals/domain/goal_insights.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';

final _t = DateTime(2026, 1, 1);
const _date = LocalDate(2026, 6, 1);

GoalFundEntry _entry(
  GoalFundEntryType type,
  int amount, {
  AdjustmentDirection? direction,
  bool deleted = false,
}) => GoalFundEntry(
  id: 'e-${type.name}-$amount-$deleted',
  goalId: 'g',
  type: type,
  amountMinor: amount,
  entryDate: _date,
  createdAt: _t,
  direction: direction,
  deletedAt: deleted ? _t : null,
);

void main() {
  group('fund balance from ledger', () {
    test('contributions add, withdrawals and transfers-out subtract', () {
      final entries = [
        _entry(GoalFundEntryType.contribution, 100000),
        _entry(GoalFundEntryType.transferIn, 50000),
        _entry(GoalFundEntryType.withdrawal, 20000),
        _entry(GoalFundEntryType.transferOut, 30000),
      ];
      expect(GoalFund.balanceFromEntries(entries), 100000);
    });

    test('adjustments respect their direction', () {
      final entries = [
        _entry(GoalFundEntryType.contribution, 100000),
        _entry(
          GoalFundEntryType.adjustment,
          15000,
          direction: AdjustmentDirection.increase,
        ),
        _entry(
          GoalFundEntryType.adjustment,
          5000,
          direction: AdjustmentDirection.decrease,
        ),
      ];
      expect(GoalFund.balanceFromEntries(entries), 110000);
    });

    test('soft-deleted entries contribute zero', () {
      final entries = [
        _entry(GoalFundEntryType.contribution, 100000),
        _entry(GoalFundEntryType.contribution, 40000, deleted: true),
      ];
      expect(GoalFund.balanceFromEntries(entries), 100000);
    });
  });

  group('insight builder', () {
    GoalInsightSnapshot snap({
      GoalType type = GoalType.custom,
      GoalTrackStatus track = GoalTrackStatus.onTrack,
      double ratio = 0.5,
      bool completed = false,
      bool overfunded = false,
      bool deadlineSoon = false,
      int? daysSince,
    }) => GoalInsightSnapshot(
      goalId: 'g',
      goalName: 'Trip',
      type: type,
      track: track,
      fundingRatio: ratio,
      isCompleted: completed,
      isOverfunded: overfunded,
      deadlineSoonWithLargeRemaining: deadlineSoon,
      daysSinceLastContribution: daysSince,
    );

    test('allocation shortfall surfaces once, globally', () {
      final insights = GoalInsightBuilder.build(
        goals: const [],
        allocationShortfall: true,
      );
      expect(
        insights.map((i) => i.type),
        contains(GoalInsightType.allocationShortfall),
      );
    });

    test('behind, near-completion, deadline-soon and stalled fire', () {
      final insights = GoalInsightBuilder.build(
        goals: [
          snap(
            track: GoalTrackStatus.behind,
            ratio: 0.95,
            deadlineSoon: true,
            daysSince: 60,
          ),
        ],
        allocationShortfall: false,
      );
      final types = insights.map((i) => i.type).toSet();
      expect(types, contains(GoalInsightType.behind));
      expect(types, contains(GoalInsightType.nearCompletion));
      expect(types, contains(GoalInsightType.deadlineSoon));
      expect(types, contains(GoalInsightType.stalled));
    });

    test('completed goal yields completed (+ overfunded) and nothing else', () {
      final insights = GoalInsightBuilder.build(
        goals: [snap(completed: true, overfunded: true, ratio: 1.2)],
        allocationShortfall: false,
      );
      final types = insights.map((i) => i.type).toSet();
      expect(types, contains(GoalInsightType.completed));
      expect(types, contains(GoalInsightType.overfunded));
      expect(types, isNot(contains(GoalInsightType.behind)));
    });

    test('emergency fund below target raises its own insight', () {
      final insights = GoalInsightBuilder.build(
        goals: [snap(type: GoalType.emergencyFund, ratio: 0.4)],
        allocationShortfall: false,
      );
      expect(
        insights.map((i) => i.type),
        contains(GoalInsightType.emergencyFundLow),
      );
    });
  });
}
