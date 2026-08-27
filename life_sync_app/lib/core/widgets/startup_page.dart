import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';

final class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

final class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreSession());
  }

  Future<void> _restoreSession() async {
    final session = await Get.find<AuthSessionService>().restoreSession();
    if (!mounted) return;
    await Get.offAllNamed<void>(
      session == null ? AppRoutes.signIn : AppRoutes.shell,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoadingView(message: 'Starting LifeSync…'));
  }
}
