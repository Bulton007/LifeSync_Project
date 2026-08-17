import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = foregroundColor ?? AppColors.primary;

    return Material(
      color: backgroundColor ?? AppColors.primary50,
      borderRadius: BorderRadius.circular(
        AppRadius.pill,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppRadius.pill,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 4),
              ],

              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}