import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'calendar_day_cell.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    const weekdays = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    // January 2026 begins on Thursday.
    // Sunday-first calendar:
    //
    // 28 29 30 31  1  2  3
    //  4  5  6  7  8  9 10
    // ...

    const cells = [
      _CalendarData(28, muted: true),
      _CalendarData(29, muted: true),
      _CalendarData(30, muted: true),
      _CalendarData(31, muted: true),

      _CalendarData(1),
      _CalendarData(2),
      _CalendarData(3),

      _CalendarData(4),
      _CalendarData(5),
      _CalendarData(6),
      _CalendarData(7),
      _CalendarData(8),
      _CalendarData(9),
      _CalendarData(10),

      _CalendarData(11),
      _CalendarData(12),
      _CalendarData(
        13,
        hasTask: true,
      ),
      _CalendarData(14),
      _CalendarData(15),
      _CalendarData(
        16,
        hasJournal: true,
      ),
      _CalendarData(17),

      _CalendarData(18),
      _CalendarData(
        19,
        hasTask: true,
      ),
      _CalendarData(20),
      _CalendarData(
        21,
        hasJournal: true,
      ),
      _CalendarData(
        22,
        selected: true,
        hasTask: true,
        hasJournal: true,
      ),
      _CalendarData(23),
      _CalendarData(24),

      _CalendarData(25),
      _CalendarData(26),
      _CalendarData(27),
      _CalendarData(
        28,
        hasTask: true,
      ),
      _CalendarData(29),
      _CalendarData(30),
      _CalendarData(31),
    ];

    return Column(
      children: [
        Row(
          children: weekdays
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            final cell = cells[index];

            return CalendarDayCell(
              day: cell.day,
              selected: cell.selected,
              muted: cell.muted,
              hasTask: cell.hasTask,
              hasJournal: cell.hasJournal,
            );
          },
        ),
      ],
    );
  }
}

class _CalendarData {
  final int day;
  final bool selected;
  final bool muted;
  final bool hasTask;
  final bool hasJournal;

  const _CalendarData(
    this.day, {
    this.selected = false,
    this.muted = false,
    this.hasTask = false,
    this.hasJournal = false,
  });
}