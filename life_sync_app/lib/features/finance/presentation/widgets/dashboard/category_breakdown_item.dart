import 'package:flutter/material.dart';

import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';

class CategoryBreakdownItem extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final IconData icon;
  final Color color;

  const CategoryBreakdownItem({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        double.tryParse(
              percentage.replaceAll('%', ''),
            ) ??
            0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(
                AppRadius.sm,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      amount,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: AppSpacing.sm,
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppRadius.pill,
                  ),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 4,
                    backgroundColor:
                        AppColors.disabled,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          SizedBox(
            width: 36,
            child: Text(
              percentage,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}