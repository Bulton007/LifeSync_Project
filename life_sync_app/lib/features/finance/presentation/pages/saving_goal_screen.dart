import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SavingGoalScreen extends StatelessWidget {
  const SavingGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_left, color: colors.primaryText),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),

              // Total Saved Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2979FF).withValues(alpha: 0.6)
                        : const Color(0xFF2979FF).withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Saved',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '5 Goals Active',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$3,110.00',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'of \$6,130.00',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '50.7% Achieved',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2979FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.507,
                        backgroundColor: colors.inputSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2979FF),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Saving Goals Header
              Text(
                'Saving Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 12),

              // Goal Items List
              _buildGoalItem(
                context: context,
                icon: Icons.beach_access,
                iconBg: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF00ACC1),
                title: 'Siem Reap Trip',
                date: 'Est. Complete on 31 March 2027',
                savedAmount: 'Saved \$72.00',
                totalAmount: '\$150.00',
                progress: 0.48,
                progressColor: const Color(0xFF00ACC1),
              ),
              const SizedBox(height: 12),

              _buildGoalItem(
                context: context,
                icon: Icons.school,
                iconBg: const Color(0xFFE8F5E9),
                iconColor: Colors.green,
                title: 'School Tuition',
                date: 'Est. Complete on 31 March 2027',
                savedAmount: 'Saved \$72.00',
                totalAmount: '\$150.00',
                progress: 0.48,
                progressColor: Colors.green,
              ),
              const SizedBox(height: 12),

              _buildGoalItem(
                context: context,
                icon: Icons.shield_outlined,
                iconBg: const Color(0xFFEDE7F6),
                iconColor: Colors.deepPurple,
                title: 'Emergency Fund',
                date: 'Est. Complete on 31 March 2027',
                savedAmount: 'Saved \$72.00',
                totalAmount: 'N/A',
                progress: 1.0,
                progressColor: Colors.deepPurple,
              ),
              const SizedBox(
                height: 80,
              ), // Bottom padding for FAB overlap safety
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2979FF),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Reusable builder for individual goal list cards
  Widget _buildGoalItem({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String date,
    required String savedAmount,
    required String totalAmount,
    required double progress,
    required Color progressColor,
  }) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? progressColor.withValues(alpha: 0.15) : iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.more_horiz, color: colors.secondaryText),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                savedAmount,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
              Text(
                totalAmount,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.inputSurface,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
