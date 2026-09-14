import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

enum ThemePreference { system, light, dark }

final class ThemeController extends GetxController {
  ThemeController(this._store);

  static const storageKey = 'appearance.theme_mode';

  final SecureKeyValueStore _store;
  final preference = ThemePreference.system.obs;

  ThemeMode get themeMode => switch (preference.value) {
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
    ThemePreference.system => ThemeMode.system,
  };

  Future<void> restore() async {
    final saved = await _store.read(storageKey);
    preference.value = ThemePreference.values.firstWhere(
      (value) => value.name == saved,
      orElse: () => ThemePreference.system,
    );
  }

  Future<void> select(ThemePreference value) async {
    if (preference.value == value) return;
    preference.value = value;
    await _store.write(storageKey, value.name);
  }
}
