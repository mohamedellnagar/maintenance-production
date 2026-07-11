import '../../../core/time/local_date.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_rule.dart';

/// Generates occurrences within a rolling window and (optionally) auto-posts due
/// ones. Idempotent and re-runnable; runs on app open / when the Recurring
/// screen opens — there is no background timer.
class RecurrenceGenerationService {
  RecurrenceGenerationService({
    required this.repository,
    required this.today,
    required this.autoCreateEnabled,
    this.horizonDays = 90,
    this.backfillDays = 60,
  });

  final RecurringRepository repository;
  final Clock today;
  final Future<bool> Function() autoCreateEnabled;
  final int horizonDays;
  final int backfillDays;

  /// Generates occurrences for all active rules.
  Future<void> generate() async {
    final now = today();
    final to = now.addDays(horizonDays);
    for (final rule in await repository.getActiveRules()) {
      final from = _windowStart(rule, now);
      if (from.isAfter(to)) continue;
      await repository.generateForRule(rule, from, to);
    }
  }

  /// Generates, then auto-posts due occurrences of opted-in rules when the
  /// global setting is on. Each occurrence posts at most once (guarded by the
  /// repository), never in the future, never when a referenced account/category
  /// is archived (the post fails and the occurrence is left for the user).
  Future<void> generateAndAutoCreate() async {
    await generate();
    if (!await autoCreateEnabled()) return;
    final now = today();
    final rulesById = {
      for (final r in await repository.getActiveRules()) r.id: r,
    };
    for (final occurrence in await repository.getOpenDueOccurrences(now)) {
      final rule = rulesById[occurrence.ruleId];
      if (rule == null || !rule.autoCreateTransaction) continue;
      // Failures (e.g. archived account) leave the occurrence untouched.
      await repository.postOccurrence(occurrence.id);
    }
  }

  LocalDate _windowStart(RecurringRule rule, LocalDate today) {
    final last = rule.lastGeneratedThrough;
    final candidate = last != null
        ? last.addDays(1)
        : _maxDate(rule.startDate, today.addDays(-backfillDays));
    return _maxDate(candidate, rule.startDate);
  }

  LocalDate _maxDate(LocalDate a, LocalDate b) => a.isAfter(b) ? a : b;
}
