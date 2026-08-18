import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';



class AnalysisSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool isPositive;

  const AnalysisSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: color,
                  size: 18,
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Icon(
                    isPositive
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: isPositive
                        ? AppColors.success
                        : AppColors.error,
                    size: 14,
                  ),

                  const SizedBox(width: 2),

                  Text(
                    percentage,
                    style: AppTextStyles.micro.copyWith(
                      color: isPositive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            title,
            style: AppTextStyles.micro,
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            amount,
            style: AppTextStyles.titleM,
          ),
        ],
      ),
    );
  }
}