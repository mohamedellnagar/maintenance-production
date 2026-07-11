import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/local_date.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_rule_input.dart';

final recurringControllerProvider = Provider<RecurringController>(
  (ref) => RecurringController(ref),
);

/// Imperative facade over the recurring repository + generation service.
class RecurringController {
  RecurringController(this._ref);
  final Ref _ref;

  RecurringRepository get _repo => _ref.read(recurringRepositoryProvider);
  LocalDate get _today => _ref.read(clockProvider)();

  Future<Result<RecurringRule>> createRule(RecurringRuleInput input) async {
    final result = await _repo.createRule(input);
    if (result.isSuccess) {
      await _ref.read(recurrenceGenerationServiceProvider).generate();
    }
    return result;
  }

  Future<Result<RecurringRule>> updateRule(
    String id,
    RecurringRuleInput input,
  ) async {
    final result = await _repo.updateRule(id, input, today: _today);
    if (result.isSuccess) {
      await _ref.read(recurrenceGenerationServiceProvider).generate();
    }
    return result;
  }

  Future<Result<void>> pause(String id) => _repo.setActive(id, active: false);

  Future<Result<void>> resume(String id) async {
    final result = await _repo.setActive(id, active: true);
    if (result.isSuccess) {
      await _ref.read(recurrenceGenerationServiceProvider).generate();
    }
    return result;
  }

  Future<Result<void>> endRule(String id) => _repo.endRule(id, endDate: _today);

  Future<Result<void>> deleteRule(String id) => _repo.deleteRule(id);

  Future<Result<void>> post(
    String occurrenceId, {
    PostOverrides overrides = const PostOverrides(),
  }) => _repo.postOccurrence(occurrenceId, overrides: overrides);

  Future<Result<void>> snooze(String occurrenceId, LocalDate until) =>
      _repo.snooze(occurrenceId, until);

  Future<Result<void>> skip(String occurrenceId, {String? reason}) =>
      _repo.skip(occurrenceId, reason: reason);
}
