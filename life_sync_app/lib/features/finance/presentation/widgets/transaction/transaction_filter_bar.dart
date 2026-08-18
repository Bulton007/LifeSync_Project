import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TransactionFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const TransactionFilterBar({
    super.key,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labels = [
      'All',
      'Expense',
      'Income',
      'Saving',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final selected = index == selectedIndex;

            return Padding(
              padding: EdgeInsets.only(
                right: index == labels.length - 1
                    ? 0
                    : AppSpacing.sm,
              ),
              child: InkWell(
                onTap: () => onChanged?.call(index),
                borderRadius: BorderRadius.circular(
                  AppRadius.pill,
                ),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppRadius.pill,
                    ),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    labels[index],
                    style: AppTextStyles.caption.copyWith(
                      color: selected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}