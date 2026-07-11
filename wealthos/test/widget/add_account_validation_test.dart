import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/accounts/presentation/add_account_page.dart';

import 'harness.dart';

void main() {
  testWidgets('add account shows a validation error for an empty name', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.wrap(const AddAccountPage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Submit with an empty name.
    await tester.tap(find.widgetWithText(FilledButton, l.commonSave));
    await pumpUntilStable(tester);

    expect(find.text(l.errorRequired), findsOneWidget);
  });
}
