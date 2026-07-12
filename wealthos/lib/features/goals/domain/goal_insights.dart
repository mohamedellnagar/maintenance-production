import 'goal_thresholds.dart';
import 'goal_type.dart';

enum GoalInsightType {
  allocationShortfall,
  behind,
  nearCompletion,
  completed,
  stalled,
  deadlineSoon,
  overfunded,
  emergencyFundLow,
}

enum GoalInsightSeverity { info, warning }

/// A single in-app goals insight. Carries structured data only; the message is
/// localized in the presentation layer. Device notifications are out of scope.
class GoalInsight {
  const GoalInsight({
    required this.type,
    required this.severity,
    this.goalId,
    this.goalName,
  });

  final GoalInsightType type;
  final GoalInsightSeverity severity;
  final String? goalId;
  final String? goalName;
}

/// Decoupled per-goal snapshot for the pure insight builder.
class GoalInsightSnapshot {
  const GoalInsightSnapshot({
    required this.goalId,
    required this.goalName,
    required this.type,
    required this.track,
    required this.fundingRatio,
    required this.isCompleted,
    required this.isOverfunded,
    required this.deadlineSoonWithLargeRemaining,
    this.daysSinceLastContribution,
  });

  final String goalId;
  final String goalName;
  final GoalType type;
  final GoalTrackStatus track;
  final double fundingRatio;
  final bool isCompleted;
  final bool isOverfunded;
  final bool deadlineSoonWithLargeRemaining;
  final int? daysSinceLastContribution;
}

abstract final class GoalInsightBuilder {
  const GoalInsightBuilder._();

  static List<GoalInsight> build({
    required List<GoalInsightSnapshot> goals,
    required bool allocationShortfall,
  }) {
    final insights = <GoalInsight>[];

    if (allocationShortfall) {
      insights.add(
        const GoalInsight(
          type: GoalInsightType.allocationShortfall,
          severity: GoalInsightSeverity.warning,
        ),
      );
    }

    for (final g in goals) {
      void add(GoalInsightType type, GoalInsightSeverity severity) {
        insights.add(
          GoalInsight(
            type: type,
            severity: severity,
            goalId: g.goalId,
            goalName: g.goalName,
          ),
        );
      }

      if (g.isCompleted) {
        add(GoalInsightType.completed, GoalInsightSeverity.info);
        if (g.isOverfunded) {
          add(GoalInsightType.overfunded, GoalInsightSeverity.info);
        }
        continue;
      }
      if (g.track == GoalTrackStatus.behind) {
        add(GoalInsightType.behind, GoalInsightSeverity.warning);
      }
      if (g.deadlineSoonWithLargeRemaining) {
        add(GoalInsightType.deadlineSoon, GoalInsightSeverity.warning);
      }
      if (g.fundingRatio >= GoalThresholds.nearCompletionRatio) {
        add(GoalInsightType.nearCompletion, GoalInsightSeverity.info);
      }
      final stale = g.daysSinceLastContribution;
      if (stale != null && stale >= GoalThresholds.staleContributionDays) {
        add(GoalInsightType.stalled, GoalInsightSeverity.info);
      }
      if (g.type == GoalType.emergencyFund && g.fundingRatio < 1.0) {
        add(GoalInsightType.emergencyFundLow, GoalInsightSeverity.info);
      }
    }

    return insights;
  }
}
