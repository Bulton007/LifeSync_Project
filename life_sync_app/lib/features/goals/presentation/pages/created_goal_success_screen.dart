import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';

class CreatedGoalSuccessScreen extends StatelessWidget {
  const CreatedGoalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Journey illustration from Life-Sync SVG File (CreatedGoalSuccess.svg)
              SvgPicture.asset(
                LifeSyncSvgAssets.createdGoalSuccess,
                height: 260,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

              // Title Heading
              const Text(
                'The journey starts now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle Text
              Text(
                'Your goal is set — every step from here brings\nyou closer to your finish line.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 32),

              // Summary Info Cards Row (Milestones, Tasks, Due Date)
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      icon: Icons.flag_outlined,
                      label: 'Milestones',
                      value: '4',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      icon: Icons.assignment_outlined,
                      label: 'Tasks',
                      value: '24',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Due Date',
                      value: '10th Oct\n2026',
                      isSmallValue: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Action Buttons Row (View Goal & Done)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle view goal action here
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2979FF),
                        side: const BorderSide(color: Color(0xFF2979FF)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View Goal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle done action here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for summary info cards
  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isSmallValue = false,
  }) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xFF2979FF)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallValue ? 12 : 20,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
                height: isSmallValue ? 1.2 : 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
