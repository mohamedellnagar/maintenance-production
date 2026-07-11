import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/time/local_date.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/recurring_insights.dart';
import '../domain/recurring_occurrence.dart';
import '../domain/recurring_rule.dart';
import '../domain/recurring_type.dart';

/// Today as a [LocalDate] (overridden in tests via [clockProvider]).
final recurringTodayProvider = Provider<LocalDate>(
  (ref) => ref.watch(clockProvider)(),
);

/// Runs generation + auto-create once per app launch.
final recurringBootstrapProvider = FutureProvider<void>(
  (ref) =>
      ref.read(recurrenceGenerationServiceProvider).generateAndAutoCreate(),
);

final allRulesProvider = StreamProvider<List<RecurringRule>>(
  (ref) => ref.watch(recurringRepositoryProvider).watchRules(),
);

final activeRulesProvider = StreamProvider<List<RecurringRule>>(
  (ref) => ref.watch(recurringRepositoryProvider).watchRules(activeOnly: true),
);

final ruleByIdProvider = StreamProvider.family<RecurringRule?, String>(
  (ref, id) => ref.watch(recurringRepositoryProvider).watchRuleById(id),
);

final allOccurrencesProvider = StreamProvider<List<RecurringOccurrence>>(
  (ref) => ref.watch(recurringRepositoryProvider).watchOccurrences(),
);

final occurrenceByIdProvider =
    StreamProvider.family<RecurringOccurrence?, String>(
      (ref, id) =>
          ref.watch(recurringRepositoryProvider).watchOccurrenceById(id),
    );

final occurrencesForRuleProvider =
    StreamProvider.family<List<RecurringOccurrence>, String>(
      (ref, ruleId) => ref
          .watch(recurringRepositoryProvider)
          .watchOccurrencesForRule(ruleId),
    );

/// An occurrence with its rule and derived display status.
class OccurrenceView {
  const OccurrenceView({
    required this.occurrence,
    required this.rule,
    required this.status,
  });

  final RecurringOccurrence occurrence;
  final RecurringRule rule;
  final OccurrenceDisplayStatus status;

  LocalDate get effectiveDueDate => occurrence.effectiveDueDate;
  int get expectedAmountMinor => occurrence.expectedAmountMinor;
  RecurringType get type => rule.type;
}

/// All occurrences joined with their rule and a derived status. Reacts to
/// occurrences, rules and transactions (so posting/deleting flips paid state).
final occurrenceViewsProvider = Provider<List<OccurrenceView>>((ref) {
  final occurrences = ref.watch(allOccurrencesProvider).value ?? const [];
  final rules = ref.watch(allRulesProvider).value ?? const [];
  final transactions = ref.watch(allTransactionsProvider).value ?? const [];
  final today = ref.watch(recurringTodayProvider);
  final rulesById = {for (final r in rules) r.id: r};
  final liveTxIds = {for (final t in transactions) t.id};

  final views = <OccurrenceView>[];
  for (final occurrence in occurrences) {
    final rule = rulesById[occurrence.ruleId];
    if (rule == null) continue;
    final linkedActive =
        occurrence.generatedTransactionId != null &&
        liveTxIds.contains(occurrence.generatedTransactionId);
    views.add(
      OccurrenceView(
        occurrence: occurrence,
        rule: rule,
        status: occurrence.displayStatus(
          today: today,
          linkedTransactionActive: linkedActive,
        ),
      ),
    );
  }
  views.sort(
    (a, b) =>
        a.effectiveDueDate.epochDay.compareTo(b.effectiveDueDate.epochDay),
  );
  return views;
});

/// Occurrences due today.
final dueTodayProvider = Provider<List<OccurrenceView>>(
  (ref) => ref
      .watch(occurrenceViewsProvider)
      .where((v) => v.status == OccurrenceDisplayStatus.due)
      .toList(),
);

/// Overdue occurrences.
final overdueProvider = Provider<List<OccurrenceView>>(
  (ref) => ref
      .watch(occurrenceViewsProvider)
      .where((v) => v.status == OccurrenceDisplayStatus.overdue)
      .toList(),
);

/// Unpaid (scheduled/due/overdue) occurrences whose effective due date falls
/// within the given calendar month. Used by the Budget screen to show *planned*
/// recurring cash flow separately from actual spending — these do NOT affect
/// balances, net worth, or budget actuals until posted.
final upcomingRecurringForMonthProvider =
    Provider.family<List<OccurrenceView>, ({int year, int month})>((ref, ym) {
      bool unpaid(OccurrenceDisplayStatus s) =>
          s == OccurrenceDisplayStatus.scheduled ||
          s == OccurrenceDisplayStatus.due ||
          s == OccurrenceDisplayStatus.overdue;
      return ref.watch(occurrenceViewsProvider).where((v) {
        final d = v.effectiveDueDate;
        return unpaid(v.status) && d.year == ym.year && d.month == ym.month;
      }).toList();
    });

/// Open (unpaid) occurrences due within [days] from today (inclusive), sorted.
final upcomingProvider = Provider.family<List<OccurrenceView>, int>((
  ref,
  days,
) {
  final today = ref.watch(recurringTodayProvider);
  final horizon = today.addDays(days);
  return ref.watch(occurrenceViewsProvider).where((v) {
    if (v.status != OccurrenceDisplayStatus.due &&
        v.status != OccurrenceDisplayStatus.scheduled) {
      return false;
    }
    final d = v.effectiveDueDate;
    return d.isSameOrAfter(today) && d.isSameOrBefore(horizon);
  }).toList();
});

/// In-app recurring insights (overdue, multiple due today, income upcoming,
/// archived reference, many unpaid, auto-create expected-but-unposted). Purely
/// derived from occurrences + rules + archived accounts/categories + settings —
/// no device notifications.
final recurringInsightsProvider = Provider<List<RecurringInsight>>((ref) {
  final views = ref.watch(occurrenceViewsProvider);
  final today = ref.watch(recurringTodayProvider);
  final accounts = ref.watch(allAccountsProvider).value ?? const [];
  final categories =
      ref.watch(_allCategoriesForInsightsProvider).value ?? const [];
  final autoCreateEnabled =
      ref.watch(currentSettingsProvider)?.autoCreateRecurringEnabled ?? false;

  final archivedAccountIds = {
    for (final a in accounts)
      if (a.isArchived) a.id,
  };
  final archivedCategoryIds = {
    for (final c in categories)
      if (c.isArchived) c.id,
  };

  final snapshots = views.map((v) {
    final rule = v.rule;
    final referencesArchived =
        (rule.accountId != null &&
            archivedAccountIds.contains(rule.accountId)) ||
        (rule.destinationAccountId != null &&
            archivedAccountIds.contains(rule.destinationAccountId)) ||
        (rule.categoryId != null &&
            archivedCategoryIds.contains(rule.categoryId));
    // Heuristic: an auto-create rule whose occurrence is still overdue while
    // auto-create is enabled means the automatic posting did not succeed.
    final autoCreateFailed =
        autoCreateEnabled &&
        rule.autoCreateTransaction &&
        v.status == OccurrenceDisplayStatus.overdue &&
        !referencesArchived;
    return RecurringInsightOccurrence(
      status: v.status,
      type: v.type,
      dueToday: v.effectiveDueDate == today,
      autoCreateFailed: autoCreateFailed,
      referencesArchived: referencesArchived,
    );
  }).toList();

  return RecurringInsightBuilder.build(snapshots);
});

/// Streams every category so archived references can be detected.
final _allCategoriesForInsightsProvider = StreamProvider(
  (ref) => ref.watch(categoriesRepositoryProvider).watchAll(),
);
