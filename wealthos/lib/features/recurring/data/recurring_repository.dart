import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/local_date.dart';
import '../../transactions/data/transactions_repository.dart';
import '../../transactions/domain/new_transaction_input.dart';
import '../../transactions/domain/transaction_type.dart';
import '../domain/recurrence_calculator.dart';
import '../domain/recurring_occurrence.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_rule_input.dart';
import '../domain/recurring_type.dart';

/// Optional overrides supplied when posting an occurrence (edit-before-posting).
class PostOverrides {
  const PostOverrides({this.amountMinor, this.date, this.note});
  final int? amountMinor;
  final LocalDate? date;
  final String? note;
}

/// Persists recurring rules, weekdays and occurrences, generates occurrences
/// idempotently, and posts them into real transactions atomically.
class RecurringRepository {
  RecurringRepository(
    this._db,
    this._transactions, {
    Uuid? uuid,
    DateTime Function()? clock,
  }) : _uuid = uuid ?? const Uuid(),
       _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final TransactionsRepository _transactions;
  final Uuid _uuid;
  final DateTime Function() _now;

  // --- rules ---

  Stream<List<RecurringRule>> watchRules({bool activeOnly = false}) {
    final query = _db.select(_db.recurringRulesTable)
      ..orderBy([(r) => OrderingTerm(expression: r.name)]);
    if (activeOnly) query.where((r) => r.isActive.equals(true));
    return query.watch().asyncMap(_withWeekdays);
  }

  Stream<RecurringRule?> watchRuleById(String id) =>
      (_db.select(_db.recurringRulesTable)..where((r) => r.id.equals(id)))
          .watchSingleOrNull()
          .asyncMap((row) async {
            if (row == null) return null;
            final wd = await _weekdaysFor([row.id]);
            return _ruleToDomain(row, wd[row.id] ?? const <int>{});
          });

