import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_theme.dart';
import 'package:life_sync_app/core/theme/theme_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('restores light, dark, and system theme preferences', () async {
    final store = _MemoryStore();
    final controller = ThemeController(store);

    await controller.select(ThemePreference.dark);
    expect(controller.themeMode, ThemeMode.dark);
    expect(store.values[ThemeController.storageKey], 'dark');

    final restored = ThemeController(store);
    await restored.restore();
    expect(restored.preference.value, ThemePreference.dark);

    await restored.select(ThemePreference.light);
    expect(restored.themeMode, ThemeMode.light);

    await restored.select(ThemePreference.system);
    expect(restored.themeMode, ThemeMode.system);
  });

  test('light and dark themes expose the semantic color extension', () {
    expect(
      AppTheme.light.extension<LifeSyncColors>()?.pageBackground,
      LifeSyncColors.light.pageBackground,
    );
    expect(
      AppTheme.dark.extension<LifeSyncColors>()?.pageBackground,
      LifeSyncColors.dark.pageBackground,
    );
    expect(
      AppTheme.dark.scaffoldBackgroundColor,
      isNot(AppTheme.dark.colorScheme.surface),
    );
  });
}

final class _MemoryStore implements SecureKeyValueStore {
  final values = <String, String>{};

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
