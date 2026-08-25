import 'package:flutter/material.dart';

class GoalTrackerScreen extends StatefulWidget {
  const GoalTrackerScreen({super.key});

  @override
  State<GoalTrackerScreen> createState() => _GoalTrackerScreenState();
}

class _GoalTrackerScreenState extends State<GoalTrackerScreen> {
  int _selectedNavIndex = 1; // Goals tab active by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title & Subtitle
              const Text(
                'Goals',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Turn your intentions into progress.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // Overview Card Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Circular Progress Indicator
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: 0.63,
                                  strokeWidth: 9,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF2979FF),
                                      ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '63%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Overall Progress',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Stats Summary List
                        Expanded(
                          child: Column(
                            children: [
                              _buildStatRow(
                                'Active Goals',
                                '5',
                                const Color(0xFF2979FF),
                                const Color(0xFF2979FF),
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Completed',
                                '3',
                                Colors.green,
                                Colors.green,
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Inactive Goals',
                                '1',
                                Colors.redAccent,
                                Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Weekly Growth Indicator
                    Row(
                      children: const [
                        Icon(Icons.trending_up, color: Colors.green, size: 16),
                        SizedBox(width: 6),
                        Text(
                          '8.2% This week',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Goals Progress Section Header
              const Text(
                'Goals Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Goal Card 1: Active
              _buildGoalCard(
                icon: Icons.school,
                iconBg: const Color(0xFFE8F1FC),
                iconColor: const Color(0xFF2979FF),
                title: 'Be an Outstanding Student',
                outcome: 'Get 4.0 GPA on this Semester',
                dueDate: 'Due 10 Oct 2026',
                statusBadge: '82 Days Left',
                badgeColor: const Color(0xFFE8F1FC),
                badgeTextColor: const Color(0xFF2979FF),
                progressColors: [
                  const Color(0xFF2979FF),
                  const Color(0xFFBBDEFB),
                  const Color(0xFFEEEEEE),
                  const Color(0xFFEEEEEE),
                ],
                milestonesText: '1/4 Milestones',
                hasNextAction: true,
                actionTitle: 'Finish Chapter 2 Syllabus',
                actionSubtitle: '3 Tasks Remain in 3rd Milestones',
              ),
              const SizedBox(height: 16),

              // Goal Card 2: Completed
              _buildGoalCard(
                icon: Icons.school,
                iconBg: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00BFA5),
                title: 'Be an Outstanding Student',
                outcome: 'Get 4.0 GPA on this Semester',
                dueDate: 'Due N/A',
                statusBadge: 'Completed',
                badgeColor: const Color(0xFFE0F2F1),
                badgeTextColor: const Color(0xFF00BFA5),
                progressColors: [
                  const Color(0xFF00BFA5),
                  const Color(0xFF00BFA5),
                  const Color(0xFF00BFA5),
                  const Color(0xFF00BFA5),
                ],
                milestonesText: '4/4 Milestones',
                isHighlightedBorder: true,
                highlightColor: const Color(0xFF80CBC4),
              ),
              const SizedBox(height: 16),

              // Goal Card 3: Inactive
              _buildGoalCard(
                icon: Icons.school,
                iconBg: const Color(0xFFF5F5F5),
                iconColor: Colors.grey.shade600,
                title: 'Be an Outstanding Student',
                outcome: 'Get 4.0 GPA on this Semester',
                dueDate: 'Due N/A',
                statusBadge: 'Inactive',
                badgeColor: const Color(0xFFEEEEEE),
                badgeTextColor: Colors.grey.shade600,
                progressColors: [
                  Colors.grey.shade700,
                  const Color(0xFFEEEEEE),
                  const Color(0xFFEEEEEE),
                  const Color(0xFFEEEEEE),
                ],
                milestonesText: '1/4 Milestones',
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      // Floating / Styled Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.track_changes, 'Goals', 1),
            _buildNavItem(Icons.bar_chart, 'Finance', 2),
            _buildNavItem(Icons.grid_view, 'More', 3),
            // AI / Planet Assistant Action Button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF8E24AA), Color(0xFF1E88E5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Stat item row builder with left accent border
  Widget _buildStatRow(
    String label,
    String value,
    Color valueColor,
    Color barColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Goal Card Builder
  Widget _buildGoalCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String outcome,
    required String dueDate,
    required String statusBadge,
    required Color badgeColor,
    required Color badgeTextColor,
    required List<Color> progressColors,
    required String milestonesText,
    bool hasNextAction = false,
    String? actionTitle,
    String? actionSubtitle,
    bool isHighlightedBorder = false,
    Color? highlightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlightedBorder ? highlightColor! : Colors.grey.shade200,
          width: isHighlightedBorder ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),

          // Outcome & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Outcome: $outcome',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: badgeTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusBadge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            dueDate,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 14),

          // Progress Milestone Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Progress:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                milestonesText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Segmented Progress Bar
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0),
                  height: 6,
                  decoration: BoxDecoration(
                    color: progressColors[index],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),

          // Next Action Section (if applicable)
          if (hasNextAction) ...[
            const SizedBox(height: 14),
            Text(
              'Next Action',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actionTitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actionSubtitle!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Text(
                    'View Detail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2979FF),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                ),
                child: const Text(
                  'View Detail',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2979FF),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Navigation Item Builder
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F1FC) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2979FF) : Colors.grey,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
