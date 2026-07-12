import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/local_date.dart';
import '../../accounts/data/accounts_repository.dart';
import '../../transactions/data/transactions_repository.dart';
import '../domain/financial_goal.dart';
import '../domain/goal_allocation_calculator.dart';
import '../domain/goal_fund.dart';
import '../domain/goal_fund_entry.dart';
import '../domain/goal_input.dart';
import '../domain/goal_type.dart';

/// Persists financial goals and their allocation funds. Fund balances are
/// derived from a ledger ([GoalFundEntriesTable]); `goal_funds` holds a cached
/// copy kept in sync inside every write transaction. Allocation never moves
/// real money — accounts stay the source of truth for actual funds.
class GoalsRepository {
  GoalsRepository(
    this._db,
    this._accounts,
    this._transactions, {
    Uuid? uuid,
    DateTime Function()? clock,
  }) : _uuid = uuid ?? const Uuid(),
       _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final AccountsRepository _accounts;
  final TransactionsRepository _transactions;
  final Uuid _uuid;
  final DateTime Function() _now;

  // --- goals ---

  Stream<List<FinancialGoal>> watchGoals({bool includeArchived = true}) {
    final query = _db.select(_db.financialGoalsTable)
      ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]);
    if (!includeArchived) {
      query.where((g) => g.status.equals('archived').not());
    }
    return query.watch().map((rows) => rows.map(_goalToDomain).toList());
  }

  Stream<FinancialGoal?> watchGoalById(String id) =>
      (_db.select(_db.financialGoalsTable)..where((g) => g.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _goalToDomain(row));

  Future<FinancialGoal?> getGoalById(String id) async {
    final row = await (_db.select(
      _db.financialGoalsTable,
    )..where((g) => g.id.equals(id))).getSingleOrNull();
    return row == null ? null : _goalToDomain(row);
  }

  Future<Result<FinancialGoal>> createGoal(
    GoalInput input, {
    int? initialAllocationMinor,
  }) async {
    final structural = GoalValidator.validate(input);
    if (structural != null) return Result.failure(structural);

    final id = _uuid.v4();
    final now = _now();
    try {
      await _db.transaction(() async {
        final ctx = await _validateGoalContext(input);
        if (ctx != null) throw _Failed(ctx);

        await _db
            .into(_db.financialGoalsTable)
            .insert(_goalCompanion(id: id, input: input, now: now));
        await _db
            .into(_db.goalFundsTable)
            .insert(
              GoalFundsTableCompanion.insert(
                id: _uuid.v4(),
                goalId: id,
                createdAt: now,
                updatedAt: now,
              ),
            );
        if (initialAllocationMinor != null && initialAllocationMinor > 0) {
          final failure = await _contribute(
            goalId: id,
            amountMinor: initialAllocationMinor,
            date: LocalDate.fromDateTime(now),
            note: null,
            linkedTransactionId: null,
          );
          if (failure != null) throw _Failed(failure);
        }
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await getGoalById(id))!);
  }

  Future<Result<FinancialGoal>> updateGoal(String id, GoalInput input) async {
    final structural = GoalValidator.validate(input);
    if (structural != null) return Result.failure(structural);
    try {
      await _db.transaction(() async {
        final existing = await getGoalById(id);
        if (existing == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.goalNotFound));
        }
        final ctx = await _validateGoalContext(input);
        if (ctx != null) throw _Failed(ctx);
        await (_db.update(
          _db.financialGoalsTable,
        )..where((g) => g.id.equals(id))).write(
          FinancialGoalsTableCompanion(
            name: Value(input.name.trim()),
            targetAmountMinor: Value(input.targetAmountMinor),
            targetDate: Value(input.targetDate?.epochDay),
            priority: Value(input.priority.name),
            linkedLiabilityAccountId: Value(input.linkedLiabilityAccountId),
            notes: Value(input.notes),
            updatedAt: Value(_now()),
          ),
        );
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await getGoalById(id))!);
  }

  Future<Result<void>> setStatus(String id, GoalStatus status) async {
    final now = _now();
    final companion = FinancialGoalsTableCompanion(
      status: Value(status.name),
      updatedAt: Value(now),
      completedAt: status == GoalStatus.completed
          ? Value(now)
          : const Value.absent(),
      cancelledAt: status == GoalStatus.cancelled
          ? Value(now)
          : const Value.absent(),
    );
    final updated = await (_db.update(
      _db.financialGoalsTable,
    )..where((g) => g.id.equals(id))).write(companion);
    if (updated == 0) {
      return const Result.failure(NotFoundFailure(FailureCodes.goalNotFound));
    }
    return const Result.success(null);
  }

  /// Hard-deletes a goal only when it has no fund ledger history.
  Future<Result<void>> deleteGoal(String id) async {
    try {
      await _db.transaction(() async {
        final entry =
            await (_db.select(_db.goalFundEntriesTable)
                  ..where((e) => e.goalId.equals(id))
                  ..limit(1))
                .getSingleOrNull();
        if (entry != null) {
          throw const _Failed(ValidationFailure(FailureCodes.goalHasLedger));
        }
        await (_db.delete(
          _db.goalFundsTable,
        )..where((f) => f.goalId.equals(id))).go();
        await (_db.delete(
          _db.financialGoalsTable,
        )..where((g) => g.id.equals(id))).go();
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return const Result.success(null);
  }

  // --- funds & ledger ---

  Stream<GoalFund?> watchFund(String goalId) =>
      (_db.select(_db.goalFundsTable)..where((f) => f.goalId.equals(goalId)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _fundToDomain(row));

  Future<GoalFund?> getFund(String goalId) async {
    final row = await (_db.select(
      _db.goalFundsTable,
    )..where((f) => f.goalId.equals(goalId))).getSingleOrNull();
    return row == null ? null : _fundToDomain(row);
  }

  Stream<List<GoalFund>> watchAllFunds() => _db
      .select(_db.goalFundsTable)
      .watch()
      .map((rows) => rows.map(_fundToDomain).toList());

  Stream<List<GoalFundEntry>> watchEntriesForGoal(String goalId) =>
      (_db.select(_db.goalFundEntriesTable)
            ..where((e) => e.goalId.equals(goalId))
            ..orderBy([(e) => OrderingTerm(expression: e.entryDate)]))
          .watch()
          .map((rows) => rows.map(_entryToDomain).toList());

  Stream<List<GoalFundEntry>> watchAllEntries() => _db
      .select(_db.goalFundEntriesTable)
      .watch()
      .map((rows) => rows.map(_entryToDomain).toList());

  Future<List<GoalFundEntry>> getEntriesForGoal(String goalId) async {
    final rows = await (_db.select(
      _db.goalFundEntriesTable,
    )..where((e) => e.goalId.equals(goalId))).get();
    return rows.map(_entryToDomain).toList();
  }

  /// Rebuilds a fund's cached balance from its ledger (source of truth).
  Future<void> recomputeFund(String goalId) async {
    final entries = await getEntriesForGoal(goalId);
    final balance = GoalFund.balanceFromEntries(entries);
    await (_db.update(
      _db.goalFundsTable,
    )..where((f) => f.goalId.equals(goalId))).write(
      GoalFundsTableCompanion(
        currentAllocatedMinor: Value(balance),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<Result<void>> contribute(
    String goalId,
    int amountMinor, {
    LocalDate? date,
    String? note,
    String? linkedTransactionId,
  }) => _run(() async {
    final goal = await getGoalById(goalId);
    if (goal == null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalNotFound));
    }
    if (!goal.status.acceptsContributions) {
      throw const _Failed(ValidationFailure(FailureCodes.goalNotActive));
    }
    final failure = await _contribute(
      goalId: goalId,
      amountMinor: amountMinor,
      date: date ?? LocalDate.fromDateTime(_now()),
      note: note,
      linkedTransactionId: linkedTransactionId,
    );
    if (failure != null) throw _Failed(failure);
  });

  Future<Result<void>> withdraw(
    String goalId,
    int amountMinor, {
    LocalDate? date,
    String? note,
  }) => _run(() async {
    if (amountMinor <= 0) {
      throw const _Failed(ValidationFailure(FailureCodes.goalAmountInvalid));
    }
    final fund = await getFund(goalId);
    if (fund == null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalNotFound));
    }
    if (amountMinor > fund.currentAllocatedMinor) {
      throw const _Failed(ValidationFailure(FailureCodes.goalInsufficientFund));
    }
    await _insertEntry(
      goalId: goalId,
      type: GoalFundEntryType.withdrawal,
      amountMinor: amountMinor,
      date: date ?? LocalDate.fromDateTime(_now()),
      note: note,
    );
    await _applyDelta(goalId, -amountMinor);
  });

  Future<Result<void>> transferBetweenGoals(
    String fromGoalId,
    String toGoalId,
    int amountMinor, {
    LocalDate? date,
    String? note,
  }) => _run(() async {
    if (amountMinor <= 0) {
      throw const _Failed(ValidationFailure(FailureCodes.goalAmountInvalid));
    }
    if (fromGoalId == toGoalId) {
      throw const _Failed(ValidationFailure(FailureCodes.goalSameTransfer));
    }
    final from = await getFund(fromGoalId);
    final to = await getGoalById(toGoalId);
    if (from == null || to == null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalNotFound));
    }
    if (amountMinor > from.currentAllocatedMinor) {
      throw const _Failed(ValidationFailure(FailureCodes.goalInsufficientFund));
    }
    final entryDate = date ?? LocalDate.fromDateTime(_now());
    await _insertEntry(
      goalId: fromGoalId,
      type: GoalFundEntryType.transferOut,
      amountMinor: amountMinor,
      date: entryDate,
      note: note,
      relatedGoalId: toGoalId,
    );
    await _insertEntry(
      goalId: toGoalId,
      type: GoalFundEntryType.transferIn,
      amountMinor: amountMinor,
      date: entryDate,
      note: note,
      relatedGoalId: fromGoalId,
    );
    await _applyDelta(fromGoalId, -amountMinor);
    await _applyDelta(toGoalId, amountMinor);
  });

  Future<Result<void>> adjust(
    String goalId,
    int amountMinor,
    AdjustmentDirection direction, {
    required String note,
    LocalDate? date,
  }) => _run(() async {
    if (amountMinor <= 0) {
      throw const _Failed(ValidationFailure(FailureCodes.goalAmountInvalid));
    }
    if (note.trim().isEmpty) {
      throw const _Failed(ValidationFailure(FailureCodes.required));
    }
    final fund = await getFund(goalId);
    if (fund == null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalNotFound));
    }
    final delta = direction == AdjustmentDirection.increase
        ? amountMinor
        : -amountMinor;
    if (fund.currentAllocatedMinor + delta < 0) {
      throw const _Failed(ValidationFailure(FailureCodes.goalInsufficientFund));
    }
    await _insertEntry(
      goalId: goalId,
      type: GoalFundEntryType.adjustment,
      amountMinor: amountMinor,
      date: date ?? LocalDate.fromDateTime(_now()),
      note: note.trim(),
      direction: direction,
    );
    await _applyDelta(goalId, delta);
  });

  Future<Result<void>> softDeleteEntry(String entryId) => _run(() async {
    final row = await _entryRow(entryId);
    if (row == null || row.deletedAt != null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalEntryNotFound));
    }
    final effect = _entryToDomain(row).signedEffectMinor;
    await (_db.update(_db.goalFundEntriesTable)
          ..where((e) => e.id.equals(entryId)))
        .write(GoalFundEntriesTableCompanion(deletedAt: Value(_now())));
    await _applyDelta(row.goalId, -effect);
  });

  Future<Result<void>> restoreEntry(String entryId) => _run(() async {
    final row = await _entryRow(entryId);
    if (row == null || row.deletedAt == null) {
      throw const _Failed(NotFoundFailure(FailureCodes.goalEntryNotFound));
    }
    await (_db.update(_db.goalFundEntriesTable)
          ..where((e) => e.id.equals(entryId)))
        .write(const GoalFundEntriesTableCompanion(deletedAt: Value(null)));
    // Recompute the signed effect as if live.
    final restored = _entryToDomain(row);
    final liveEffect = GoalFundEntry(
      id: restored.id,
      goalId: restored.goalId,
      type: restored.type,
      amountMinor: restored.amountMinor,
      entryDate: restored.entryDate,
      createdAt: restored.createdAt,
      direction: restored.direction,
    ).signedEffectMinor;
    await _applyDelta(row.goalId, liveEffect);
  });

  // --- internals ---

  /// Shared contribution path (also used by [createGoal] initial allocation).
  /// Returns a [Failure] to raise, or null on success. Must run inside a
  /// db transaction.
  Future<Failure?> _contribute({
    required String goalId,
    required int amountMinor,
    required LocalDate date,
    required String? note,
    required String? linkedTransactionId,
  }) async {
    if (amountMinor <= 0) {
      return const ValidationFailure(FailureCodes.goalAmountInvalid);
    }
    // Enforce that total allocation stays within eligible liquid assets.
    final eligible = await _eligibleLiquidMinor();
    final allocated = await _totalAllocatedMinor();
    if (allocated + amountMinor > eligible) {
      return const ValidationFailure(FailureCodes.goalExceedsAvailable);
    }
    if (linkedTransactionId != null) {
      final overAllocated = await _wouldOverAllocateTransaction(
        linkedTransactionId,
        amountMinor,
      );
      if (overAllocated) {
        return const ValidationFailure(
          FailureCodes.goalAllocationExceedsTransaction,
        );
      }
    }
    await _insertEntry(
      goalId: goalId,
      type: GoalFundEntryType.contribution,
      amountMinor: amountMinor,
      date: date,
      note: note,
      linkedTransactionId: linkedTransactionId,
    );
    if (linkedTransactionId != null) {
      await _db
          .into(_db.goalTransactionAllocationsTable)
          .insert(
            GoalTransactionAllocationsTableCompanion.insert(
              id: _uuid.v4(),
              goalId: goalId,
              transactionId: linkedTransactionId,
              amountMinor: amountMinor,
              createdAt: _now(),
            ),
          );
    }
    await _applyDelta(goalId, amountMinor);
    return null;
  }

  Future<void> _insertEntry({
    required String goalId,
    required GoalFundEntryType type,
    required int amountMinor,
    required LocalDate date,
    String? note,
    String? linkedTransactionId,
    String? relatedGoalId,
    AdjustmentDirection? direction,
  }) => _db
      .into(_db.goalFundEntriesTable)
      .insert(
        GoalFundEntriesTableCompanion.insert(
          id: _uuid.v4(),
          goalId: goalId,
          entryType: type.name,
          amountMinor: amountMinor,
          entryDate: date.epochDay,
          createdAt: _now(),
          direction: Value(direction?.name),
          note: Value(note),
          linkedTransactionId: Value(linkedTransactionId),
          relatedGoalId: Value(relatedGoalId),
        ),
      );

  Future<void> _applyDelta(String goalId, int deltaMinor) async {
    final fund = await getFund(goalId);
    if (fund == null) return;
    await (_db.update(
      _db.goalFundsTable,
    )..where((f) => f.goalId.equals(goalId))).write(
      GoalFundsTableCompanion(
        currentAllocatedMinor: Value(fund.currentAllocatedMinor + deltaMinor),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<int> _totalAllocatedMinor() async {
    final rows = await _db.select(_db.goalFundsTable).get();
    return rows.fold<int>(0, (sum, r) => sum + r.currentAllocatedMinor);
  }

  Future<int> _eligibleLiquidMinor() async {
    final accounts = await _accounts.getAll(includeArchived: true);
    final transactions = await _transactions.getAll();
    return GoalAllocationCalculator.eligibleLiquidAssetsMinor(
      accounts,
      transactions,
    );
  }

  Future<bool> _wouldOverAllocateTransaction(
    String transactionId,
    int newAmountMinor,
  ) async {
    final tx = await _transactions.getById(transactionId);
    if (tx == null) return false; // FK insert will fail loudly instead.
    final rows = await (_db.select(
      _db.goalTransactionAllocationsTable,
    )..where((a) => a.transactionId.equals(transactionId))).get();
    final already = rows.fold<int>(0, (sum, r) => sum + r.amountMinor);
    return already + newAmountMinor > tx.amountMinor;
  }

  Future<Failure?> _validateGoalContext(GoalInput input) async {
    final settings = await _db.managers.appSettingsTable.getSingleOrNull();
    final base = settings?.baseCurrency;
    if (base != null && input.currencyCode != base) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }
    final liabilityId = input.linkedLiabilityAccountId;
    if (liabilityId != null) {
      final account = await _accounts.getById(liabilityId);
      if (account == null) {
        return const NotFoundFailure(FailureCodes.accountNotFound);
      }
      if (account.isArchived) {
        return const ValidationFailure(FailureCodes.accountArchived);
      }
      if (!account.isLiability) {
        return const ValidationFailure(FailureCodes.goalNotLiability);
      }
      if (account.currencyCode != input.currencyCode) {
        return const ValidationFailure(FailureCodes.currencyMismatch);
      }
    }
    return null;
  }

  Future<GoalFundEntriesTableData?> _entryRow(String id) => (_db.select(
    _db.goalFundEntriesTable,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<Result<void>> _run(Future<void> Function() body) async {
    try {
      await _db.transaction(body);
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return const Result.success(null);
  }

  FinancialGoalsTableCompanion _goalCompanion({
    required String id,
    required GoalInput input,
    required DateTime now,
  }) => FinancialGoalsTableCompanion.insert(
    id: id,
    name: input.name.trim(),
    goalType: input.type.name,
    targetAmountMinor: input.targetAmountMinor,
    currencyCode: input.currencyCode,
    targetDate: Value(input.targetDate?.epochDay),
    priority: Value(input.priority.name),
    linkedLiabilityAccountId: Value(input.linkedLiabilityAccountId),
    notes: Value(input.notes),
    createdAt: now,
    updatedAt: now,
  );

  FinancialGoal _goalToDomain(FinancialGoalsTableData r) => FinancialGoal(
    id: r.id,
    name: r.name,
    type: GoalType.fromName(r.goalType),
    targetAmountMinor: r.targetAmountMinor,
    currencyCode: r.currencyCode,
    targetDate: r.targetDate == null
        ? null
        : LocalDate.fromEpochDay(r.targetDate!),
    priority: GoalPriority.fromName(r.priority),
    status: GoalStatus.fromName(r.status),
    linkedLiabilityAccountId: r.linkedLiabilityAccountId,
    notes: r.notes,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    completedAt: r.completedAt,
    cancelledAt: r.cancelledAt,
  );

  GoalFund _fundToDomain(GoalFundsTableData r) => GoalFund(
    id: r.id,
    goalId: r.goalId,
    currentAllocatedMinor: r.currentAllocatedMinor,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  GoalFundEntry _entryToDomain(GoalFundEntriesTableData r) => GoalFundEntry(
    id: r.id,
    goalId: r.goalId,
    type: GoalFundEntryType.fromName(r.entryType),
    direction: r.direction == null
        ? null
        : AdjustmentDirection.fromName(r.direction!),
    amountMinor: r.amountMinor,
    linkedTransactionId: r.linkedTransactionId,
    relatedGoalId: r.relatedGoalId,
    entryDate: LocalDate.fromEpochDay(r.entryDate),
    note: r.note,
    createdAt: r.createdAt,
    deletedAt: r.deletedAt,
  );
}

class _Failed implements Exception {
  const _Failed(this.failure);
  final Failure failure;
}
