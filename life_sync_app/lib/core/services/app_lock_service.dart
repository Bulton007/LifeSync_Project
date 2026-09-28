import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';

abstract interface class DeviceAuthenticator {
  Future<bool> authenticate();
}

final class PhoneAuthenticator implements DeviceAuthenticator {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> authenticate() async {
    if (!await _auth.isDeviceSupported()) return false;
    return _auth.authenticate(
      localizedReason: 'Unlock LifeSync with your phone PIN or biometrics.'.tr,
      biometricOnly: false,
      persistAcrossBackgrounding: true,
    );
  }
}

final class AppLockService extends GetxService {
  AppLockService(this._store, this._auth);

  static const storageKey = 'security.device_lock';
  final SecureKeyValueStore _store;
  final DeviceAuthenticator _auth;
  final enabled = false.obs;
  final locked = true.obs;
  final ready = false.obs;
  final busy = false.obs;
  final error = RxnString();

  Future<void> restore() async {
    try {
      enabled.value = await _store.read(storageKey) == 'true';
      locked.value = enabled.value;
    } catch (_) {
      enabled.value = true;
      locked.value = true;
      error.value = 'Unable to read app lock settings. Please try again.';
    } finally {
      ready.value = true;
    }
  }

  void onLifecycle(AppLifecycleState state) {
    if (enabled.value && !busy.value && state != AppLifecycleState.resumed) {
      locked.value = true;
    }
  }

  Future<bool> setEnabled(bool value) async {
    if (!ready.value || busy.value) return false;
    busy.value = true;
    error.value = null;
    try {
      if (!await _auth.authenticate()) {
        error.value =
            'Authentication cancelled. Set up a phone screen lock and try again.';
        return false;
      }
      await _store.write(storageKey, value.toString());
      enabled.value = value;
      locked.value = false;
      return true;
    } catch (_) {
      error.value =
          'Could not change app lock. Check your phone screen lock and try again.';
      return false;
    } finally {
      busy.value = false;
    }
  }

  Future<void> unlock() async {
    if (!ready.value || busy.value || !locked.value) return;
    busy.value = true;
    error.value = null;
    try {
      if (await _auth.authenticate()) {
        locked.value = false;
      } else {
        error.value =
            'Authentication cancelled. Set up a phone screen lock and try again.';
      }
    } catch (_) {
      error.value = 'Unable to unlock. Please try again using your phone PIN.';
    } finally {
      busy.value = false;
    }
  }
}
