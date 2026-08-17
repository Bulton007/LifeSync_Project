import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;

  const AppFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Icon(
          icon,
          size: 26,
        ),
      ),
    );
  }
}