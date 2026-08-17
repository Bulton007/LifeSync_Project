import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 5,
                  backgroundColor: Color(0xFFEDEFF3),
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.primary,
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFE6A5),
                  ),
                  child: const Text(
                    '🥱',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Progress",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Keep going! You're doing great.",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Column(
            children: [
              _ProgressValue(
                icon: Icons.assignment_outlined,
                value: '6/8',
                label: 'Tasks',
              ),
              SizedBox(height: 10),
              _ProgressValue(
                icon: Icons.sync,
                value: '2/4',
                label: 'Habits',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressValue extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ProgressValue({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF3F6FF),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}