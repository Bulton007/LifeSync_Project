import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_circle_checkbox.dart';

class TaskTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String? subtitle;
  final bool completed;

  const TaskTimelineItem({
    super.key,
    required this.time,
    required this.title,
    this.subtitle,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              time,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const AppCircleCheckbox(
            value: false,
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyPrimary.copyWith(
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTextStyles.micro,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}