import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class HabitsCard extends StatelessWidget {
  const HabitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habits',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '1/4 Completed',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _habit(
            icon: Icons.wb_sunny_outlined,
            background: const Color(0xFFFFEAD7),
            iconColor: AppColors.warning,
            title: 'Morning Routine',
            subtitle: '🔥 168 Days Streaks',
          ),

          const SizedBox(height: 18),

          _habit(
            icon: Icons.menu_book,
            background: AppColors.primary50,
            iconColor: AppColors.success,
            title: 'Read 10 Pages',
            subtitle: '🔥 168 Days Streaks',
          ),

          const SizedBox(height: 16),

          _habit(
            icon: Icons.directions_run,
            background: const Color(0xFFDDF7F8),
            iconColor: const Color(0xFF56C6D3),
            title: 'Run 20 Minutes',
            subtitle: '🔥 168 Days Streaks',
          ),
        ],
      ),
    );
  }

  Widget _habit({
    required IconData icon,
    required Color background,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}