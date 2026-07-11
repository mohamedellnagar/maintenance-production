import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_balance.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/dashboard/domain/net_worth.dart';
import 'package:wealthos/features/transactions/domain/adjustment_calculator.dart';
import 'package:wealthos/features/transactions/domain/transaction_semantic.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

const aed = 'AED';
final _now = DateTime(2026, 7, 11);

Account _account({
  required String id,
  AccountType type = AccountType.bank,
  AccountClassification classification = AccountClassification.asset,
  int opening = 0,
}) => Account(
  id: id,
  name: id,
  type: type,
  classification: classification,
  currencyCode: aed,
  openingBalanceMinor: opening,
  displayOrder: 0,
  isArchived: false,
  createdAt: _now,
  updatedAt: _now,
);

void main() {
  group('AccountBalance concepts', () {
    test('asset: display == signed == net-worth contribution', () {
      final balance = AccountBalance.fromSigned(_account(id: 'bank'), 1000000);
      expect(balance.signedBalanceMinor, 1000000);
      expect(balance.displayBalanceMinor, 1000000);
      expect(balance.netWorthContributionMinor, 1000000);
    });

    test('liability: display is positive debt, contribution is negative', () {
      final loan = _account(
        id: 'loan',
        type: AccountType.loan,
        classification: AccountClassification.liability,
      );
      final balance = AccountBalance.fromSigned(loan, -3000000);
      expect(balance.signedBalanceMinor, -3000000);
      expect(balance.displayBalanceMinor, 3000000); // outstanding, positive
      expect(balance.netWorthContributionMinor, -3000000);
    });
  });

  group('signed opening balance from user input', () {
    test('asset stores as entered', () {
      expect(
        AccountBalance.signedOpeningBalance(
          classification: AccountClassification.asset,
          enteredDisplayMinor: 500000,
        ),
        500000,
      );
    });

    test('liability stores as negative', () {
      expect(
        AccountBalance.signedOpeningBalance(
          classification: AccountClassification.liability,
          enteredDisplayMinor: 3000000,
        ),
        -3000000,
      );
    });
  });

  group('net worth with assets and liabilities (spec example)', () {
    test('Bank 10,000 + Loan owed 30,000 = net worth -20,000', () {
      final accounts = [
        _account(id: 'bank', opening: 1000000),
        _account(
          id: 'loan',
          type: AccountType.loan,
          classification: AccountClassification.liability,
          opening: -3000000,
        ),
      ];
      final summary = NetWorthCalculator.summarize(
        accounts,
        const [],
        currencyCode: aed,
      );
      expect(summary.totalAssets.amountMinor, 1000000);
      expect(summary.totalLiabilities.amountMinor, 3000000);
      expect(summary.netWorth.amountMinor, -2000000);
    });
  });

  group('AdjustmentCalculator', () {
    test('asset: actual below calculated gives a negative delta', () {
      expect(
        AdjustmentCalculator.delta(
          classification: AccountClassification.asset,
          actualDisplayMinor: 450000,
          calculatedSignedMinor: 500000,
        ),
        -50000,
      );
    });

    test(
      'liability: raising outstanding increases the debt (more negative)',
      () {
        // Calculated signed -300000 (owed 3,000). Actual owed 3,500.
        final delta = AdjustmentCalculator.delta(
          classification: AccountClassification.liability,
          actualDisplayMinor: 350000,
          calculatedSignedMinor: -300000,
        );
        expect(delta, -50000); // pushes signed to -350000
      },
    );

    test('no change gives zero delta', () {
      expect(
        AdjustmentCalculator.delta(
          classification: AccountClassification.asset,
          actualDisplayMinor: 500000,
          calculatedSignedMinor: 500000,
        ),
        0,
      );
    });
  });

  group('TransactionSemantic classification', () {
    test('expense on a liability is a charge', () {
      expect(
        TransactionSemanticClassifier.classify(
          type: TransactionType.expense,
          sourceClassification: AccountClassification.liability,
        ),
        TransactionSemantic.liabilityCharge,
      );
    });

    test('expense on an asset is a plain expense', () {
      expect(
        TransactionSemanticClassifier.classify(
          type: TransactionType.expense,
          sourceClassification: AccountClassification.asset,
        ),
        TransactionSemantic.expense,
      );
    });

    test('transfer asset → liability is a repayment', () {
      expect(
        TransactionSemanticClassifier.classify(
          type: TransactionType.transfer,
          sourceClassification: AccountClassification.asset,
          destinationClassification: AccountClassification.liability,
        ),
        TransactionSemantic.liabilityRepayment,
      );
    });

    test('transfer liability → asset is a draw-down', () {
      expect(
        TransactionSemanticClassifier.classify(
          type: TransactionType.transfer,
          sourceClassification: AccountClassification.liability,
          destinationClassification: AccountClassification.asset,
        ),
        TransactionSemantic.liabilityDrawdown,
      );
    });

    test('income into a liability is a repayment', () {
      expect(
        TransactionSemanticClassifier.classify(
          type: TransactionType.income,
          sourceClassification: AccountClassification.liability,
        ),
        TransactionSemantic.liabilityRepayment,
      );
    });
  });
}
