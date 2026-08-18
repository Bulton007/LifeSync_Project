import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SavingGoalPreviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const SavingGoalPreviewCard({
    super.key,
    required this.title,
    required this.amount,
    required this.progress,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    AppRadius.sm,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: color,
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Row(
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.micro.copyWith(
                  color: color,
                ),
              ),

              const Spacer(),

              Text(
                amount,
                style: AppTextStyles.micro,
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppRadius.pill,
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.disabled,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}