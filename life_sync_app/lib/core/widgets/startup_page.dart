import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/theme/theme_controller.dart';
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
    final startTime = DateTime.now();
    if (Get.isRegistered<ThemeController>()) {
      await Get.find<ThemeController>().restore();
    }
    final preferences = Get.find<AppPreferencesService>();
    final sessionService = Get.find<AuthSessionService>();
    await preferences.restore();
    final session = await sessionService.restoreSession();
    if (!mounted) return;

    if (!Get.testMode) {
      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(milliseconds: 1400) - elapsed;
      if (remaining > Duration.zero) {
        await Future<void>.delayed(remaining);
      }
      if (!mounted) return;
    }

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
    const double logoSize = 320.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: .88, end: 1).animate(
              CurvedAnimation(parent: _animation, curve: Curves.easeOutBack),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: logoSize,
                    height: logoSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.glow,
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    LifeSyncSvgAssets.group11,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                    semanticsLabel: 'LifeSync',
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'LifeSync',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
