import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'finance_stat_item.dart';

class FinanceBalanceCard extends StatelessWidget {
  const FinanceBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.primary,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total balance',
                style: AppTextStyles.caption,
              ),

              const Spacer(),

              const Icon(
                Icons.north_east_rounded,
                size: 15,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            '\$ 234.56',
            style: AppTextStyles.titleXL.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          const Row(
            children: [
              FinanceStatItem(
                title: 'Income',
                amount: '\$ 284.56',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),

              SizedBox(
                height: 38,
                child: VerticalDivider(),
              ),

              FinanceStatItem(
                title: 'Expense',
                amount: '\$ 50.00',
                icon: Icons.trending_down_rounded,
                color: AppColors.error,
              ),

              SizedBox(
                height: 38,
                child: VerticalDivider(),
              ),

              FinanceStatItem(
                title: 'Saving',
                amount: '\$ 70.00',
                icon: Icons.savings_outlined,
                color: AppColors.info,
              ),
            ],
          ),
        ],
      ),
    );
  }
}