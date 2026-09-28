import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/localization/app_translations.dart';
import 'package:life_sync_app/core/localization/language_controller.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

class _Store implements SecureKeyValueStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<void> delete(String key) async => values.remove(key);
}

void main() {
  test('persists Khmer and keeps English fallback', () async {
    Get.testMode = true;
    Get.addTranslations(AppTranslations().keys);
    final store = _Store();
    final controller = LanguageController(store);
    await controller.select('km');
    expect(store.values[LanguageController.storageKey], 'km');
    expect(controller.locale.languageCode, 'km');
    expect('Language'.tr, 'ភាសា');
    expect('All (@count)'.trParams({'count': '12'}), 'ទាំងអស់ (12)');
    expect(
      'Delete “@title” and its subtasks?'.trParams({'title': 'My task'}),
      'លុប «My task» និងកិច្ចការរងរបស់វាឬ?',
    );
    expect('Loading tasks…'.tr, 'កំពុងផ្ទុកកិច្ចការ…');
    await controller.select('en');
    expect('Language'.tr, 'Language');
    Get.reset();
  });
}
