import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEmpty = habits.isEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0x08000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habits',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'No habits scheduled today.',
                          style: TextStyle(color: colors.secondaryText, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
                      icon: Icon(Icons.add, size: 16, color: colors.primaryBlue),
                      label: Text(
                        'Add Schedule',
                        style: TextStyle(
                          color: colors.primaryBlue,
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
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: colors.primaryBlue,
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
                      style: TextStyle(
                        color: colors.secondaryText,
                        fontSize: 13,
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: onAddSchedule,
                            child: Text(
                              'Create one',
                              style: TextStyle(
                                color: colors.primaryBlue,
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
