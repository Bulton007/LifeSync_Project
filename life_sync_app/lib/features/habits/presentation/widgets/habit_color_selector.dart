import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HabitColorSelector extends StatelessWidget {
  const HabitColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.error,
      Color(0xFF8B5CF6),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTextStyles.bodyPrimary.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          children: List.generate(
            colors.length,
            (index) {
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[index],
                  border: index == 0
                      ? Border.all(
                          color: AppColors.textPrimary,
                          width: 2,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}