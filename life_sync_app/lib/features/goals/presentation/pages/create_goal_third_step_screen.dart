import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

class CreateGoalThirdStepScreen extends StatelessWidget {
  const CreateGoalThirdStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back Button & Title
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: colors.border),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: colors.primaryText,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Create Goal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Multi-step Progress Tracker Indicator (Define -> Plan -> Review all active)
              Row(
                children: [
                  _buildStepIndicator(context, '1', 'Define', true),
                  Expanded(
                    child: Container(height: 2, color: colors.primaryBlue),
                  ),
                  _buildStepIndicator(context, '2', 'Plan', true),
                  Expanded(
                    child: Container(height: 2, color: colors.primaryBlue),
                  ),
                  _buildStepIndicator(context, '3', 'Review', true),
                ],
              ),
              const SizedBox(height: 24),

              // Goal Summary Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? colors.elevatedSurface : const Color(0xFFE8F1FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Color(0xFF2979FF),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Be an Outstanding Student',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2979FF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Outcome: Get 4.0 GPA on this Semester',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: colors.secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Started on 1 June 2026',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Color(0xFF2979FF),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Due 10 Oct 2026',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2979FF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Milestones Section Header
              Text(
                'Milestones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 12),

              // Milestones Preview List Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMilestonePreviewItem(
                      context,
                      '01',
                      'Build Strong Study Routine',
                    ),
                    _buildMilestonePreviewItem(
                      context,
                      '02',
                      'Build Strong Study Routine',
                    ),
                    _buildMilestonePreviewItem(
                      context,
                      '03',
                      'Build Strong Study Routine',
                    ),
                    _buildMilestonePreviewItem(
                      context,
                      '04',
                      'Build Strong Study Routine',
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Bottom Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2979FF),
                        side: const BorderSide(color: Color(0xFF2979FF)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Back & Edit',
                        style: TextStyle(
                          fontSize: 14,
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
                        // Handle final goal creation action here
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
                        'Create Goal',
                        style: TextStyle(
                          fontSize: 14,
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

  // Step Indicator Builder
  Widget _buildStepIndicator(
    BuildContext context,
    String stepNum,
    String label,
    bool isActive,
  ) {
    final colors = context.lifeSyncColors;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2979FF) : colors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.transparent : colors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            stepNum,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2979FF),
          ),
        ),
      ],
    );
  }

  // Milestone Preview List Item
  Widget _buildMilestonePreviewItem(
    BuildContext context,
    String number,
    String title, {
    bool isLast = false,
  }) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isDark ? colors.elevatedSurface : const Color(0xFFE8F1FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2979FF),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4 Tasks',
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: colors.secondaryText,
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: colors.divider, height: 1),
      ],
    );
  }
}
