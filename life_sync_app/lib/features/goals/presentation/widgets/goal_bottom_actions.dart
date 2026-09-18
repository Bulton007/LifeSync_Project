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
    final colors = context.lifeSyncColors;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: Row(
          children: [
            if (secondaryLabel != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondaryPressed ?? () {},
                  child: Text(
                    secondaryLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              flex: secondaryLabel == null ? 1 : 2,
              child: ElevatedButton(
                onPressed: primaryEnabled ? onPrimaryPressed ?? () {} : null,
                child: Text(
                  primaryLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
