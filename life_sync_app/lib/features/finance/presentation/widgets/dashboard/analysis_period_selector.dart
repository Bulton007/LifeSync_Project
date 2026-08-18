import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';


class AnalysisPeriodSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const AnalysisPeriodSelector({
    super.key,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Monthly',
      'Quarterly',
      'Yearly',
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
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppRadius.md,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[index],
                    style: AppTextStyles.caption.copyWith(
                      color: selected
                          ? Colors.white
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