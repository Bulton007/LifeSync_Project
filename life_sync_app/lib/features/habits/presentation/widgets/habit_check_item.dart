import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_circle_checkbox.dart';

class HabitCheckItem extends StatelessWidget {
  final String title;
  final bool completed;

  const HabitCheckItem({
    super.key,
    required this.title,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCircleCheckbox(
          value: completed,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: completed
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              decoration:
                  completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}