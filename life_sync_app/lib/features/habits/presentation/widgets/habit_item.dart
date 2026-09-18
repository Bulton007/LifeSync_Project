import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/features/habits/presentation/models/habit_item_model.dart';
import 'package:life_sync_app/features/habits/presentation/widgets/habit_sub_item.dart';

/// Reusable widget for presenting an individual habit item matching
/// the reference design specification.
class HabitItem extends StatelessWidget {
  const HabitItem({
    required this.habit,
    this.onTap,
    this.onToggleExpand,
    this.onSubItemToggle,
    super.key,
  });

  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onToggleExpand;
  final ValueChanged<HabitSubItem>? onSubItemToggle;

  static const Color fireColor = Color(0xFFFF6D00);

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (habit.statusType == HabitStatusType.progress) {
              onToggleExpand?.call();
            } else {
              onTap?.call();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Left Icon Container
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark
                        ? habit.iconColor.withValues(alpha: 0.15)
                        : habit.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit.icon, color: habit.iconColor, size: 22),
                ),
                const SizedBox(width: 12),

                // Title and Streak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            size: 15,
                            color: fireColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            habit.streakText,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.secondaryText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Status Area
                _buildRightStatus(context),
              ],
            ),
          ),
        ),

        // Expanded Sub-habits checklist
        if (habit.isExpanded && habit.subHabits.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 4, bottom: 6),
            child: Column(
              children: [
                for (var i = 0; i < habit.subHabits.length; i++)
                  HabitSubItemWidget(
                    item: habit.subHabits[i],
                    isFirst: i == 0,
                    isLast: i == habit.subHabits.length - 1,
                    onToggle: () => onSubItemToggle?.call(habit.subHabits[i]),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRightStatus(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (habit.statusType) {
      case HabitStatusType.progress:
        final total = habit.subHabits.length;
        final completed = habit.completedCount;
        final fraction = total == 0 ? 0.0 : completed / total;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$completed/$total',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.secondaryText,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: fraction,
                strokeWidth: 2.5,
                backgroundColor: colors.inputSurface,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primaryBlue),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              habit.isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        );

      case HabitStatusType.completedPill:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? colors.primaryBlue.withValues(alpha: 0.15)
                    : const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 14, color: colors.primaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: TextStyle(
                      color: colors.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        );

      case HabitStatusType.doneOutlinedPill:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4.5,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.primaryBlue, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 14, color: colors.primaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    'Done',
                    style: TextStyle(
                      color: colors.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        );
    }
  }
}
