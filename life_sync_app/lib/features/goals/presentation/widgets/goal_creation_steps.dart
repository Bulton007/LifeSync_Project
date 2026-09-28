import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class GoalCreationSteps extends StatelessWidget {
  const GoalCreationSteps({super.key, required this.currentStep});
  final int currentStep;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    const labels = ['Define', 'Plan', 'Review'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < 3; index++) ...[
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < currentStep
                      ? colors.primaryBlue
                      : colors.cardSurface,
                  border: Border.all(
                    color: index <= currentStep
                        ? colors.primaryBlue
                        : colors.border,
                  ),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: index < currentStep
                        ? Colors.white
                        : colors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[index].tr,
                style: TextStyle(
                  fontSize: 10,
                  color: index <= currentStep
                      ? colors.primaryBlue
                      : colors.secondaryText,
                ),
              ),
            ],
          ),
          if (index < 2)
            Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                color: index < currentStep ? colors.primaryBlue : colors.border,
              ),
            ),
        ],
      ],
    );
  }
}
