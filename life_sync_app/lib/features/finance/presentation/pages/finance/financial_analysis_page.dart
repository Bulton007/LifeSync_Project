import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';



class FinancialAnalysisPage extends StatelessWidget {
  const FinancialAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          child: Column(
            children: [
              // =====================================================
              // HEADER
              // =====================================================
              Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Financial Analysis',
                      style: AppTextStyles.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const _DropDownPill(
                    text: 'Month',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =====================================================
              // MONTH SELECTOR
              // =====================================================
              Row(
                children: [
                  const Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                  ),
                  Expanded(
                    child: Text(
                      'August 2026',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =====================================================
              // SUMMARY
              // =====================================================
              const _FinanceSummarySection(),

              const SizedBox(height: 14),

              // =====================================================
              // OVERVIEW
              // =====================================================
              const _OverviewTrendsCard(),

              const SizedBox(height: 14),

              // =====================================================
              // CATEGORIES
              // =====================================================
              const _CategoryCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SMALL COMMON WIDGETS
// ================================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF7F7F9),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 17,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _DropDownPill extends StatelessWidget {
  final String text;

  const _DropDownPill({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SUMMARY
// ================================================================

class _FinanceSummarySection extends StatelessWidget {
  const _FinanceSummarySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _SummaryItem(
              title: 'Income',
              amount: '\$ 284.56',
              comparison: '8.2% vs July',
              icon: Icons.trending_up_rounded,
              color: AppColors.success,
              mutedColor: AppColors.successMuted,
              positive: false,
            ),
          ),
          _SummaryDivider(),
          Expanded(
            child: _SummaryItem(
              title: 'Expense',
              amount: '\$ 50.00',
              comparison: '8.2% vs July',
              icon: Icons.trending_down_rounded,
              color: AppColors.error,
              mutedColor: AppColors.errorMuted,
              positive: true,
            ),
          ),
          _SummaryDivider(),
          Expanded(
            child: _SummaryItem(
              title: 'Savings',
              amount: '\$ 70.00',
              comparison: '8.2% vs July',
              icon: Icons.savings_outlined,
              color: AppColors.info,
              mutedColor: AppColors.infoMuted,
              positive: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      width: 1,
      color: AppColors.border,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String amount;
  final String comparison;
  final IconData icon;
  final Color color;
  final Color mutedColor;
  final bool positive;

  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.comparison,
    required this.icon,
    required this.color,
    required this.mutedColor,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mutedColor,
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: AppTextStyles.bodyPrimary.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              positive
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              size: 12,
              color: positive
                  ? AppColors.success
                  : AppColors.error,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                comparison,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  fontSize: 8,
                  color: positive
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================================================================
// OVERVIEW TREND
// ================================================================

class _OverviewTrendsCard extends StatelessWidget {
  const _OverviewTrendsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
                'Overview Trends',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const _DropDownPill(text: 'All'),
              const SizedBox(width: 8),
              const _DropDownPill(text: 'Weekly'),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          const SizedBox(
            height: 155,
            child: _BarChart(),
          ),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _LegendDot(
                label: 'Income',
                color: AppColors.success,
              ),
              SizedBox(width: 14),
              _LegendDot(
                label: 'Expense',
                color: AppColors.error,
              ),
              SizedBox(width: 14),
              _LegendDot(
                label: 'Saving',
                color: AppColors.info,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _axis('\$150'),
              _axis('\$100'),
              _axis('\$50'),
              const SizedBox(height: 18),
            ],
          ),
        ),
        const SizedBox(width: 4),
        const Expanded(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _ChartGrid(),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        _BarGroup(
                          income: 0.95,
                          expense: 0.58,
                          saving: 0.38,
                        ),
                        _BarGroup(
                          income: 0.06,
                          expense: 0.72,
                          saving: 0.10,
                        ),
                        _BarGroup(
                          income: 0,
                          expense: 0.50,
                          saving: 0.30,
                        ),
                        _BarGroup(
                          income: 0.25,
                          expense: 0.60,
                          saving: 0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: _XAxisText('1–7 Aug'),
                  ),
                  Expanded(
                    child: _XAxisText('8–14 Aug'),
                  ),
                  Expanded(
                    child: _XAxisText('15–21 Aug'),
                  ),
                  Expanded(
                    child: _XAxisText('22–31 Aug'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _axis(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (_) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border,
        ),
      ),
    );
  }
}

class _BarGroup extends StatelessWidget {
  final double income;
  final double expense;
  final double saving;

  const _BarGroup({
    required this.income,
    required this.expense,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 31,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ChartBar(
            value: income,
            color: AppColors.success,
          ),
          const SizedBox(width: 3),
          _ChartBar(
            value: expense,
            color: AppColors.error,
          ),
          const SizedBox(width: 3),
          _ChartBar(
            value: saving,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double value;
  final Color color;

  const _ChartBar({
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: value.clamp(0.0, 1.0),
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _XAxisText extends StatelessWidget {
  final String text;

  const _XAxisText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 8,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// CATEGORY CARD
// ================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sort by Categories',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const _DropDownPill(
                text: 'Expense',
              ),
              const SizedBox(width: 8),
              Text(
                'View All',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: _CategoryDonut(),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  children: [
                    _CategoryRow(
                      icon: Icons.restaurant_outlined,
                      title: 'Food',
                      amount: '\$ 213.24',
                      percentage: '75%',
                      color: AppColors.warning,
                      background:
                          Color(0xFFFFEEE0),
                      progress: .75,
                    ),
                    SizedBox(height: 8),
                    _CategoryRow(
                      icon:
                          Icons.account_balance_wallet_outlined,
                      title: 'Allowance',
                      amount: '\$ 213.24',
                      percentage: '75%',
                      color: Color(0xFF6958F5),
                      background:
                          Color(0xFFECE9FF),
                      progress: .75,
                    ),
                    SizedBox(height: 8),
                    _CategoryRow(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Allowance',
                      amount: '\$ 213.24',
                      percentage: '75%',
                      color: Color(0xFF4ABAC7),
                      background:
                          Color(0xFFE0F7FA),
                      progress: .75,
                    ),
                    SizedBox(height: 8),
                    _CategoryRow(
                      icon: Icons.more_horiz_rounded,
                      title: 'More',
                      amount: '\$ 213.24',
                      percentage: '75%',
                      color: AppColors.textSecondary,
                      background:
                          Color(0xFFF0F0F3),
                      progress: .75,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String percentage;
  final Color color;
  final Color background;
  final double progress;

  const _CategoryRow({
    required this.icon,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.background,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor:
                      const Color(0xFFEDEDF1),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    color,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 7),

        Text(
          amount,
          style: const TextStyle(
            fontSize: 8,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(width: 5),

        Text(
          percentage,
          style: TextStyle(
            fontSize: 8,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// DONUT CHART
// ================================================================

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(
            105,
            105,
          ),
          painter: _DonutPainter(),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Income',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '\$ 284.56',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = math.min(
          size.width,
          size.height,
        ) /
        2;

    const strokeWidth = 18.0;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final segments = <_DonutSegment>[
      const _DonutSegment(
        .27,
        AppColors.warning,
      ),
      const _DonutSegment(
        .20,
        Color(0xFF6958F5),
      ),
      const _DonutSegment(
        .16,
        AppColors.primary,
      ),
      const _DonutSegment(
        .14,
        AppColors.error,
      ),
      const _DonutSegment(
        .13,
        Color(0xFF4ABAC7),
      ),
      const _DonutSegment(
        .10,
        Color(0xFFFFD740),
      ),
    ];

    var startAngle = -math.pi / 2;

    const gap = 0.035;

    for (final segment in segments) {
      final sweep =
          (math.pi * 2 * segment.value) - gap;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

class _DonutSegment {
  final double value;
  final Color color;

  const _DonutSegment(
    this.value,
    this.color,
  );
}