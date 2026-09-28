import 'package:life_sync_app/core/localization/app_translations.dart';
import 'package:life_sync_app/core/services/app_lock_service.dart';
import 'package:life_sync_app/core/widgets/app_lock_gate.dart';
import 'package:life_sync_app/core/localization/language_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/database/database_factory_init.dart';
import 'package:life_sync_app/core/di/initial_binding.dart';
import 'package:life_sync_app/core/routes/app_pages.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/theme/app_scroll_behavior.dart';
import 'package:life_sync_app/core/theme/app_theme.dart';
import 'package:life_sync_app/core/theme/theme_controller.dart';

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
              Text(
                'Something unexpected happened'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                label: Text('Return to Home'.tr),
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
  initLifeSyncDatabaseFactory();
  configureAppErrorHandling();
  final store = Get.isRegistered<SecureKeyValueStore>()
      ? Get.find<SecureKeyValueStore>()
      : Get.put<SecureKeyValueStore>(
          const FlutterSecureKeyValueStore(FlutterSecureStorage()),
          permanent: true,
        );
  final theme = Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>()
      : Get.put(ThemeController(store), permanent: true);
  final language = Get.isRegistered<LanguageController>()
      ? Get.find<LanguageController>()
      : Get.put(LanguageController(store), permanent: true);
  await Future.wait([theme.restore(), language.restore()]);
  runApp(LifeSyncApp());
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
    if (!Get.isRegistered<SecureKeyValueStore>()) {
      Get.put<SecureKeyValueStore>(
        const FlutterSecureKeyValueStore(FlutterSecureStorage()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(
        ThemeController(Get.find<SecureKeyValueStore>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(
        LanguageController(Get.find<SecureKeyValueStore>()),
        permanent: true,
      );
    }
    WidgetsBinding.instance.addObserver(this);
    if (!Get.isRegistered<AppLockService>()) {
      final lock = Get.put(
        AppLockService(Get.find<SecureKeyValueStore>(), PhoneAuthenticator()),
        permanent: true,
      );
      lock.restore();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Get.find<AppLockService>().onLifecycle(state);
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Get.find<LanguageController>().locale,
        fallbackLocale: const Locale('en'),
        supportedLocales: LanguageController.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        scrollBehavior: const AppScrollBehavior(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.startup,
        getPages: AppPages.pages,
        builder: (context, child) => AppLockGate(
          lock: Get.find<AppLockService>(),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
