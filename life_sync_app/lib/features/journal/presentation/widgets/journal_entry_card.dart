import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'journal_tag_chip.dart';

class JournalEntryCard extends StatelessWidget {
  final String title;
  final String preview;
  final String date;
  final String? mood;
  final List<String> tags;
  final VoidCallback? onTap;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.preview,
    required this.date,
    this.mood,
    this.tags = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppRadius.lg,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppRadius.lg,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleM,
                    ),
                  ),

                  if (mood != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      mood!,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                date,
                style: AppTextStyles.micro,
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                preview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyPrimary.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              if (tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),

                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: tags
                      .map(
                        (tag) => JournalTagChip(
                          label: tag,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}