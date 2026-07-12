import 'package:flutter/material.dart';

import '../domain/goal_type.dart';

/// Distinct icon per goal type (never the only signal — always paired with
/// text). Kept out of widgets so every screen shows the same glyph.
IconData goalTypeIcon(GoalType type) => switch (type) {
  GoalType.emergencyFund => Icons.health_and_safety_outlined,
  GoalType.home => Icons.home_outlined,
  GoalType.car => Icons.directions_car_outlined,
  GoalType.travel => Icons.flight_takeoff_outlined,
  GoalType.education => Icons.school_outlined,
  GoalType.wedding => Icons.favorite_outline,
  GoalType.retirement => Icons.beach_access_outlined,
  GoalType.debtPayoff => Icons.trending_down_outlined,
  GoalType.purchase => Icons.shopping_bag_outlined,
  GoalType.custom => Icons.flag_outlined,
};
