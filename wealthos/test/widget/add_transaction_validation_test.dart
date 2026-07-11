import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/transactions/presentation/add_transaction_page.dart';

import 'harness.dart';

void main() {
  testWidgets('add transaction requires an amount and an account', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.wrap(const AddTransactionPage()));
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Submit the empty form.
    await tester.tap(find.widgetWithText(FilledButton, l.commonSave));
    await pumpUntilStable(tester);

    // Amount is required, and (with no accounts) an account must be chosen.
    expect(find.text(l.errorRequired), findsWidgets);
    expect(find.text(l.errorAccountRequired), findsOneWidget);
  });
}
