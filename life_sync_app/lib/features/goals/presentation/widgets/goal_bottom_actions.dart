import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class GoalBottomActions extends StatelessWidget {
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool primaryEnabled;

  const GoalBottomActions({
    super.key,
    required this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (secondaryLabel != null) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onSecondaryPressed ?? () {},
                child: Text(secondaryLabel!),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            flex: secondaryLabel == null ? 1 : 2,
            child: ElevatedButton(
              onPressed: primaryEnabled ? onPrimaryPressed ?? () {} : null,
              child: Text(primaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}
