import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/services/app_lock_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/widgets/app_lock_gate.dart';

void main() {
  test(
    'enable persists only after authentication; restart and resume lock',
    () async {
      final store = _Store();
      final auth = _Auth();
      final lock = AppLockService(store, auth);
      await lock.restore();
      expect(lock.locked.value, isFalse);
      expect(await lock.setEnabled(true), isFalse);
      expect(store.value, isNull);
      auth.accept = true;
      expect(await lock.setEnabled(true), isTrue);
      expect(store.value, 'true');
      lock.onLifecycle(AppLifecycleState.inactive);
      lock.onLifecycle(AppLifecycleState.resumed);
      expect(lock.locked.value, isTrue);
      await lock.unlock();
      expect(lock.locked.value, isFalse);
      final restored = AppLockService(store, auth);
      await restored.restore();
      expect(restored.locked.value, isTrue);
      auth.accept = false;
      expect(await restored.setEnabled(false), isFalse);
      expect(store.value, 'true');
      await restored.unlock();
      expect(restored.locked.value, isTrue);
      auth.accept = true;
      expect(await restored.setEnabled(false), isTrue);
      expect(store.value, 'false');
      restored.onLifecycle(AppLifecycleState.paused);
      expect(restored.locked.value, isFalse);
    },
  );

  test('storage and platform failures do not bypass an enabled lock', () async {
    final store = _Store()..fail = true;
    final auth = _Auth()..fail = true;
    final lock = AppLockService(store, auth);
    await lock.restore();
    expect(lock.locked.value, isTrue);
    await lock.unlock();
    expect(lock.locked.value, isTrue);
    auth.fail = false;
    auth.accept = true;
    expect(await lock.setEnabled(false), isFalse);
    expect(lock.enabled.value, isTrue);
    expect(lock.locked.value, isTrue);
  });

  test('duplicate requests and authentication lifecycle do not loop', () async {
    final auth = _Auth()..pending = Completer<bool>();
    final lock = AppLockService(_Store()..value = 'true', auth);
    await lock.restore();
    final unlocking = lock.unlock();
    await lock.unlock();
    expect(auth.calls, 1);
    lock.onLifecycle(AppLifecycleState.inactive);
    lock.onLifecycle(AppLifecycleState.resumed);
    auth.pending!.complete(true);
    await unlocking;
    expect(lock.locked.value, isFalse);
    lock.onLifecycle(AppLifecycleState.paused);
    expect(lock.locked.value, isTrue);
  });

  testWidgets('gate hides app content before restore and after cancellation', (
    tester,
  ) async {
    final auth = _Auth();
    final lock = AppLockService(_Store()..value = 'true', auth);
    await tester.pumpWidget(
      MaterialApp(
        home: AppLockGate(lock: lock, child: const Text('Private finances')),
      ),
    );
    expect(find.text('Private finances'), findsNothing);
    await lock.restore();
    await tester.pump();
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Private finances'), findsNothing);
    auth.accept = true;
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Private finances'), findsOneWidget);
    lock.onLifecycle(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text('Private finances'), findsNothing);
  });
}

class _Auth implements DeviceAuthenticator {
  bool accept = false;
  bool fail = false;
  int calls = 0;
  Completer<bool>? pending;
  @override
  Future<bool> authenticate() async {
    calls++;
    if (fail) throw StateError('Unavailable');
    return pending?.future ?? Future.value(accept);
  }
}

class _Store implements SecureKeyValueStore {
  String? value;
  bool fail = false;
  @override
  Future<String?> read(String key) async {
    if (fail) throw StateError('Unavailable');
    return value;
  }

  @override
  Future<void> write(String key, String next) async {
    if (fail) throw StateError('Unavailable');
    value = next;
  }

  @override
  Future<void> delete(String key) async => value = null;
}
