import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalCreationSteps extends StatelessWidget {
  final int currentStep;

  const GoalCreationSteps({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Define', 'Plan', 'Review'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final completed = index < currentStep;
          final active = index == currentStep;
          final highlighted = active || completed;

          return Expanded(
            flex: index == labels.length - 1 ? 0 : 1,
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: highlighted
                            ? AppColors.primary
                            : AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: highlighted
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: completed
                          ? const Icon(
                              Icons.check,
                              size: 15,
                              color: AppColors.textOnPrimary,
                            )
                          : Text(
                              '${index + 1}',
                              style: AppTextStyles.micro.copyWith(
                                color: active
                                    ? AppColors.textOnPrimary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      labels[index],
                      style: AppTextStyles.micro.copyWith(
                        color: highlighted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: highlighted
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                if (index < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        bottom: 18,
                      ),
                      decoration: BoxDecoration(
                        color: index < currentStep
                            ? AppColors.primary
                            : AppColors.disabled,
                        borderRadius: BorderRadius.circular(
                          AppRadius.pill,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}