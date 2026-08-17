import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'task_meta_row.dart';

class TaskForm extends StatelessWidget {
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;
  final bool compact;

  const TaskForm({
    super.key,
    this.titleController,
    this.descriptionController,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What do you need to get done today?',
          style: compact
              ? AppTextStyles.caption
              : AppTextStyles.bodyPrimary.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),

        const SizedBox(height: AppSpacing.sm),

        TextField(
          controller: titleController,
          autofocus: compact,
          maxLines: 2,
          minLines: 1,
          style: AppTextStyles.bodyPrimary,
          decoration: InputDecoration(
            hintText: 'Task title',
            hintStyle: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.textSecondary,
            ),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        const TaskMetaRow(),

        const SizedBox(height: AppSpacing.lg),

        TextField(
          controller: descriptionController,
          minLines: compact ? 2 : 5,
          maxLines: compact ? 4 : 8,
          style: AppTextStyles.bodyPrimary,
          decoration: InputDecoration(
            hintText: 'Add Description',
            hintStyle: AppTextStyles.caption,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}