import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';


class SavingGoalColorSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const SavingGoalColorSelector({
    super.key,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF48C7F0),
      Color(0xFF2E6B9E),
      Color(0xFF7B1FA2),
      Color(0xFFFFD740),
      Color(0xFFB43A16),
      Color(0xFF7567E8),
      Color(0xFFE43DE8),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: List.generate(
            colors.length,
            (index) {
              final selected = index == selectedIndex;

              return InkWell(
                onTap: () {
                  onChanged?.call(index);
                },
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(
                            color: AppColors.textPrimary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}