import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/widgets/life_sync_bottom_navigation.dart';
import 'package:life_sync_app/features/calendar/presentation/pages/calendar_full_screen.dart';
import 'package:life_sync_app/features/finance/presentation/pages/financial_management_screen.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goal_tracker_screen.dart';
import 'package:life_sync_app/features/home/presentation/pages/home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    GoalTrackerScreen(),
    FinancialManagementScreen(),
    CalendarFullScreen(),
  ];

  void _selectTab(int index) {
    if (index < 0 || index >= _pages.length) {
      return;
    }

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: LifeSyncBottomNavigation(
        currentIndex: _currentIndex,
        onTabSelected: _selectTab,
        onAssistantPressed: () => Get.toNamed<void>(AppRoutes.assistant),
      ),
    );
  }
}
