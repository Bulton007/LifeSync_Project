import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_circle_checkbox.dart';

class CalendarTaskItem extends StatelessWidget {
  final String title;
  final String time;
  final String priority;

  const CalendarTaskItem({
    super.key,
    required this.title,
    required this.time,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final high = priority == 'High';

    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const AppCircleCheckbox(
            value: false,
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.xs,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color:
                          AppColors.textSecondary,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      time,
                      style: AppTextStyles.micro,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: high
                  ? AppColors.errorMuted
                  : AppColors.primary50,
              borderRadius:
                  BorderRadius.circular(
                AppRadius.pill,
              ),
            ),
            child: Text(
              priority,
              style:
                  AppTextStyles.micro.copyWith(
                color: high
                    ? AppColors.error
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}