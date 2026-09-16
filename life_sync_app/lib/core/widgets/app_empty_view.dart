import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';

final class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.svgAsset,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? svgAsset;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final showAction = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset!,
                height: 150,
                fit: BoxFit.contain,
              )
            else
              Icon(icon, color: AppColors.textSecondary, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleM,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyPrimary.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (showAction) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
