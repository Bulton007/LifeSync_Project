import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'habit_check_item.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String streak;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final List<String> items;

  const HabitCard({
    super.key,
    required this.title,
    required this.streak,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleM,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      streak,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            for (int i = 0; i < items.length; i++) ...[
              HabitCheckItem(
                title: items[i],
                completed: i == items.length - 1,
              ),
              if (i != items.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        ],
      ),
    );
  }
}