import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.accent,
        minimumSize: const Size(36, 36),
        maximumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(
        Icons.chevron_left_rounded,
        size: 22,
        color: AppColors.textPrimary,
      ),
    );
  }
}