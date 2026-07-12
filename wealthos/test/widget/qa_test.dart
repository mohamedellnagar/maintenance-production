import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/goals/domain/financial_goal.dart';
import 'package:wealthos/features/goals/domain/goal_fund.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/goals/presentation/goals_home_page.dart';
import 'package:wealthos/features/settings/presentation/more_page.dart';

import 'harness.dart';

final _t = DateTime(2026, 1, 1);

// A goal with an intentionally long name and a large target, to stress layout.
FinancialGoal _bigGoal() => FinancialGoal(
  id: 'g',
  name: 'صندوق الطوارئ للعائلة الكبيرة جدًا والمصاريف الطارئة',
  type: GoalType.emergencyFund,
  targetAmountMinor: 1234567890,
  currencyCode: 'AED',
  priority: GoalPriority.critical,
  status: GoalStatus.active,
  targetDate: null,
  createdAt: _t,
  updatedAt: _t,
);

GoalFund _fund() => GoalFund(
  id: 'f',
  goalId: 'g',
  currentAllocatedMinor: 987654321,
  createdAt: _t,
  updatedAt: _t,
);

void main() {
  testWidgets('More tab exposes Recurring and Settings in Arabic', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(const MorePage(), locale: const Locale('ar')),
    );
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('ar'));
    expect(find.text(l.navRecurring), findsOneWidget);
    expect(find.text(l.navSettings), findsOneWidget);
  });

  testWidgets(
    'goals home renders in Arabic at 2.0 text scale without overflow',
    (tester) async {
      final harness = TestHarness();
      addTearDown(harness.dispose);
      await tester.pumpWidget(
        harness.wrap(
          const GoalsHomePage(),
          locale: const Locale('ar'),
          textScale: 2.0,
          goals: [_bigGoal()],
          goalFunds: [_fund()],
        ),
      );
      await pumpUntilStable(tester);

      // A RenderFlex overflow throws during layout and fails the test.
      expect(tester.takeException(), isNull);
      expect(find.byType(GoalsHomePage), findsOneWidget);
    },
  );

  testWidgets('goals home renders in dark mode', (tester) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const GoalsHomePage(),
        brightness: Brightness.dark,
        goals: [_bigGoal()],
        goalFunds: [_fund()],
      ),
    );
    await pumpUntilStable(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(GoalsHomePage), findsOneWidget);
  });

  testWidgets('goal card lays out in RTL with a long name and big amount', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const GoalsHomePage(),
        locale: const Locale('ar'),
        goals: [_bigGoal()],
        goalFunds: [_fund()],
      ),
    );
    await pumpUntilStable(tester);
    // Directionality resolves to RTL for Arabic.
    expect(
      Directionality.of(tester.element(find.byType(GoalsHomePage))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}
