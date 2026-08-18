import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SavingSummaryCard extends StatelessWidget {
  const SavingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.primary,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Saved',
            style: AppTextStyles.caption,
          ),

          const SizedBox(height: AppSpacing.xs),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$3,110.00',
                style: AppTextStyles.titleXL,
              ),

              const SizedBox(width: AppSpacing.sm),

              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'of \$8,130.00',
                  style: AppTextStyles.micro,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Text(
                '60.7% Achieved',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                ),
              ),

              const Spacer(),

              Text(
                '5 Goals Active',
                style: AppTextStyles.micro,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const LinearProgressIndicator(
              value: 0.607,
              minHeight: 5,
              backgroundColor: AppColors.disabled,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}