  Future<RecurringRule?> getRuleById(String id) async {
    final row = await (_db.select(
      _db.recurringRulesTable,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final wd = await _weekdaysFor([row.id]);
    return _ruleToDomain(row, wd[row.id] ?? const <int>{});
  }

  Future<List<RecurringRule>> getActiveRules() async {
    final rows = await (_db.select(
      _db.recurringRulesTable,
    )..where((r) => r.isActive.equals(true))).get();
    return _withWeekdays(rows);
  }

  Future<Result<RecurringRule>> createRule(RecurringRuleInput input) async {
    final structural = RecurringRuleValidator.validate(input);
    if (structural != null) return Result.failure(structural);

    final id = _uuid.v4();
    final now = _now();
    try {
      await _db.transaction(() async {
        final ctx = await _validateRuleContext(input);
        if (ctx != null) throw _Failed(ctx);
        await _db
            .into(_db.recurringRulesTable)
            .insert(_ruleCompanion(id: id, input: input, now: now));
        await _writeWeekdays(id, input.weekdays);
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await getRuleById(id))!);
  }

  /// Updates a rule. When the schedule changes, future unposted occurrences are
  /// removed and `last_generated_through` is reset so the caller can regenerate.
  /// When only the amount changes, future unposted occurrences are repriced.
  Future<Result<RecurringRule>> updateRule(
    String id,
    RecurringRuleInput input, {
    required LocalDate today,
  }) async {
    final structural = RecurringRuleValidator.validate(input);
    if (structural != null) return Result.failure(structural);
    try {
      await _db.transaction(() async {
        final existing = await getRuleById(id);
        if (existing == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.ruleNotFound));
        }
        final ctx = await _validateRuleContext(input);
        if (ctx != null) throw _Failed(ctx);

        final scheduleChanged = _scheduleChanged(existing, input);
        await (_db.update(
          _db.recurringRulesTable,
        )..where((r) => r.id.equals(id))).write(
          _ruleUpdateCompanion(
            input: input,
            now: _now(),
            resetGeneration: scheduleChanged,
          ),
        );
        await _writeWeekdays(id, input.weekdays);

        if (scheduleChanged) {
          // Drop future, untouched occurrences; regeneration recreates them.
          await (_db.delete(_db.recurringOccurrencesTable)..where(
                (o) =>
                    o.recurringRuleId.equals(id) &
                    o.status.equals('scheduled') &
                    o.generatedTransactionId.isNull() &
                    o.dueDate.isBiggerOrEqualValue(today.epochDay),
              ))
              .go();
        } else if (existing.amountMinor != input.amountMinor) {
          await (_db.update(_db.recurringOccurrencesTable)..where(
                (o) =>
                    o.recurringRuleId.equals(id) &
                    o.status.equals('scheduled') &
                    o.dueDate.isBiggerOrEqualValue(today.epochDay),
              ))
              .write(
                RecurringOccurrencesTableCompanion(
                  expectedAmountMinor: Value(input.amountMinor),
                  updatedAt: Value(_now()),
                ),
              );
        }
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return Result.success((await getRuleById(id))!);
  }

  Future<Result<void>> setActive(String id, {required bool active}) async {
    final updated =
        await (_db.update(
          _db.recurringRulesTable,
        )..where((r) => r.id.equals(id))).write(
          RecurringRulesTableCompanion(
            isActive: Value(active),
            updatedAt: Value(_now()),
          ),
        );
    if (updated == 0) {
      return const Result.failure(NotFoundFailure(FailureCodes.ruleNotFound));
    }
    return const Result.success(null);
  }

  Future<Result<void>> endRule(String id, {required LocalDate endDate}) async {
    final updated =
        await (_db.update(
          _db.recurringRulesTable,
        )..where((r) => r.id.equals(id))).write(
          RecurringRulesTableCompanion(
            isActive: const Value(false),
            endDate: Value(endDate.epochDay),
            updatedAt: Value(_now()),
          ),
        );
    if (updated == 0) {
      return const Result.failure(NotFoundFailure(FailureCodes.ruleNotFound));
    }
    // Cancelling future untouched occurrences keeps the list tidy.
    await (_db.delete(_db.recurringOccurrencesTable)..where(
          (o) =>
              o.recurringRuleId.equals(id) &
              o.status.equals('scheduled') &
              o.dueDate.isBiggerThanValue(endDate.epochDay),
        ))
        .go();
    return const Result.success(null);
  }

  /// Hard-deletes a rule only if it has no posted history; otherwise callers
  /// should end it instead.
  Future<Result<void>> deleteRule(String id) async {
    try {
      await _db.transaction(() async {
        final posted =
            await (_db.select(_db.recurringOccurrencesTable)..where(
                  (o) =>
                      o.recurringRuleId.equals(id) &
                      o.generatedTransactionId.isNotNull(),
                ))
                .getSingleOrNull();
        if (posted != null) {
          throw const _Failed(
            ValidationFailure(FailureCodes.occurrenceAlreadyPosted),
          );
        }
        await (_db.delete(
          _db.recurringOccurrencesTable,
        )..where((o) => o.recurringRuleId.equals(id))).go();
        await (_db.delete(
          _db.recurringRuleWeekdaysTable,
        )..where((w) => w.recurringRuleId.equals(id))).go();
        await (_db.delete(
          _db.recurringRulesTable,
        )..where((r) => r.id.equals(id))).go();
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return const Result.success(null);
  }

  // --- occurrences ---

  Stream<List<RecurringOccurrence>> watchOccurrences() =>
      (_db.select(_db.recurringOccurrencesTable)
            ..orderBy([(o) => OrderingTerm(expression: o.dueDate)]))
          .watch()
          .map((rows) => rows.map(_occurrenceToDomain).toList());

  Stream<List<RecurringOccurrence>> watchOccurrencesForRule(String ruleId) =>
      (_db.select(_db.recurringOccurrencesTable)
            ..where((o) => o.recurringRuleId.equals(ruleId))
            ..orderBy([(o) => OrderingTerm(expression: o.dueDate)]))
          .watch()
          .map((rows) => rows.map(_occurrenceToDomain).toList());

  Stream<RecurringOccurrence?> watchOccurrenceById(String id) =>
      (_db.select(_db.recurringOccurrencesTable)..where((o) => o.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _occurrenceToDomain(row));

  Future<RecurringOccurrence?> getOccurrenceById(String id) async {
    final row = await (_db.select(
      _db.recurringOccurrencesTable,
    )..where((o) => o.id.equals(id))).getSingleOrNull();
    return row == null ? null : _occurrenceToDomain(row);
  }

  /// Scheduled occurrences whose effective due date is on or before [today]
  /// (candidates for auto-create).
  Future<List<RecurringOccurrence>> getOpenDueOccurrences(
    LocalDate today,
  ) async {
    final rows =
        await (_db.select(_db.recurringOccurrencesTable)
              ..where(
                (o) =>
                    o.status.equals('scheduled') &
                    o.dueDate.isSmallerOrEqualValue(today.epochDay),
              )
              ..orderBy([(o) => OrderingTerm(expression: o.dueDate)]))
            .get();
    return rows.map(_occurrenceToDomain).toList();
  }

  /// Inserts the occurrences of [rule] in `[from, to]`. Idempotent: the unique
  /// `(rule, original_due_date)` constraint drops duplicates via insert-or-ignore.
  Future<void> generateForRule(
    RecurringRule rule,
    LocalDate from,
    LocalDate to,
  ) async {
    final dates = RecurrenceCalculator.occurrences(
      pattern: rule.pattern,
      start: rule.startDate,
      from: from,
      to: to,
      endDate: rule.endDate,
      maxOccurrences: rule.maxOccurrences,
    );
    final now = _now();
    await _db.transaction(() async {
      await _db.batch((batch) {
        for (final date in dates) {
          batch.insert(
            _db.recurringOccurrencesTable,
            RecurringOccurrencesTableCompanion.insert(
              id: _uuid.v4(),
              recurringRuleId: rule.id,
              dueDate: date.epochDay,
              originalDueDate: date.epochDay,
              expectedAmountMinor: rule.amountMinor,
              createdAt: now,
              updatedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });
      await (_db.update(
        _db.recurringRulesTable,
      )..where((r) => r.id.equals(rule.id))).write(
        RecurringRulesTableCompanion(
          lastGeneratedThrough: Value(to.epochDay),
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Posts an occurrence into a real transaction and marks it paid — atomically,
  /// with a double-post guard.
  Future<Result<void>> postOccurrence(
    String occurrenceId, {
    PostOverrides overrides = const PostOverrides(),
  }) async {
    try {
      await _db.transaction(() async {
        final occRow = await (_db.select(
          _db.recurringOccurrencesTable,
        )..where((o) => o.id.equals(occurrenceId))).getSingleOrNull();
        if (occRow == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.occurrenceNotFound));
        }
        final occurrence = _occurrenceToDomain(occRow);
        if (occurrence.status == OccurrenceStatus.skipped ||
            occurrence.status == OccurrenceStatus.cancelled) {
          throw const _Failed(
            ValidationFailure(FailureCodes.occurrenceNotOpen),
          );
        }
        // Already posted and the transaction is still alive → refuse.
        if (occurrence.generatedTransactionId != null) {
          final linked =
              await (_db.select(_db.transactionsTable)..where(
                    (t) => t.id.equals(occurrence.generatedTransactionId!),
                  ))
                  .getSingleOrNull();
          if (linked != null && linked.deletedAt == null) {
            throw const _Failed(
              ValidationFailure(FailureCodes.occurrenceAlreadyPosted),
            );
          }
        }

        final rule = await getRuleById(occurrence.ruleId);
        if (rule == null) {
          throw const _Failed(NotFoundFailure(FailureCodes.ruleNotFound));
        }
        final input = _transactionInput(rule, occurrence, overrides);
        final result = await _transactions.create(input);
        final txId = result.fold((tx) => tx.id, (f) => throw _Failed(f));

        await (_db.update(
          _db.recurringOccurrencesTable,
        )..where((o) => o.id.equals(occurrenceId))).write(
          RecurringOccurrencesTableCompanion(
            status: const Value('paid'),
            generatedTransactionId: Value(txId),
            completedAt: Value(_now()),
            updatedAt: Value(_now()),
          ),
        );
      });
    } on _Failed catch (e) {
      return Result.failure(e.failure);
    }
    return const Result.success(null);
  }

  Future<Result<void>> snooze(String occurrenceId, LocalDate until) async {
    final updated =
        await (_db.update(
          _db.recurringOccurrencesTable,
        )..where((o) => o.id.equals(occurrenceId))).write(
          RecurringOccurrencesTableCompanion(
            snoozedUntil: Value(until.epochDay),
            dueDate: Value(until.epochDay),
            updatedAt: Value(_now()),
          ),
        );
    if (updated == 0) {
      return const Result.failure(
        NotFoundFailure(FailureCodes.occurrenceNotFound),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> skip(String occurrenceId, {String? reason}) async {
    final now = _now();
    final updated =
        await (_db.update(
          _db.recurringOccurrencesTable,
        )..where((o) => o.id.equals(occurrenceId))).write(
          RecurringOccurrencesTableCompanion(
            status: const Value('skipped'),
            skippedAt: Value(now),
            skipReason: Value(reason),
            updatedAt: Value(now),
          ),
        );
    if (updated == 0) {
      return const Result.failure(
        NotFoundFailure(FailureCodes.occurrenceNotFound),
      );
    }
    return const Result.success(null);
  }

  // --- internals ---

  bool _scheduleChanged(RecurringRule a, RecurringRuleInput b) =>
      a.frequency != b.frequency ||
      a.intervalValue != b.intervalValue ||
      !_setEquals(a.weekdays, b.weekdays) ||
      a.monthlyDay != b.monthlyDay ||
      a.monthlyWeekOrdinal != b.monthlyWeekOrdinal ||
      a.monthlyWeekday != b.monthlyWeekday ||
      a.yearlyMonth != b.yearlyMonth ||
      a.yearlyDay != b.yearlyDay ||
      a.startDate != b.startDate ||
      a.endDate != b.endDate ||
      a.maxOccurrences != b.maxOccurrences;

  bool _setEquals(Set<int> a, Set<int> b) =>
      a.length == b.length && a.every(b.contains);

  NewTransactionInput _transactionInput(
    RecurringRule rule,
    RecurringOccurrence occurrence,
    PostOverrides overrides,
  ) {
    final amount = overrides.amountMinor ?? occurrence.expectedAmountMinor;
    final date = (overrides.date ?? occurrence.effectiveDueDate).toDateTime();
    switch (rule.type) {
      case RecurringType.income:
        return NewTransactionInput(
          type: TransactionType.income,
          amountMinor: amount,
          currencyCode: rule.currencyCode,
          date: date,
          accountId: rule.accountId,
          categoryId: rule.categoryId,
          note: overrides.note ?? rule.name,
        );
      case RecurringType.expense:
        return NewTransactionInput(
          type: TransactionType.expense,
          amountMinor: amount,
          currencyCode: rule.currencyCode,
          date: date,
          accountId: rule.accountId,
          categoryId: rule.categoryId,
          note: overrides.note ?? rule.name,
        );
      case RecurringType.transfer:
      case RecurringType.liabilityPayment:
        return NewTransactionInput(
          type: TransactionType.transfer,
          amountMinor: amount,
          currencyCode: rule.currencyCode,
          date: date,
          accountId: rule.accountId,
          destinationAccountId: rule.destinationAccountId,
          note: overrides.note ?? rule.name,
        );
    }
  }

  Future<Failure?> _validateRuleContext(RecurringRuleInput input) async {
    final settings = await _db.managers.appSettingsTable.getSingleOrNull();
    final base = settings?.baseCurrency;
    if (base != null && input.currencyCode != base) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }
    final sourceFailure = await _checkAccount(
      input.accountId,
      input,
      mustBe: input.type == RecurringType.liabilityPayment
          ? _Classification.asset
          : null,
    );
    if (sourceFailure != null) return sourceFailure;
    if (input.type.needsDestination) {
      final destFailure = await _checkAccount(
        input.destinationAccountId,
        input,
        mustBe: input.type == RecurringType.liabilityPayment
            ? _Classification.liability
            : null,
      );
      if (destFailure != null) return destFailure;
    }
    if (input.categoryId != null) {
      final category = await (_db.select(
        _db.categoriesTable,
      )..where((c) => c.id.equals(input.categoryId!))).getSingleOrNull();
      if (category == null) {
        return const NotFoundFailure(FailureCodes.categoryNotFound);
      }
      if (category.isArchived) {
        return const ValidationFailure(FailureCodes.categoryArchived);
      }
      final expected = input.type == RecurringType.income
          ? 'income'
          : 'expense';
      if (category.categoryType != expected) {
        return const ValidationFailure(FailureCodes.categoryTypeMismatch);
      }
    }
    return null;
  }

  Future<Failure?> _checkAccount(
    String? accountId,
    RecurringRuleInput input, {
    _Classification? mustBe,
  }) async {
    if (accountId == null) return null;
    final account = await (_db.select(
      _db.accountsTable,
    )..where((a) => a.id.equals(accountId))).getSingleOrNull();
    if (account == null) {
      return const NotFoundFailure(FailureCodes.accountNotFound);
    }
    if (account.isArchived) {
      return const ValidationFailure(FailureCodes.accountArchived);
    }
    if (account.currencyCode != input.currencyCode) {
      return const ValidationFailure(FailureCodes.currencyMismatch);
    }
    if (mustBe == _Classification.liability &&
        account.classification != 'liability') {
      return const ValidationFailure(FailureCodes.recurringNotLiability);
    }
    if (mustBe == _Classification.asset && account.classification != 'asset') {
      return const ValidationFailure(FailureCodes.recurringNotLiability);
    }
    return null;
  }

  Future<Map<String, Set<int>>> _weekdaysFor(Iterable<String> ruleIds) async {
    if (ruleIds.isEmpty) return {};
    final rows = await (_db.select(
      _db.recurringRuleWeekdaysTable,
    )..where((w) => w.recurringRuleId.isIn(ruleIds))).get();
    final map = <String, Set<int>>{};
    for (final row in rows) {
      map.putIfAbsent(row.recurringRuleId, () => <int>{}).add(row.weekday);
    }
    return map;
  }

  Future<List<RecurringRule>> _withWeekdays(
    List<RecurringRulesTableData> rows,
  ) async {
    final wd = await _weekdaysFor(rows.map((r) => r.id));
    return rows
        .map((r) => _ruleToDomain(r, wd[r.id] ?? const <int>{}))
        .toList();
  }

  Future<void> _writeWeekdays(String ruleId, Set<int> weekdays) async {
    await (_db.delete(
      _db.recurringRuleWeekdaysTable,
    )..where((w) => w.recurringRuleId.equals(ruleId))).go();
    if (weekdays.isEmpty) return;
    await _db.batch((batch) {
      for (final weekday in weekdays) {
        batch.insert(
          _db.recurringRuleWeekdaysTable,
          RecurringRuleWeekdaysTableCompanion.insert(
            recurringRuleId: ruleId,
            weekday: weekday,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  RecurringRulesTableCompanion _ruleCompanion({
    required String id,
    required RecurringRuleInput input,
    required DateTime now,
  }) => RecurringRulesTableCompanion.insert(
    id: id,
    name: input.name.trim(),
    recurringType: input.type.name,
    accountId: Value(input.accountId),
    destinationAccountId: Value(input.destinationAccountId),
    categoryId: Value(input.categoryId),
    amountMinor: input.amountMinor,
    currencyCode: input.currencyCode,
    recurrenceFrequency: input.frequency.name,
    intervalValue: Value(input.intervalValue),
    monthlyDay: Value(input.monthlyDay),
    monthlyWeekOrdinal: Value(input.monthlyWeekOrdinal),
    monthlyWeekday: Value(input.monthlyWeekday),
    yearlyMonth: Value(input.yearlyMonth),
    yearlyDay: Value(input.yearlyDay),
    startDate: input.startDate.epochDay,
    endDate: Value(input.endDate?.epochDay),
    maxOccurrences: Value(input.maxOccurrences),
    autoCreateTransaction: Value(input.autoCreateTransaction),
    reminderDaysBefore: Value(input.reminderDaysBefore),
    notes: Value(input.notes),
    createdAt: now,
    updatedAt: now,
  );

  RecurringRulesTableCompanion _ruleUpdateCompanion({
    required RecurringRuleInput input,
    required DateTime now,
    required bool resetGeneration,
  }) => RecurringRulesTableCompanion(
    name: Value(input.name.trim()),
    recurringType: Value(input.type.name),
    accountId: Value(input.accountId),
    destinationAccountId: Value(input.destinationAccountId),
    categoryId: Value(input.categoryId),
    amountMinor: Value(input.amountMinor),
    currencyCode: Value(input.currencyCode),
    recurrenceFrequency: Value(input.frequency.name),
    intervalValue: Value(input.intervalValue),
    monthlyDay: Value(input.monthlyDay),
    monthlyWeekOrdinal: Value(input.monthlyWeekOrdinal),
    monthlyWeekday: Value(input.monthlyWeekday),
    yearlyMonth: Value(input.yearlyMonth),
    yearlyDay: Value(input.yearlyDay),
    startDate: Value(input.startDate.epochDay),
    endDate: Value(input.endDate?.epochDay),
    maxOccurrences: Value(input.maxOccurrences),
    autoCreateTransaction: Value(input.autoCreateTransaction),
    reminderDaysBefore: Value(input.reminderDaysBefore),
    notes: Value(input.notes),
    lastGeneratedThrough: resetGeneration
        ? const Value(null)
        : const Value.absent(),
    updatedAt: Value(now),
  );

  RecurringRule _ruleToDomain(RecurringRulesTableData r, Set<int> weekdays) =>
      RecurringRule(
        id: r.id,
        name: r.name,
        type: RecurringType.fromName(r.recurringType),
        accountId: r.accountId,
        destinationAccountId: r.destinationAccountId,
        categoryId: r.categoryId,
        amountMinor: r.amountMinor,
        currencyCode: r.currencyCode,
        frequency: RecurrenceFrequency.fromName(r.recurrenceFrequency),
        intervalValue: r.intervalValue,
        weekdays: weekdays,
        monthlyDay: r.monthlyDay,
        monthlyWeekOrdinal: r.monthlyWeekOrdinal,
        monthlyWeekday: r.monthlyWeekday,
        yearlyMonth: r.yearlyMonth,
        yearlyDay: r.yearlyDay,
        startDate: LocalDate.fromEpochDay(r.startDate),
        endDate: r.endDate == null ? null : LocalDate.fromEpochDay(r.endDate!),
        maxOccurrences: r.maxOccurrences,
        autoCreateTransaction: r.autoCreateTransaction,
        reminderDaysBefore: r.reminderDaysBefore,
        notes: r.notes,
        isActive: r.isActive,
        lastGeneratedThrough: r.lastGeneratedThrough == null
            ? null
            : LocalDate.fromEpochDay(r.lastGeneratedThrough!),
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  RecurringOccurrence _occurrenceToDomain(RecurringOccurrencesTableData o) =>
      RecurringOccurrence(
        id: o.id,
        ruleId: o.recurringRuleId,
        dueDate: LocalDate.fromEpochDay(o.dueDate),
        originalDueDate: LocalDate.fromEpochDay(o.originalDueDate),
        expectedAmountMinor: o.expectedAmountMinor,
        status: OccurrenceStatus.fromName(o.status),
        generatedTransactionId: o.generatedTransactionId,
        completedAt: o.completedAt,
        skippedAt: o.skippedAt,
        skipReason: o.skipReason,
        snoozedUntil: o.snoozedUntil == null
            ? null
            : LocalDate.fromEpochDay(o.snoozedUntil!),
        createdAt: o.createdAt,
        updatedAt: o.updatedAt,
      );
}

enum _Classification { asset, liability }

class _Failed implements Exception {
  const _Failed(this.failure);
  final Failure failure;
}
