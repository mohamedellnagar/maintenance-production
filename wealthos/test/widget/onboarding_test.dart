import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/onboarding/presentation/onboarding_page.dart';

import 'harness.dart';

void main() {
  testWidgets('onboarding shows the language step first and advances', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      harness.wrap(const OnboardingPage(), withRealDatabase: true),
    );
    await tester.pumpAndSettle();

    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Step 1: language.
    expect(find.text(l.onboardingLanguageTitle), findsOneWidget);

    // Advance to the currency step.
    await tester.tap(find.widgetWithText(FilledButton, l.commonNext));
    await tester.pumpAndSettle();
    expect(find.text(l.onboardingCurrencyTitle), findsOneWidget);

    // Advance to the account step.
    await tester.tap(find.widgetWithText(FilledButton, l.commonNext));
    await tester.pumpAndSettle();
    expect(find.text(l.onboardingAccountTitle), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, l.onboardingFinish),
      findsOneWidget,
    );
  });
}
