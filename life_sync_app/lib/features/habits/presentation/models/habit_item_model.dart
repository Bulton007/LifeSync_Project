import 'package:flutter/material.dart';

/// Representation of a single sub-habit checklist item.
class HabitSubItem {
  const HabitSubItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final bool isCompleted;

  HabitSubItem copyWith({String? id, String? title, bool? isCompleted}) {
    return HabitSubItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Visual status presentation on the right side of a habit row.
enum HabitStatusType {
  /// Displays completed/total count, circular progress, and expand/collapse chevron.
  progress,

  /// Displays a solid light-blue pill with check icon and "Completed" text.
  completedPill,

  /// Displays an outlined blue pill with check icon and "Done" text.
  doneOutlinedPill,
}

/// Model for presentation of a Habit card item on the dashboard.
class Habit {
  const Habit({
    required this.id,
    required this.title,
    this.streakText = '168 Days Streaks',
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.statusType,
    this.subHabits = const [],
    this.isExpanded = false,
  });

  final String id;
  final String title;
  final String streakText;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final HabitStatusType statusType;
  final List<HabitSubItem> subHabits;
  final bool isExpanded;

  int get completedCount => subHabits.where((item) => item.isCompleted).length;

  double get progressFraction =>
      subHabits.isEmpty ? 0.0 : completedCount / subHabits.length;

  Habit copyWith({
    String? id,
    String? title,
    String? streakText,
    IconData? icon,
    Color? iconBgColor,
    Color? iconColor,
    HabitStatusType? statusType,
    List<HabitSubItem>? subHabits,
    bool? isExpanded,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      streakText: streakText ?? this.streakText,
      icon: icon ?? this.icon,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      iconColor: iconColor ?? this.iconColor,
      statusType: statusType ?? this.statusType,
      subHabits: subHabits ?? this.subHabits,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
