import 'recurring_type.dart';

/// Kinds of in-app recurring insight. Device notifications are intentionally
/// out of scope for V1 — insights are surfaced only inside the app.
enum RecurringInsightType {
  billOverdue,
  multipleDueToday,
  incomeUpcoming,
  autoCreateFailed,
  archivedReference,
  manyUnpaid,
}

enum RecurringInsightSeverity { info, warning }

/// A single structured recurring insight. The user-facing message is localized
/// in the presentation layer; this carries only data.
class RecurringInsight {
  const RecurringInsight({
    required this.type,
    required this.severity,
    this.count,
  });

  final RecurringInsightType type;
  final RecurringInsightSeverity severity;
  final int? count;
}

/// Lightweight snapshot of an occurrence used by the insight builder, decoupled
/// from Riverpod/UI types so the logic stays pure and testable.
class RecurringInsightOccurrence {
  const RecurringInsightOccurrence({
    required this.status,
    required this.type,
    required this.dueToday,
    required this.autoCreateFailed,
    required this.referencesArchived,
  });

  final OccurrenceDisplayStatus status;
  final RecurringType type;
  final bool dueToday;
  final bool autoCreateFailed;
  final bool referencesArchived;
}

abstract final class RecurringInsightBuilder {
  const RecurringInsightBuilder._();

  /// Threshold above which "several unpaid" is surfaced.
  static const int manyUnpaidThreshold = 5;

  static List<RecurringInsight> build(
    List<RecurringInsightOccurrence> occurrences,
  ) {
    final insights = <RecurringInsight>[];

    final overdue = occurrences
        .where((o) => o.status == OccurrenceDisplayStatus.overdue)
        .length;
    if (overdue > 0) {
      insights.add(
        RecurringInsight(
          type: RecurringInsightType.billOverdue,
          severity: RecurringInsightSeverity.warning,
          count: overdue,
        ),
      );
    }

    final dueTodayCount = occurrences
        .where((o) => o.dueToday && o.status == OccurrenceDisplayStatus.due)
        .length;
    if (dueTodayCount > 1) {
      insights.add(
        RecurringInsight(
          type: RecurringInsightType.multipleDueToday,
          severity: RecurringInsightSeverity.info,
          count: dueTodayCount,
        ),
      );
    }

    final incomeUpcoming = occurrences.any(
      (o) =>
          o.type == RecurringType.income &&
          (o.status == OccurrenceDisplayStatus.due ||
              o.status == OccurrenceDisplayStatus.scheduled),
    );
    if (incomeUpcoming) {
      insights.add(
        const RecurringInsight(
          type: RecurringInsightType.incomeUpcoming,
          severity: RecurringInsightSeverity.info,
        ),
      );
    }

    if (occurrences.any((o) => o.autoCreateFailed)) {
      insights.add(
        const RecurringInsight(
          type: RecurringInsightType.autoCreateFailed,
          severity: RecurringInsightSeverity.warning,
        ),
      );
    }

    if (occurrences.any((o) => o.referencesArchived)) {
      insights.add(
        const RecurringInsight(
          type: RecurringInsightType.archivedReference,
          severity: RecurringInsightSeverity.warning,
        ),
      );
    }

    final unpaid = occurrences
        .where(
          (o) =>
              o.status == OccurrenceDisplayStatus.due ||
              o.status == OccurrenceDisplayStatus.scheduled ||
              o.status == OccurrenceDisplayStatus.overdue,
        )
        .length;
    if (unpaid >= manyUnpaidThreshold) {
      insights.add(
        RecurringInsight(
          type: RecurringInsightType.manyUnpaid,
          severity: RecurringInsightSeverity.info,
          count: unpaid,
        ),
      );
    }

    return insights;
  }
}
