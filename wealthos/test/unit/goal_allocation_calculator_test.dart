import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/features/accounts/domain/account.dart';
import 'package:wealthos/features/accounts/domain/account_type.dart';
import 'package:wealthos/features/goals/domain/goal_allocation_calculator.dart';

final _t = DateTime(2026, 1, 1);

Account _account({
  required AccountType type,
  required int opening,
  bool archived = false,
  AccountClassification? classification,
}) => Account(
  id: 'a-${type.name}-$opening',
  name: type.name,
  type: type,
  classification: classification ?? type.defaultClassification,
  currencyCode: 'AED',
  openingBalanceMinor: opening,
  displayOrder: 0,
  isArchived: archived,
  createdAt: _t,
  updatedAt: _t,
);

void main() {
  group('eligible liquid assets', () {
    test('counts positive cash/bank/wallet balances only', () {
      final accounts = [
        _account(type: AccountType.cash, opening: 100000),
        _account(type: AccountType.bank, opening: 250000),
        _account(type: AccountType.wallet, opening: 50000),
      ];
      expect(
        GoalAllocationCalculator.eligibleLiquidAssetsMinor(accounts, const []),
        400000,
      );
    });

    test(
      'excludes liabilities, investments, property and archived accounts',
      () {
        final accounts = [
          _account(type: AccountType.cash, opening: 100000),
          _account(type: AccountType.creditCard, opening: -30000),
          _account(type: AccountType.loan, opening: -500000),
          _account(type: AccountType.investment, opening: 999999),
          _account(type: AccountType.asset, opening: 999999),
          _account(type: AccountType.bank, opening: 80000, archived: true),
        ];
        expect(
          GoalAllocationCalculator.eligibleLiquidAssetsMinor(
            accounts,
            const [],
          ),
          100000,
        );
      },
    );

    test('ignores negative (overdrawn) eligible balances', () {
      final accounts = [
        _account(type: AccountType.bank, opening: -20000),
        _account(type: AccountType.cash, opening: 30000),
      ];
      expect(
        GoalAllocationCalculator.eligibleLiquidAssetsMinor(accounts, const []),
        30000,
      );
    });
  });

  group('allocation math', () {
    test('total allocated sums fund balances', () {
      expect(
        GoalAllocationCalculator.totalAllocatedMinor([100, 200, 300]),
        600,
      );
    });

    test('available = eligible - allocated', () {
      expect(
        GoalAllocationCalculator.availableForAllocationMinor(
          eligibleLiquidMinor: 1000,
          totalAllocatedMinor: 400,
        ),
        600,
      );
    });

    test('shortfall fires when allocations exceed eligible liquid', () {
      expect(
        GoalAllocationCalculator.hasShortfall(
          eligibleLiquidMinor: 500,
          totalAllocatedMinor: 700,
        ),
        isTrue,
      );
      expect(
        GoalAllocationCalculator.shortfallMinor(
          eligibleLiquidMinor: 500,
          totalAllocatedMinor: 700,
        ),
        200,
      );
    });

    test('no shortfall when within budget', () {
      expect(
        GoalAllocationCalculator.hasShortfall(
          eligibleLiquidMinor: 500,
          totalAllocatedMinor: 500,
        ),
        isFalse,
      );
      expect(
        GoalAllocationCalculator.shortfallMinor(
          eligibleLiquidMinor: 500,
          totalAllocatedMinor: 300,
        ),
        0,
      );
    });
  });
}
