import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TransactionTypeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const TransactionTypeSelector({
    super.key,
    this.selectedIndex = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Income',
      'Expense',
      'Transfer',
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(
          AppRadius.md,
        ),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final selected = index == selectedIndex;

            return Expanded(
              child: InkWell(
                onTap: () {
                  onChanged?.call(index);
                },
                borderRadius: BorderRadius.circular(
                  AppRadius.md,
                ),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppRadius.md,
                    ),
                    border: selected
                        ? Border.all(
                            color: AppColors.error,
                          )
                        : null,
                  ),
                  child: Text(
                    labels[index],
                    style: AppTextStyles.caption.copyWith(
                      color: selected
                          ? AppColors.error
                          : AppColors.textSecondary,
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