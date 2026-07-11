import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/money/money.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/account.dart';
import '../domain/balance_calculator.dart';

/// All non-archived accounts, live.
final accountsProvider = StreamProvider<List<Account>>(
  (ref) => ref.watch(accountsRepositoryProvider).watchAll(),
);

/// All accounts including archived — used for net-worth math.
final allAccountsProvider = StreamProvider<List<Account>>(
  (ref) =>
      ref.watch(accountsRepositoryProvider).watchAll(includeArchived: true),
);

/// A single account by id.
final accountByIdProvider = FutureProvider.family<Account?, String>(
  (ref, id) => ref.watch(accountsRepositoryProvider).getById(id),
);

/// Live balance of one account, derived from opening balance + transactions.
final accountBalanceProvider = Provider.family<Money?, Account>((ref, account) {
  final transactions = ref.watch(allTransactionsProvider).value;
  if (transactions == null) return null;
  return BalanceCalculator.balanceOf(account, transactions);
});
