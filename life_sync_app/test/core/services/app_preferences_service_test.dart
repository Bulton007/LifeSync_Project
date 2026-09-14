import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

void main() {
  test('persists onboarding completion and first day choice', () async {
    final store = _MemoryStore();
    final first = AppPreferencesService(store);

    await first.restore();
    expect(first.onboardingCompleted.value, isFalse);
    expect(first.firstDayOfWeek.value, FirstDayOfWeek.monday);

    await first.completeOnboarding();
    await first.setFirstDay(FirstDayOfWeek.sunday);

    final restored = AppPreferencesService(store);
    await restored.restore();
    expect(restored.onboardingCompleted.value, isTrue);
    expect(restored.firstDayOfWeek.value, FirstDayOfWeek.sunday);
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
