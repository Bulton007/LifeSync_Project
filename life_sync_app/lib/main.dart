import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/di/initial_binding.dart';
import 'package:life_sync_app/core/routes/app_pages.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_scroll_behavior.dart';
import 'package:life_sync_app/core/theme/app_theme.dart';

void configureAppErrorHandling() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFFF7F9FC),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync_problem_rounded,
                  color: Color(0xFF2979FF),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Something unexpected happened',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kDebugMode
                    ? details.exceptionAsString()
                    : 'Please tap below to refresh or return home.',
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  try {
                    Get.offAllNamed<void>(AppRoutes.shell);
                  } catch (_) {}
                },
                icon: const Icon(Icons.home_outlined, size: 18),
                label: const Text('Return to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _enableAndroidImmersiveMode();
  configureAppErrorHandling();

  runApp(const LifeSyncApp());
}

Future<void> _enableAndroidImmersiveMode() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return;
  }

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class LifeSyncApp extends StatefulWidget {
  const LifeSyncApp({super.key});

  @override
  State<LifeSyncApp> createState() => _LifeSyncAppState();
}

class _LifeSyncAppState extends State<LifeSyncApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enableAndroidImmersiveMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.startup,
      getPages: AppPages.pages,
    );
  }
}
