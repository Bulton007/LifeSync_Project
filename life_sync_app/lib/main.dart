import 'package:flutter/material.dart';
import 'package:life_sync_app/features/finance/presentation/pages/finance/financial_analysis_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/goal/create_saving_goal_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/transaction/add_transaction_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/finance/finance_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/goal/saving_goals_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/transaction/transactions_page.dart';
import 'package:life_sync_app/features/habits/presentation/pages/create_habit_page.dart';
import 'package:life_sync_app/features/habits/presentation/pages/habit_tracker_page.dart';
import 'package:life_sync_app/features/home/presentation/pages/home_page.dart';

import 'core/constants/app_info.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const LifeSyncApp(),
  );
}

class LifeSyncApp extends StatelessWidget {
  const LifeSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppInfo.appName,
      theme: AppTheme.light,
      home: const FinancialAnalysisPage(),
    );
  }
}