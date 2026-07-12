import '../../accounts/domain/account.dart';
import '../../accounts/domain/account_type.dart';
import '../../accounts/domain/balance_calculator.dart';
import '../../transactions/domain/transaction.dart';

/// Pure math for how much of the user's *real* money can be earmarked for
/// goals, and whether current allocations exceed it (an Allocation Shortfall).
///
/// Allocation is a **virtual earmark**: it never moves or reserves money at the
/// bank. The conservative V1 rule counts only positive balances of liquid
/// account types.
abstract final class GoalAllocationCalculator {
  const GoalAllocationCalculator._();

  /// Account types whose positive balance is considered "liquid" and eligible
  /// to back goal allocations. Excludes credit cards, loans, investments,
  /// fixed assets and the free-form `other` type by default.
  static const Set<AccountType> eligibleTypes = {
    AccountType.cash,
    AccountType.bank,
    AccountType.wallet,
  };

  /// Sum of the positive signed balances of non-archived eligible accounts.
  static int eligibleLiquidAssetsMinor(
    List<Account> accounts,
    List<Transaction> transactions,
  ) {
    var total = 0;
    for (final account in accounts) {
      if (account.isArchived) continue;
      if (!eligibleTypes.contains(account.type)) continue;
      final signed = BalanceCalculator.signedBalanceMinor(
        account,
        transactions,
      );
      if (signed > 0) total += signed;
    }
    return total;
  }

  /// Total money earmarked across all goal funds.
  static int totalAllocatedMinor(Iterable<int> fundBalances) =>
      fundBalances.fold(0, (sum, balance) => sum + balance);

  /// Liquid money not yet earmarked (may be negative → shortfall).
  static int availableForAllocationMinor({
    required int eligibleLiquidMinor,
    required int totalAllocatedMinor,
  }) => eligibleLiquidMinor - totalAllocatedMinor;

  /// Whether allocations now exceed eligible liquid assets.
  static bool hasShortfall({
    required int eligibleLiquidMinor,
    required int totalAllocatedMinor,
  }) => totalAllocatedMinor > eligibleLiquidMinor;

  /// The amount by which allocations exceed eligible liquid assets (>= 0).
  static int shortfallMinor({
    required int eligibleLiquidMinor,
    required int totalAllocatedMinor,
  }) {
    final gap = totalAllocatedMinor - eligibleLiquidMinor;
    return gap > 0 ? gap : 0;
  }
}
