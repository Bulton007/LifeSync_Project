import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/di/initial_binding.dart';
import 'package:life_sync_app/core/routes/app_pages.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _enableAndroidImmersiveMode();

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
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.startup,
      getPages: AppPages.pages,
    );
  }
}
