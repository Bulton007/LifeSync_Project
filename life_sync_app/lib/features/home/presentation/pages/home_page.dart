import 'package:flutter/material.dart';

import '../widgets/habits_card.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/progress_card.dart';
import '../widgets/today_tasks_card.dart';
import '../widgets/week_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                120,
              ),
              children: const [
                HomeHeader(),

                SizedBox(height: 18),

                WeekCalendar(),

                SizedBox(height: 22),

                ProgressCard(),

                SizedBox(height: 16),

                TodayTasksCard(),

                SizedBox(height: 16),

                HabitsCard(),
              ],
            ),

            const Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: HomeBottomNav(),
            ),
          ],
        ),
      ),
    );
  }
}