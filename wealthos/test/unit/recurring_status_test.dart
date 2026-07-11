import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/time/local_date.dart';
import 'package:wealthos/features/recurring/domain/recurring_insights.dart';
import 'package:wealthos/features/recurring/domain/recurring_occurrence.dart';
import 'package:wealthos/features/recurring/domain/recurring_type.dart';

final _createdAt = DateTime(2026, 1, 1);

RecurringOccurrence _occ({
  required LocalDate dueDate,
  OccurrenceStatus status = OccurrenceStatus.scheduled,
  LocalDate? snoozedUntil,
  String? generatedTransactionId,
}) => RecurringOccurrence(
  id: 'o',
  ruleId: 'r',
  dueDate: dueDate,
  originalDueDate: dueDate,
  expectedAmountMinor: 1000,
  status: status,
  createdAt: _createdAt,
  updatedAt: _createdAt,
  snoozedUntil: snoozedUntil,
  generatedTransactionId: generatedTransactionId,
);

void main() {
  const today = LocalDate(2026, 6, 15);

  group('display status', () {
    test('future scheduled occurrence is scheduled', () {
      final o = _occ(dueDate: const LocalDate(2026, 6, 20));
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.scheduled,
      );
    });

    test('due today is due', () {
      final o = _occ(dueDate: today);
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.due,
      );
    });

    test('past unpaid is overdue', () {
      final o = _occ(dueDate: const LocalDate(2026, 6, 10));
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.overdue,
      );
    });

    test('paid with a live transaction is paid', () {
      final o = _occ(
        dueDate: const LocalDate(2026, 6, 10),
        status: OccurrenceStatus.paid,
        generatedTransactionId: 'tx',
      );
      expect(
        o.displayStatus(today: today, linkedTransactionActive: true),
        OccurrenceDisplayStatus.paid,
      );
    });

    test('paid but transaction deleted reopens (overdue again)', () {
      final o = _occ(
        dueDate: const LocalDate(2026, 6, 10),
        status: OccurrenceStatus.paid,
        generatedTransactionId: 'tx',
      );
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.overdue,
      );
    });

    test('snooze pushes the effective due date forward', () {
      final o = _occ(
        dueDate: const LocalDate(2026, 6, 10),
        snoozedUntil: const LocalDate(2026, 6, 20),
      );
      expect(o.effectiveDueDate, const LocalDate(2026, 6, 20));
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.scheduled,
      );
    });

    test('skipped stays skipped regardless of date', () {
      final o = _occ(
        dueDate: const LocalDate(2026, 6, 10),
        status: OccurrenceStatus.skipped,
      );
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.skipped,
      );
    });

    test('cancelled stays cancelled', () {
      final o = _occ(dueDate: today, status: OccurrenceStatus.cancelled);
      expect(
        o.displayStatus(today: today, linkedTransactionActive: false),
        OccurrenceDisplayStatus.cancelled,
      );
    });
  });

  group('insight builder', () {
    RecurringInsightOccurrence snap(
      OccurrenceDisplayStatus status, {
      RecurringType type = RecurringType.expense,
      bool dueToday = false,
      bool autoCreateFailed = false,
      bool referencesArchived = false,
    }) => RecurringInsightOccurrence(
      status: status,
      type: type,
      dueToday: dueToday,
      autoCreateFailed: autoCreateFailed,
      referencesArchived: referencesArchived,
    );

    test('overdue occurrence yields an overdue insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.overdue),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.billOverdue),
      );
    });

    test('more than one due today yields the multiple-due insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.due, dueToday: true),
        snap(OccurrenceDisplayStatus.due, dueToday: true),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.multipleDueToday),
      );
    });

    test('a single due-today does not raise the multiple insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.due, dueToday: true),
      ]);
      expect(
        insights.map((i) => i.type),
        isNot(contains(RecurringInsightType.multipleDueToday)),
      );
    });

    test('upcoming income yields the income insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.scheduled, type: RecurringType.income),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.incomeUpcoming),
      );
    });

    test('auto-create failure yields the failure insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.overdue, autoCreateFailed: true),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.autoCreateFailed),
      );
    });

    test('archived reference yields the archived insight', () {
      final insights = RecurringInsightBuilder.build([
        snap(OccurrenceDisplayStatus.scheduled, referencesArchived: true),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.archivedReference),
      );
    });

    test('many unpaid occurrences yield the many-unpaid insight', () {
      final insights = RecurringInsightBuilder.build([
        for (var i = 0; i < RecurringInsightBuilder.manyUnpaidThreshold; i++)
          snap(OccurrenceDisplayStatus.scheduled),
      ]);
      expect(
        insights.map((i) => i.type),
        contains(RecurringInsightType.manyUnpaid),
      );
    });

    test('no occurrences yield no insights', () {
      expect(RecurringInsightBuilder.build(const []), isEmpty);
    });
  });
}
