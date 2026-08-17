import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CalendarJournalItem extends StatelessWidget {
  final String title;
  final String preview;
  final String mood;

  const CalendarJournalItem({
    super.key,
    required this.title,
    required this.preview,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.warningMuted,
              borderRadius: BorderRadius.circular(
                AppRadius.sm,
              ),
            ),
            child: Text(
              mood,
              style: const TextStyle(
                fontSize: 21,
              ),
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.bodyPrimary.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.xs,
                ),

                Text(
                  preview,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
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
    );
  }
}