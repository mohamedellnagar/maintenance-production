import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/local_date.dart';
import '../domain/financial_goal.dart';
import '../domain/goal_input.dart';
import '../domain/goal_type.dart';

final goalsControllerProvider = Provider<GoalsController>(
  (ref) => GoalsController(ref),
);

/// Imperative goal + fund actions. All persistence is delegated to the
/// repository (atomic); the UI reacts through the providers.
class GoalsController {
  GoalsController(this._ref);
  final Ref _ref;

  Future<Result<FinancialGoal>> createGoal(
    GoalInput input, {
    int? initialAllocationMinor,
  }) => _ref
      .read(goalsRepositoryProvider)
      .createGoal(input, initialAllocationMinor: initialAllocationMinor);

  Future<Result<FinancialGoal>> updateGoal(String id, GoalInput input) =>
      _ref.read(goalsRepositoryProvider).updateGoal(id, input);

  Future<Result<void>> setStatus(String id, GoalStatus status) =>
      _ref.read(goalsRepositoryProvider).setStatus(id, status);

  Future<Result<void>> pause(String id) => setStatus(id, GoalStatus.paused);
  Future<Result<void>> resume(String id) => setStatus(id, GoalStatus.active);
  Future<Result<void>> complete(String id) =>
      setStatus(id, GoalStatus.completed);
  Future<Result<void>> archive(String id) => setStatus(id, GoalStatus.archived);
  Future<Result<void>> cancel(String id) => setStatus(id, GoalStatus.cancelled);

  Future<Result<void>> deleteGoal(String id) =>
      _ref.read(goalsRepositoryProvider).deleteGoal(id);

  Future<Result<void>> contribute(
    String goalId,
    int amountMinor, {
    LocalDate? date,
    String? note,
    String? linkedTransactionId,
  }) => _ref
      .read(goalsRepositoryProvider)
      .contribute(
        goalId,
        amountMinor,
        date: date,
        note: note,
        linkedTransactionId: linkedTransactionId,
      );

  Future<Result<void>> withdraw(
    String goalId,
    int amountMinor, {
    String? note,
  }) => _ref
      .read(goalsRepositoryProvider)
      .withdraw(goalId, amountMinor, note: note);

  Future<Result<void>> transfer(
    String fromGoalId,
    String toGoalId,
    int amountMinor, {
    String? note,
  }) => _ref
      .read(goalsRepositoryProvider)
      .transferBetweenGoals(fromGoalId, toGoalId, amountMinor, note: note);

  Future<Result<void>> softDeleteEntry(String entryId) =>
      _ref.read(goalsRepositoryProvider).softDeleteEntry(entryId);

  Future<Result<void>> restoreEntry(String entryId) =>
      _ref.read(goalsRepositoryProvider).restoreEntry(entryId);
}
