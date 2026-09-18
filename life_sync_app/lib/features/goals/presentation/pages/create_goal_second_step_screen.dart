import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

class CreateGoalSecondStepScreen extends StatefulWidget {
  const CreateGoalSecondStepScreen({super.key});

  @override
  State<CreateGoalSecondStepScreen> createState() =>
      _CreateGoalSecondStepScreenState();
}

class _CreateGoalSecondStepScreenState
    extends State<CreateGoalSecondStepScreen> {
  // Toggles between Empty State and Filled-in State based on your image mockup
  bool _hasMilestones = false;

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

              // Multi-step Progress Tracker Indicator (Define -> Plan -> Review)
              Row(
                children: [
                  // Step 1: Define (Completed)
                  _buildStepIndicator('1', 'Define', false, isCompleted: true),
                  Expanded(
                    child: Container(height: 2, color: colors.primaryBlue),
                  ),
                  // Step 2: Plan (Active)
                  _buildStepIndicator('2', 'Plan', true),
                  Expanded(
                    child: Container(height: 2, color: colors.border),
                  ),
                  // Step 3: Review (Inactive)
                  _buildStepIndicator('3', 'Review', false),
                ],
              ),
              const SizedBox(height: 32),

              // Milestones Header & AI Assistant Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Milestones',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Set Milestones for Goal Progression',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _hasMilestones =
                            true; // Toggles to Filled-in state via AI Assistant
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark
                          ? colors.elevatedSurface
                          : const Color(0xFFE8F1FC),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Color(0xFF2979FF),
                    ),
                    label: const Text(
                      'A.I Assistant',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2979FF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Conditional Body: Empty State vs Filled-in State
              if (!_hasMilestones) ...[
                // Empty State View
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.cardSurface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 90,
                        decoration: BoxDecoration(
                          color: colors.inputSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MY GOALS!',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...List.generate(
                              4,
                              (_) => Container(
                                width: 60,
                                height: 4,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                color: colors.border,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You don't have any Milestones yet, ",
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.secondaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _hasMilestones =
                                    true; // Toggles to Filled-in state
                              });
                            },
                            child: const Text(
                              'Create one.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2979FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ] else ...[
                // Filled-in State View with Milestones List
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
                      _buildMilestoneItem(
                        context,
                        '01',
                        'Build Strong Study Routine',
                        isExpanded: true,
                      ),
                      const SizedBox(height: 12),
                      _buildMilestoneItem(
                        context,
                        '02',
                        'Build Strong Study Routine',
                        isExpanded: false,
                      ),
                      const SizedBox(height: 12),
                      _buildMilestoneItem(
                        context,
                        '03',
                        'Build Strong Study Routine',
                        isExpanded: false,
                      ),
                      const SizedBox(height: 12),
                      _buildMilestoneItem(
                        context,
                        '04',
                        'Build Strong Study Routine',
                        isExpanded: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],

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
                      onPressed: _hasMilestones ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        disabledBackgroundColor: isDark
                            ? colors.elevatedSurface
                            : const Color(0xFFEFEFF1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _hasMilestones ? 2 : 0,
                      ),
                      child: Text(
                        'Next : Review Goal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _hasMilestones
                              ? Colors.white
                              : colors.disabledText,
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

  // Step Indicator Widget Builder
  Widget _buildStepIndicator(
    String stepNum,
    String label,
    bool isActive, {
    bool isCompleted = false,
  }) {
    final colors = context.lifeSyncColors;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF2979FF)
                : colors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? Colors.transparent
                  : colors.border,
            ),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  stepNum,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : colors.secondaryText,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive || isCompleted
                ? const Color(0xFF2979FF)
                : colors.secondaryText,
          ),
        ),
      ],
    );
  }

  // Milestone Item Builder for Filled-in State
  Widget _buildMilestoneItem(
    BuildContext context,
    String number,
    String title, {
    bool isExpanded = false,
  }) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.inputSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.drag_indicator, size: 18, color: colors.secondaryText),
              const SizedBox(width: 8),
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
              const SizedBox(width: 10),
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
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF2979FF),
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Colors.redAccent,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 10),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 36.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.secondaryText,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Blahh Blahh Blahh',
                      style: TextStyle(fontSize: 12, color: colors.primaryText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
