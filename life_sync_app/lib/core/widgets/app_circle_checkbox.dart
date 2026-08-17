import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppCircleCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback? onTap;
  final double size;

  const AppCircleCheckbox({
    super.key,
    required this.value,
    this.onTap,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value
              ? AppColors.primary
              : Colors.transparent,
          border: Border.all(
            color: value
                ? AppColors.primary
                : AppColors.disabledBackground,
            width: 1.2,
          ),
        ),
        child: value
            ? Icon(
                Icons.check_rounded,
                size: size * 0.62,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}