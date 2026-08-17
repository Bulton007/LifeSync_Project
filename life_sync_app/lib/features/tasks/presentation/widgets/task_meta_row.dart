import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskMetaRow extends StatelessWidget {
  const TaskMetaRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _MetaItem(
          icon: Icons.calendar_today_outlined,
          label: 'Today, 22 Wed',
          color: AppColors.primary,
        ),
        const _MetaItem(
          icon: Icons.schedule_outlined,
          label: 'None',
        ),
        const _MetaItem(
          icon: Icons.outlined_flag_rounded,
          label: 'Normal',
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaItem({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: effectiveColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: effectiveColor,
          ),
        ),
        const SizedBox(width: 2),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 16,
          color: effectiveColor,
        ),
      ],
    );
  }
}