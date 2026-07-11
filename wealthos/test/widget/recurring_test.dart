import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/recurring/presentation/recurring_home_page.dart';
import 'package:wealthos/features/recurring/presentation/recurring_rule_form_page.dart';
import 'package:wealthos/features/recurring/presentation/widgets/upcoming_bills_card.dart';

import 'harness.dart';

void main() {
  testWidgets('recurring home shows an empty state with an add CTA', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(harness.wrap(const RecurringHomePage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.recurringEmptyTitle), findsOneWidget);
    expect(find.widgetWithText(FilledButton, l.recurringAddRule), findsWidgets);
  });

  testWidgets('rule form surfaces validation errors on empty submit', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(harness.wrap(const RecurringRuleFormPage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    final saveButton = find.widgetWithText(FilledButton, l.commonSave);
    await tester.scrollUntilVisible(
      saveButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await pumpUntilStable(tester);

    // Name, amount and monthly-day fields all require input.
    expect(find.text(l.errorRequired), findsWidgets);
  });

  testWidgets('upcoming bills card is hidden when there is no recurring data', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(const Scaffold(body: UpcomingBillsCard())),
    );
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.dashboardUpcomingBills), findsNothing);
  });
}
