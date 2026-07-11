import '../../../core/time/local_date.dart';
import 'recurring_type.dart';

/// A single due date generated from a rule. It is a *plan*: it never affects
/// balances until posted into a transaction.
class RecurringOccurrence {
  const RecurringOccurrence({
    required this.id,
    required this.ruleId,
    required this.dueDate,
    required this.originalDueDate,
    required this.expectedAmountMinor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.generatedTransactionId,
    this.completedAt,
    this.skippedAt,
    this.skipReason,
    this.snoozedUntil,
  });

  final String id;
  final String ruleId;
  final LocalDate dueDate;
  final LocalDate originalDueDate;
  final int expectedAmountMinor;
  final OccurrenceStatus status;
  final String? generatedTransactionId;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final String? skipReason;
  final LocalDate? snoozedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// The date the user is actually expected to act on (snooze wins).
  LocalDate get effectiveDueDate => snoozedUntil ?? dueDate;

  /// The status shown to the user. `paid` only holds while the linked
  /// transaction is still active; otherwise the occurrence reopens. `due` and
  /// `overdue` are derived from [effectiveDueDate] vs. [today].
  OccurrenceDisplayStatus displayStatus({
    required LocalDate today,
    required bool linkedTransactionActive,
  }) {
    switch (status) {
      case OccurrenceStatus.cancelled:
        return OccurrenceDisplayStatus.cancelled;
      case OccurrenceStatus.skipped:
        return OccurrenceDisplayStatus.skipped;
      case OccurrenceStatus.paid:
        if (linkedTransactionActive) return OccurrenceDisplayStatus.paid;
      case OccurrenceStatus.scheduled:
        break;
    }
    // Scheduled, or a paid occurrence whose transaction was deleted (reopened).
    final due = effectiveDueDate;
    if (due.isBefore(today)) return OccurrenceDisplayStatus.overdue;
    if (due == today) return OccurrenceDisplayStatus.due;
    return OccurrenceDisplayStatus.scheduled;
  }

  bool get isOpen =>
      status == OccurrenceStatus.scheduled || status == OccurrenceStatus.paid;
}
