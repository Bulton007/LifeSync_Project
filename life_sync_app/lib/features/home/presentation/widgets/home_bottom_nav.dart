import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: 68,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    selected: true,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.track_changes,
                    title: 'Goals',
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.bar_chart,
                    title: 'Finance',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 15),

        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.30,
                ),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFF0F0F2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}