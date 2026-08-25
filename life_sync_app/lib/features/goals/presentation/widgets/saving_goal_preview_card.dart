import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class SavingGoalPreviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const SavingGoalPreviewCard({
    super.key,
    required this.title,
    required this.amount,
    required this.progress,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final percentage = (safeProgress * 100).round();

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // ICON AND PERCENTAGE
              // ==================================================

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.sm,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.pill,
                      ),
                    ),
                    child: Text(
                      '$percentage%',
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // ==================================================
              // GOAL INFORMATION
              // ==================================================

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.button,
              ),

              const SizedBox(height: AppSpacing.xxs),

              Text(
                amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              // ==================================================
              // PROGRESS
              // ==================================================

              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppRadius.pill,
                ),
                child: LinearProgressIndicator(
                  value: safeProgress,
                  minHeight: 6,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}