import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/transactions/domain/transaction.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';
import 'package:wealthos/features/transactions/presentation/transaction_details_page.dart';

import 'harness.dart';

void main() {
  final now = DateTime(2026, 7, 11);
  final account = Account(
    id: 'a',
    name: 'Emirates NBD',
    type: AccountType.bank,
    classification: AccountClassification.asset,
    currencyCode: 'AED',
    openingBalanceMinor: 100000,
    displayOrder: 0,
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );
  final tx = Transaction(
    id: 't1',
    type: TransactionType.expense,
    amountMinor: 25000,
    currencyCode: 'AED',
    date: now,
    accountId: 'a',
    note: 'Groceries',
    createdAt: now,
    updatedAt: now,
  );

  testWidgets('renders transaction details and the effect on the account', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      harness.wrap(
        const TransactionDetailsPage(transactionId: 't1'),
        accounts: [account],
        transactions: [tx],
        transactionsById: {'t1': tx},
      ),
    );
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.transactionTypeExpense), findsWidgets);
    expect(find.text('Emirates NBD'), findsWidgets);
    expect(find.text(l.transactionStatusActive), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
  });

  testWidgets('delete shows a confirmation dialog', (tester) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      harness.wrap(
        const TransactionDetailsPage(transactionId: 't1'),
        accounts: [account],
        transactions: [tx],
        transactionsById: {'t1': tx},
      ),
    );
    await pumpUntilStable(tester);

    final l = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.widgetWithText(OutlinedButton, l.commonDelete));
    await pumpUntilStable(tester);

    expect(find.text(l.transactionDeleteConfirm), findsOneWidget);
  });
}
