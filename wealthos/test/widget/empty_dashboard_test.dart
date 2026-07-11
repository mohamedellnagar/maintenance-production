import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/dashboard/presentation/dashboard_page.dart';

import 'harness.dart';

void main() {
  testWidgets('dashboard shows a professional empty state with no data', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.wrap(const DashboardPage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.dashboardEmptyTitle), findsOneWidget);
    expect(find.text(l.dashboardEmptyMessage), findsOneWidget);
  });
}
