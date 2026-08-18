import 'package:flutter/material.dart';

import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';

class FinanceChartPlaceholder extends StatelessWidget {
  const FinanceChartPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Financial Overview',
                style: AppTextStyles.titleM,
              ),

              const Spacer(),

              Text(
                'Jan 2026',
                style: AppTextStyles.micro,
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Expanded(
            child: CustomPaint(
              painter: _SimpleFinanceChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(
                color: AppColors.success,
                label: 'Income',
              ),
              _LegendItem(
                color: AppColors.error,
                label: 'Expense',
              ),
              _LegendItem(
                color: AppColors.info,
                label: 'Saving',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),

        const SizedBox(width: 4),

        Text(
          label,
          style: AppTextStyles.micro,
        ),
      ],
    );
  }
}

class _SimpleFinanceChartPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final incomePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final expensePaint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final savingPaint = Paint()
      ..color = AppColors.info
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 4; i++) {
      final y = size.height * i / 5;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    Path incomePath = Path()
      ..moveTo(0, size.height * .75)
      ..lineTo(size.width * .2, size.height * .55)
      ..lineTo(size.width * .4, size.height * .62)
      ..lineTo(size.width * .6, size.height * .35)
      ..lineTo(size.width * .8, size.height * .42)
      ..lineTo(size.width, size.height * .18);

    Path expensePath = Path()
      ..moveTo(0, size.height * .62)
      ..lineTo(size.width * .2, size.height * .70)
      ..lineTo(size.width * .4, size.height * .52)
      ..lineTo(size.width * .6, size.height * .60)
      ..lineTo(size.width * .8, size.height * .48)
      ..lineTo(size.width, size.height * .58);

    Path savingPath = Path()
      ..moveTo(0, size.height * .85)
      ..lineTo(size.width * .2, size.height * .78)
      ..lineTo(size.width * .4, size.height * .72)
      ..lineTo(size.width * .6, size.height * .67)
      ..lineTo(size.width * .8, size.height * .60)
      ..lineTo(size.width, size.height * .55);

    canvas.drawPath(
      incomePath,
      incomePaint,
    );

    canvas.drawPath(
      expensePath,
      expensePaint,
    );

    canvas.drawPath(
      savingPath,
      savingPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}