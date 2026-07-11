import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../domain/transaction.dart';

/// All non-deleted transactions, newest first. Backs balances and reports.
final allTransactionsProvider = StreamProvider<List<Transaction>>(
  (ref) => ref.watch(transactionsRepositoryProvider).watchAll(),
);

/// The most recent [count] transactions.
final recentTransactionsProvider =
    StreamProvider.family<List<Transaction>, int>(
      (ref, count) =>
          ref.watch(transactionsRepositoryProvider).watchAll(limit: count),
    );

/// Transactions touching a specific account.
final accountTransactionsProvider =
    StreamProvider.family<List<Transaction>, String>(
      (ref, accountId) =>
          ref.watch(transactionsRepositoryProvider).watchForAccount(accountId),
    );
