import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/goals/domain/financial_goal.dart';
import 'package:wealthos/features/goals/domain/goal_fund_entry.dart';
import 'package:wealthos/features/goals/domain/goal_progress_calculator.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

final _t = DateTime(2026, 1, 1);
const _today = LocalDate(2026, 6, 15);

FinancialGoal _goal({
  int target = 120000,
  LocalDate? targetDate,
  GoalType type = GoalType.custom,
  String? liability,
  DateTime? createdAt,
}) => FinancialGoal(
  id: 'g',
  name: 'Goal',
  type: type,
  targetAmountMinor: target,
  currencyCode: 'AED',
  priority: GoalPriority.medium,
  status: GoalStatus.active,
  createdAt: createdAt ?? _t,
  updatedAt: _t,
  targetDate: targetDate,
  linkedLiabilityAccountId: liability,
);

GoalFundEntry _contribution(int amount, LocalDate date) => GoalFundEntry(
  id: 'c-$date-$amount',
  goalId: 'g',
  type: GoalFundEntryType.contribution,
  amountMinor: amount,
  entryDate: date,
  createdAt: _t,
);

void main() {
  group('funding figures', () {
    test('funded / remaining / ratio', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000),
        fundedMinor: 40000,
        entries: const [],
        today: _today,
      );
      expect(p.remainingMinor, 60000);
      expect(p.overfundedMinor, 0);
      expect(p.fundingRatio, closeTo(0.4, 0.0001));
      expect(p.isFunded, isFalse);
    });

    test('overfunded is reported and remaining floors at zero', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000),
        fundedMinor: 130000,
        entries: const [],
        today: _today,
      );
      expect(p.remainingMinor, 0);
      expect(p.overfundedMinor, 30000);
      expect(p.isOverfunded, isTrue);
      expect(p.isFunded, isTrue);
    });
  });

  group('required monthly', () {
    test('null without a target date', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(),
        fundedMinor: 0,
        entries: const [],
        today: _today,
      );
      expect(p.requiredMonthlyMinor, isNull);
    });

    test('remaining divided by whole months, rounded up', () {
      // remaining 90000 over 6 months = 15000/month.
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 120000, targetDate: const LocalDate(2026, 12, 15)),
        fundedMinor: 30000,
        entries: const [],
        today: _today,
      );
      expect(p.requiredMonthlyMinor, 15000);
    });

    test('a past/near target date clamps months to at least 1', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000, targetDate: const LocalDate(2026, 1, 1)),
        fundedMinor: 0,
        entries: const [],
        today: _today,
      );
      expect(p.requiredMonthlyMinor, 100000);
    });

    test('monthsRemaining counts whole calendar months', () {
      expect(
        GoalProgressCalculator.monthsRemaining(
          const LocalDate(2026, 6, 15),
          const LocalDate(2026, 12, 15),
        ),
        6,
      );
      // Target day before today's day → the partial month does not count.
      expect(
        GoalProgressCalculator.monthsRemaining(
          const LocalDate(2026, 6, 15),
          const LocalDate(2026, 12, 10),
        ),
        5,
      );
    });
  });

  group('projection', () {
    test('cannot estimate with no recent contributions', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000),
        fundedMinor: 10000,
        entries: const [],
        today: _today,
      );
      expect(p.projectedCompletion, isNull);
      expect(p.avgMonthlyContributionMinor, 0);
    });

    test('projects from the 3-month contribution average', () {
      final entries = [
        _contribution(30000, const LocalDate(2026, 4, 15)),
        _contribution(30000, const LocalDate(2026, 5, 15)),
        _contribution(30000, const LocalDate(2026, 6, 15)),
      ];
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 120000),
        fundedMinor: 30000, // remaining 90000, avg 30000/mo → 3 months
        entries: entries,
        today: _today,
      );
      expect(p.avgMonthlyContributionMinor, 30000);
      expect(p.projectedCompletion, const LocalDate(2026, 9, 15));
    });

    test('withdrawals and transfers do not count as contributions', () {
      final entries = [
        _contribution(30000, const LocalDate(2026, 6, 15)),
        GoalFundEntry(
          id: 'w',
          goalId: 'g',
          type: GoalFundEntryType.withdrawal,
          amountMinor: 90000,
          entryDate: const LocalDate(2026, 6, 15),
          createdAt: _t,
        ),
        GoalFundEntry(
          id: 'ti',
          goalId: 'g',
          type: GoalFundEntryType.transferIn,
          amountMinor: 90000,
          entryDate: const LocalDate(2026, 6, 15),
          createdAt: _t,
        ),
      ];
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 300000),
        fundedMinor: 30000,
        entries: entries,
        today: _today,
      );
      // Only the 30000 contribution over the 3-month window → 10000/mo.
      expect(p.avgMonthlyContributionMinor, 10000);
    });
  });

  group('on-track status', () {
    test('completed when funded', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000, targetDate: const LocalDate(2026, 12, 1)),
        fundedMinor: 100000,
        entries: const [],
        today: _today,
      );
      expect(p.trackStatus, GoalTrackStatus.completed);
    });

    test('noTargetDate without a deadline', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(),
        fundedMinor: 10000,
        entries: [_contribution(10000, const LocalDate(2026, 6, 1))],
        today: _today,
      );
      expect(p.trackStatus, GoalTrackStatus.noTargetDate);
    });

    test('noContributionHistory when nothing was ever contributed', () {
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 100000, targetDate: const LocalDate(2026, 12, 15)),
        fundedMinor: 0,
        entries: const [],
        today: _today,
      );
      expect(p.trackStatus, GoalTrackStatus.noContributionHistory);
    });

    test('ahead when averaging above the required rate', () {
      final entries = [
        _contribution(30000, const LocalDate(2026, 5, 15)),
        _contribution(30000, const LocalDate(2026, 6, 15)),
      ];
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 120000, targetDate: const LocalDate(2026, 12, 15)),
        fundedMinor: 30000, // required 15000/mo, avg 20000/mo
        entries: entries,
        today: _today,
      );
      expect(p.trackStatus, GoalTrackStatus.ahead);
    });

    test('behind when averaging below the required rate', () {
      final entries = [_contribution(3000, const LocalDate(2026, 6, 15))];
      final p = GoalProgressCalculator.compute(
        goal: _goal(target: 120000, targetDate: const LocalDate(2026, 12, 15)),
        fundedMinor: 30000, // required 15000/mo, avg 1000/mo
        entries: entries,
        today: _today,
      );
      expect(p.trackStatus, GoalTrackStatus.behind);
    });
  });

  group('debt reduction', () {
    Transaction repayment(String liabilityId, DateTime date) => Transaction(
      id: 't-$date',
      type: TransactionType.transfer,
      amountMinor: 20000,
      currencyCode: 'AED',
      date: date,
      accountId: 'asset',
      destinationAccountId: liabilityId,
      createdAt: _t,
      updatedAt: _t,
    );

    test('sums repayments toward the linked liability since goal creation', () {
      final goal = _goal(
        type: GoalType.debtPayoff,
        liability: 'loan',
        createdAt: DateTime(2026, 3, 1),
      );
      final classifications = {
        'asset': AccountClassification.asset,
        'loan': AccountClassification.liability,
      };
      final txs = [
        repayment('loan', DateTime(2026, 2, 1)), // before goal → excluded
        repayment('loan', DateTime(2026, 4, 1)),
        repayment('loan', DateTime(2026, 5, 1)),
      ];
      expect(
        GoalProgressCalculator.actualDebtReducedMinor(
          goal: goal,
          transactions: txs,
          accountClassifications: classifications,
        ),
        40000,
      );
    });

    test('returns 0 for non-debt goals', () {
      expect(
        GoalProgressCalculator.actualDebtReducedMinor(
          goal: _goal(),
          transactions: const [],
          accountClassifications: const {},
        ),
        0,
      );
    });
  });
}
