import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

enum TransactionVisualType {
  expense,
  income,
  saving,
}

class TransactionListItem extends StatelessWidget {
  final String title;
  final String time;
  final String amount;
  final IconData icon;
  final TransactionVisualType type;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final Color amountColor;
    final Color iconColor;
    final Color iconBackground;

    switch (type) {
      case TransactionVisualType.expense:
        amountColor = AppColors.error;
        iconColor = AppColors.textPrimary;
        iconBackground = AppColors.accent;
        break;

      case TransactionVisualType.income:
        amountColor = AppColors.success;
        iconColor = AppColors.success;
        iconBackground = AppColors.successMuted;
        break;

      case TransactionVisualType.saving:
        amountColor = AppColors.info;
        iconColor = AppColors.info;
        iconBackground = AppColors.infoMuted;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(
                AppRadius.md,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  time,
                  style: AppTextStyles.micro,
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: AppTextStyles.caption.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}