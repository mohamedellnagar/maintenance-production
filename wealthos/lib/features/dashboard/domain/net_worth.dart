import '../../../core/money/money.dart';
import '../../accounts/domain/account.dart';
import '../../accounts/domain/balance_calculator.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_type.dart';

/// Aggregated financial position shown on the dashboard.
class NetWorthSummary {
  const NetWorthSummary({
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
  });

  /// Sum of asset-account balances (normally positive).
  final Money totalAssets;

  /// Amount owed across liability accounts, expressed as a positive value.
  final Money totalLiabilities;

  /// [totalAssets] − [totalLiabilities].
  final Money netWorth;
}

/// Pure aggregation functions for the dashboard. Unit-tested.
abstract final class NetWorthCalculator {
  const NetWorthCalculator._();

  /// Computes assets, liabilities and net worth from live account/transaction
  /// data. Archived accounts are still counted toward net worth (they hold real
  /// money); callers may filter beforehand if a different policy is desired.
  static NetWorthSummary summarize(
    List<Account> accounts,
    List<Transaction> transactions, {
    required String currencyCode,
  }) {
    var totalAssets = 0;
    var totalLiabilities = 0;
    var netWorth = 0;
    for (final account in accounts) {
      final balance = BalanceCalculator.forAccount(account, transactions);
      // Net worth is the sum of signed net-worth contributions.
      netWorth += balance.netWorthContributionMinor;
      // Assets and liabilities are shown as their positive display amounts.
      if (account.isLiability) {
        totalLiabilities += balance.displayBalanceMinor;
      } else {
        totalAssets += balance.displayBalanceMinor;
      }
    }
    return NetWorthSummary(
      totalAssets: Money(amountMinor: totalAssets, currencyCode: currencyCode),
      totalLiabilities: Money(
        amountMinor: totalLiabilities,
        currencyCode: currencyCode,
      ),
      netWorth: Money(amountMinor: netWorth, currencyCode: currencyCode),
    );
  }

  /// Total income for the month containing [month], excluding transfers and
  /// adjustments. Only non-deleted transactions count.
  static Money monthlyIncome(
    List<Transaction> transactions, {
    required DateTime month,
    required String currencyCode,
  }) => _sumCashFlow(
    transactions,
    month: month,
    currencyCode: currencyCode,
    type: TransactionType.income,
  );

  /// Total expense for the month containing [month].
  static Money monthlyExpense(
    List<Transaction> transactions, {
    required DateTime month,
    required String currencyCode,
  }) => _sumCashFlow(
    transactions,
    month: month,
    currencyCode: currencyCode,
    type: TransactionType.expense,
  );

  static Money _sumCashFlow(
    List<Transaction> transactions, {
    required DateTime month,
    required String currencyCode,
    required TransactionType type,
  }) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != type) continue;
      if (tx.date.year == month.year && tx.date.month == month.month) {
        total += tx.amountMinor;
      }
    }
    return Money(amountMinor: total, currencyCode: currencyCode);
  }
}
