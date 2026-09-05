import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalDateItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const GoalDateItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro,
          ),
        ),
      ],
    );
  }
}
