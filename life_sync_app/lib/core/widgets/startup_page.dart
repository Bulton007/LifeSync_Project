import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/features/user/data/datasources/user_remote_data_source.dart';

final class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

final class _StartupPageState extends State<StartupPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreSession());
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  Future<void> _restoreSession() async {
    final preferences = Get.find<AppPreferencesService>();
    final sessionService = Get.find<AuthSessionService>();
    await preferences.restore();
    final session = await sessionService.restoreSession();
    if (!mounted) return;

    if (session == null) {
      await Get.offAllNamed<void>(AppRoutes.onboarding);
      return;
    }

    var destination = AppRoutes.shell;
    final result = await UserRemoteDataSource(
      Get.find<ApiClient>(),
    ).getProfile(session.userId);
    result.when(
      success: (profile) {
        if (profile.fullName.trim().isEmpty || profile.email.trim().isEmpty) {
          destination = AppRoutes.profile;
        }
      },
      failure: (_) {
        // A temporary profile request failure must not invalidate a valid JWT.
      },
    );
    if (mounted) await Get.offAllNamed<void>(destination);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: .88, end: 1).animate(
              CurvedAnimation(parent: _animation, curve: Curves.easeOutBack),
            ),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.glow,
                    blurRadius: 42,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                LifeSyncSvgAssets.group11,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                semanticsLabel: 'LifeSync',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
