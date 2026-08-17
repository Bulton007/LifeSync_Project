import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CalendarDayCell extends StatelessWidget {
  final int day;
  final bool selected;
  final bool muted;
  final bool hasTask;
  final bool hasJournal;

  const CalendarDayCell({
    super.key,
    required this.day,
    this.selected = false,
    this.muted = false,
    this.hasTask = false,
    this.hasJournal = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? AppColors.primary
                : Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: AppTextStyles.bodyPrimary.copyWith(
                  color: selected
                      ? Colors.white
                      : muted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),

              if (hasTask || hasJournal)
                Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasTask)
                        _dot(
                          selected
                              ? Colors.white
                              : AppColors.primary,
                        ),

                      if (hasTask && hasJournal)
                        const SizedBox(width: 3),

                      if (hasJournal)
                        _dot(
                          selected
                              ? Colors.white
                              : AppColors.warning,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}