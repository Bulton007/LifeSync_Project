import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/widgets/life_sync_bottom_navigation.dart';
import 'package:life_sync_app/features/finance/presentation/pages/financial_management_screen.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goal_tracker_screen.dart';
import 'package:life_sync_app/features/home/presentation/pages/home_screen.dart';
import 'package:life_sync_app/features/settings/presentation/pages/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final List<int> _tabHistory = [0];

  late final List<Widget> _pages = [
    const HomeScreen(),
    const GoalTrackerScreen(),
    const FinancialManagementScreen(),
    SettingsScreen(
      onBackPressed: _handleBackToPreviousTab,
    ),
  ];

  void _selectTab(int index) {
    if (index < 0 || index >= _pages.length) {
      return;
    }

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _tabHistory.remove(index);
      _tabHistory.add(index);
      _currentIndex = index;
    });
  }

  void _handleBackToPreviousTab() {
    if (_tabHistory.length > 1) {
      setState(() {
        _tabHistory.removeLast();
        _currentIndex = _tabHistory.last;
      });
    } else if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
        _tabHistory.clear();
        _tabHistory.add(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0 && _tabHistory.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _handleBackToPreviousTab();
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: LifeSyncBottomNavigation(
          currentIndex: _currentIndex,
          onTabSelected: _selectTab,
          onAssistantPressed: () => Get.toNamed<void>(AppRoutes.assistant),
        ),
      ),
    );
  }
}
