import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class RecentTransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final String amount;
  final bool isIncome;
  final bool isSaving;

  const RecentTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    this.isIncome = false,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    Color amountColor;

    if (isSaving) {
      amountColor = AppColors.info;
    } else if (isIncome) {
      amountColor = AppColors.success;
    } else {
      amountColor = AppColors.error;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}