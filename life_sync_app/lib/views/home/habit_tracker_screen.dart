import 'package:flutter/material.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  bool _isMorningRoutineExpanded = true;

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
              // Header: Back Button, Year/Month, Calendar Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    children: const [
                      Text(
                        '2026',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'January',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF1E88E5),
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar Strip Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCalendarDay('S', '19', false),
                  _buildCalendarDay('M', '20', false),
                  _buildCalendarDay('T', '21', false),
                  _buildCalendarDay('W', '22', true), // Selected day
                  _buildCalendarDay('T', '23', false),
                  _buildCalendarDay('F', '24', false),
                  _buildCalendarDay('S', '25', false),
                ],
              ),
              const SizedBox(height: 24),

              // Habit Tracker Section Header
              const Text(
                'Habit Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 16),

              // Habit Item 1 (Read 10 Pages - Done)
              _buildSimpleHabitCard(
                icon: Icons.menu_book,
                iconBg: Colors.purple.shade50,
                iconColor: Colors.purple,
                title: 'Read 10 Pages',
                streak: '🔥 168 Days Streaks',
                actionText: 'Done',
                isDone: true,
              ),
              const SizedBox(height: 12),

              // Habit Item 2 (Morning Routine - Expandable with sub-tasks)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.menu_book,
                                color: Color(0xFF1E88E5),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Morning Routine',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '🔥 168 Days Streaks',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Done Button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.more_horiz, color: Colors.grey),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isMorningRoutineExpanded =
                                      !_isMorningRoutineExpanded;
                                });
                              },
                              child: Icon(
                                _isMorningRoutineExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_isMorningRoutineExpanded) ...[
                      const SizedBox(height: 16),
                      _buildSubTask('Make Breakfast'),
                      _buildSubTask('Drink a Cup of Water'),
                      _buildSubTask('Make bed'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Habit Item 3 (Run for 20mn - Finished)
              _buildSimpleHabitCard(
                icon: Icons.directions_run,
                iconBg: Colors.cyan.shade50,
                iconColor: Colors.cyan,
                title: 'Run for 20mn',
                streak: '🔥 168 Days Streaks',
                actionText: 'Finished',
                isDone: true,
                isBlueAction: true,
              ),
              const SizedBox(height: 12),

              // Habit Item 4 (Read 10 Pages - Finished)
              _buildSimpleHabitCard(
                icon: Icons.menu_book,
                iconBg: Colors.blue.shade50,
                iconColor: const Color(0xFF1E88E5),
                title: 'Read 10 Pages',
                streak: '🔥 168 Days Streaks',
                actionText: 'Finished',
                isDone: true,
                isBlueAction: true,
              ),
              const SizedBox(height: 80),
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

  Widget _buildCalendarDay(String dayLetter, String dateNum, bool isSelected) {
    return Column(
      children: [
        Text(
          dayLetter,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E88E5) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            dateNum,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleHabitCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String streak,
    required String actionText,
    required bool isDone,
    bool isBlueAction = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    streak,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isBlueAction ? const Color(0xFFE8F1FC) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isBlueAction
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    if (!isBlueAction)
                      const Icon(Icons.check, size: 14, color: Colors.grey)
                    else
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF1E88E5),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isBlueAction
                            ? const Color(0xFF1E88E5)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubTask(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
