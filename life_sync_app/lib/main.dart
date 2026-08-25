import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:life_sync_app/features/finance/presentation/pages/finance/finance_page.dart';
import 'package:life_sync_app/features/finance/presentation/pages/finance/financial_analysis_page.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goals_page.dart';
import 'package:life_sync_app/features/home/presentation/pages/home_page.dart';


import 'core/constants/app_info.dart';
import 'core/theme/app_theme.dart';
=======
import 'package:life_sync_app/views/authentication/sign_in_screen.dart';

>>>>>>> f41debb (done all screens)

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
<<<<<<< HEAD
      title: AppInfo.appName,
      theme: AppTheme.light,
      home: const HomePage(),
=======
      home: SignInScreen(),
>>>>>>> f41debb (done all screens)
    );
  }
}