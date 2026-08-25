import 'package:flutter/material.dart';
import 'package:life_sync_app/views/authentication/sign_in_screen.dart';


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
      home: SignInScreen(),
    );
  }
}