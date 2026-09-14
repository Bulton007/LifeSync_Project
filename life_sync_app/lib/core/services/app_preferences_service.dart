import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

enum FirstDayOfWeek { monday, sunday }

final class AppPreferencesService extends GetxService {
  AppPreferencesService(this._store);

  static const onboardingKey = 'onboarding.completed';
  static const firstDayKey = 'calendar.first_day';

  final SecureKeyValueStore _store;
  final onboardingCompleted = false.obs;
  final firstDayOfWeek = FirstDayOfWeek.monday.obs;
  bool _restored = false;

  Future<void> restore() async {
    if (_restored) return;
    final values = await Future.wait([
      _store.read(onboardingKey),
      _store.read(firstDayKey),
    ]);
    onboardingCompleted.value = values[0] == 'true';
    firstDayOfWeek.value = FirstDayOfWeek.values.firstWhere(
      (value) => value.name == values[1],
      orElse: () => FirstDayOfWeek.monday,
    );
    _restored = true;
  }

  Future<void> completeOnboarding() async {
    onboardingCompleted.value = true;
    await _store.write(onboardingKey, 'true');
  }

  Future<void> setFirstDay(FirstDayOfWeek value) async {
    firstDayOfWeek.value = value;
    await _store.write(firstDayKey, value.name);
  }
}
