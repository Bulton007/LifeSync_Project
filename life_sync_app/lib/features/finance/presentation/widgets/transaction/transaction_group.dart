import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TransactionGroup extends StatelessWidget {
  final String title;
  final String? expenseTotal;
  final String? incomeTotal;
  final String? savingTotal;
  final List<Widget> children;

  const TransactionGroup({
    super.key,
    required this.title,
    required this.children,
    this.expenseTotal,
    this.incomeTotal,
    this.savingTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (incomeTotal != null) ...[
                Text(
                  incomeTotal!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],

              if (expenseTotal != null) ...[
                Text(
                  expenseTotal!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],

              if (savingTotal != null)
                Text(
                  savingTotal!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.info,
                  ),
                ),
            ],
          ),
        ),

        const Divider(),

        ...children,

        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}