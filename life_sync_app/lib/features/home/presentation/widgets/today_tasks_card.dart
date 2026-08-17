import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class TodayTasksCard extends StatelessWidget {
  const TodayTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Tasks",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '3 remaining',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: 18,
                ),
                label: const Text('Add Task'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const TaskRow(
            time: '8:00AM',
            title: 'Finish Dashboard Design',
            priority: 'High',
            priorityColor: AppColors.error,
          ),

          const TaskRow(
            time: '9:00AM',
            title: 'Finish Dashboard Design',
            priority: 'High',
            priorityColor: AppColors.error,
          ),

          const TaskRow(
            time: '11:00AM',
            title: 'Finish Dashboard Design',
            priority: 'Normal',
            priorityColor: AppColors.primary,
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Expanded(
                child: Text(
                  'View All Tasks',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  final String time;
  final String title;
  final String priority;
  final Color priorityColor;

  const TaskRow({
    super.key,
    required this.time,
    required this.title,
    required this.priority,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
          ),

          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: priorityColor.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.outlined_flag,
                  size: 13,
                  color: priorityColor,
                ),
                const SizedBox(width: 3),
                Text(
                  priority,
                  style: TextStyle(
                    fontSize: 10,
                    color: priorityColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}