import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/features/habits/presentation/models/habit_item_model.dart';
import 'package:life_sync_app/features/habits/presentation/widgets/habit_item.dart';

/// Card container for the Habits section on the Dashboard / Home Screen.
///
/// If habits exist, it presents the stylized habit rows and expandable checklists.
/// If no habits are present, it falls back to the centered activity tracker illustration.
class HabitsCard extends StatelessWidget {
  const HabitsCard({
    required this.habits,
    this.onViewAll,
    this.onAddSchedule,
    this.onHabitTap,
    this.onToggleExpand,
    this.onSubItemToggle,
    super.key,
  });

  final List<Habit> habits;
  final VoidCallback? onViewAll;
  final VoidCallback? onAddSchedule;
  final ValueChanged<Habit>? onHabitTap;
  final ValueChanged<Habit>? onToggleExpand;
  final void Function(Habit habit, HabitSubItem subItem)? onSubItemToggle;

  static const Color darkText = Color(0xFF222222);
  static const Color secondaryText = Color(0xFF777B87);
  static const Color primaryBlue = Color(0xFF4F8DF7);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final isEmpty = habits.isEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Habits',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                  if (isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'No habits scheduled today.',
                        style: TextStyle(color: secondaryText, fontSize: 11),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onAddSchedule != null && !isEmpty) ...[
                    TextButton.icon(
                      onPressed: onAddSchedule,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      icon: const Icon(Icons.add, size: 16, color: primaryBlue),
                      label: const Text(
                        'Add Schedule',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Body: Empty Illustration vs Habit List
          if (isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: SvgPicture.asset(
                  LifeSyncSvgAssets.activityTracker,
                  width: 150,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (onAddSchedule != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Alright, what habit are we starting? ',
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: onAddSchedule,
                            child: const Text(
                              'Create one',
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ] else ...[
            for (var i = 0; i < habits.length; i++) ...[
              if (i > 0) const SizedBox(height: 6),
              HabitItem(
                habit: habits[i],
                onTap: () => onHabitTap?.call(habits[i]),
                onToggleExpand: () => onToggleExpand?.call(habits[i]),
                onSubItemToggle: (subItem) =>
                    onSubItemToggle?.call(habits[i], subItem),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
