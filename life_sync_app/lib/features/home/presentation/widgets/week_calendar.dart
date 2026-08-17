import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    const days = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    const dates = [
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            days.length,
            (index) {
              return SizedBox(
                width: 42,
                child: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: index == 3
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dates.length,
            (index) {
              final bool selected = index == 3;

              return Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  dates[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}