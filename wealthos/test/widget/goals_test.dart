import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/goals/domain/financial_goal.dart';
import 'package:wealthos/features/goals/domain/goal_fund.dart';
import 'package:wealthos/features/goals/domain/goal_type.dart';
import 'package:wealthos/features/goals/presentation/goal_form_page.dart';
import 'package:wealthos/features/goals/presentation/goals_home_page.dart';
import 'package:wealthos/features/goals/presentation/widgets/goals_summary_card.dart';

import 'harness.dart';

final _t = DateTime(2026, 1, 1);

FinancialGoal _goal() => FinancialGoal(
  id: 'g',
  name: 'Trip to Japan',
  type: GoalType.travel,
  targetAmountMinor: 400000,
  currencyCode: 'AED',
  priority: GoalPriority.medium,
  status: GoalStatus.active,
  createdAt: _t,
  updatedAt: _t,
);

GoalFund _fund() => GoalFund(
  id: 'f',
  goalId: 'g',
  currentAllocatedMinor: 100000,
  createdAt: _t,
  updatedAt: _t,
);

void main() {
  testWidgets('goals home shows an empty state with an add CTA', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(harness.wrap(const GoalsHomePage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.goalsEmptyTitle), findsOneWidget);
    expect(find.widgetWithText(FilledButton, l.goalAdd), findsWidgets);
  });

  testWidgets('goals home lists an active goal card', (tester) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const GoalsHomePage(),
        goals: [_goal()],
        goalFunds: [_fund()],
      ),
    );
    await pumpUntilStable(tester);

    expect(find.text('Trip to Japan'), findsOneWidget);
  });

  testWidgets('goal form surfaces validation errors on empty submit', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(harness.wrap(const GoalFormPage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    final save = find.widgetWithText(FilledButton, l.commonSave);
    await tester.scrollUntilVisible(
      save,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(save);
    await pumpUntilStable(tester);
    await tester.tap(save);
    await pumpUntilStable(tester);

    // Name and target amount are both required.
    expect(find.text(l.errorRequired), findsWidgets);
  });

  testWidgets('dashboard goals card is hidden when there are no goals', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(const Scaffold(body: GoalsSummaryCard())),
    );
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.dashboardGoals), findsNothing);
  });
}
