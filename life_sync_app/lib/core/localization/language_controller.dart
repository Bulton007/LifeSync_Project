import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

final class LanguageController extends GetxController {
  LanguageController(this._store);
  static const storageKey = 'appearance.language';
  static const supportedLocales = [Locale('en'), Locale('km')];
  final SecureKeyValueStore _store;
  final languageCode = 'en'.obs;
  int _selectionVersion = 0;
  Locale get locale => Locale(languageCode.value);
  String get displayName => languageCode.value == 'km' ? 'ខ្មែរ' : 'English';

  @override
  void onInit() {
    super.onInit();
    restore();
  }

  Future<void> restore() async {
    final version = _selectionVersion;
    String? saved;
    try {
      saved = await _store.read(storageKey);
    } catch (_) {
      /* Use device default. */
    }
    if (version != _selectionVersion) return;
    final code = saved ?? Get.deviceLocale?.languageCode;
    languageCode.value = code == 'km' ? 'km' : 'en';
    await Get.updateLocale(locale);
  }

  Future<void> select(String code) async {
    if (!supportedLocales.any((value) => value.languageCode == code)) return;
    _selectionVersion++;
    // Persist first so a failed save is not presented as a saved preference.
    await _store.write(storageKey, code);
    languageCode.value = code;
    await Get.updateLocale(locale);
  }
}
