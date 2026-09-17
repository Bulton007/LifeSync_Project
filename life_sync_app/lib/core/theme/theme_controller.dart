import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

enum ThemePreference { system, light, dark }

final class ThemeController extends GetxController {
  ThemeController(this._store);

  static const storageKey = 'appearance.theme_mode';

  final SecureKeyValueStore _store;
  final preference = ThemePreference.system.obs;

  @override
  void onInit() {
    super.onInit();
    restore();
  }

  ThemeMode get themeMode => switch (preference.value) {
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
    ThemePreference.system => ThemeMode.system,
  };

  bool get isDarkMode {
    if (preference.value == ThemePreference.dark) return true;
    if (preference.value == ThemePreference.light) return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  Future<void> restore() async {
    try {
      final saved = await _store.read(storageKey);
      if (saved != null && saved.isNotEmpty) {
        preference.value = ThemePreference.values.firstWhere(
          (value) => value.name == saved,
          orElse: () => ThemePreference.system,
        );
      }
    } catch (_) {}
    Get.changeThemeMode(themeMode);
  }

  Future<void> select(ThemePreference value) async {
    if (preference.value == value) return;
    preference.value = value;
    await _store.write(storageKey, value.name);
    Get.changeThemeMode(themeMode);
    update();
  }
}
