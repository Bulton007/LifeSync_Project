import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_sync_app/core/services/notification_delivery_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Samsung notification permission, posting, scheduling and cancellation',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                'LifeSync notification test\nAllow notification permission if prompted.\nYou may press Home during the scheduled test.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
      final device = AndroidNotificationDevice();
      final plugin = FlutterLocalNotificationsPlugin();
      const immediateId = -2000000001;
      const scheduledId = -2000000002;
      const cancelledId = -2000000003;
      await device.initialize((_) {});
      expect(
        await device.requestPermission(),
        isTrue,
        reason: 'Android notification permission must be allowed.',
      );
      expect(await device.isAllowed(), isTrue);
      try {
        await device.show(
          immediateId,
          'LifeSync device test',
          'Immediate notification delivery test.',
        );
        await Future<void>.delayed(const Duration(seconds: 2));
        expect(
          (await plugin.getActiveNotifications()).any(
            (item) => item.id == immediateId,
          ),
          isTrue,
        );
        debugPrint(
          'DEVICE_CHECK: immediate notification is present in Android notification manager.',
        );
        await device.schedule(
          cancelledId,
          DateTime.now().add(const Duration(minutes: 10)),
          'LifeSync cancellation test',
          'This reminder should be cancelled.',
        );
        expect(await device.pendingIds(), contains(cancelledId));
        await device.cancel(cancelledId);
        expect(await device.pendingIds(), isNot(contains(cancelledId)));
        debugPrint('DEVICE_CHECK: scheduled reminder cancellation passed.');
        await device.schedule(
          scheduledId,
          DateTime.now().add(const Duration(seconds: 15)),
          'LifeSync scheduled test',
          'Your scheduled notification was delivered.',
        );
        expect(await device.pendingIds(), contains(scheduledId));
        debugPrint(
          'DEVICE_CHECK: scheduled reminder armed; you may press Home now.',
        );
        final deadline = DateTime.now().add(const Duration(minutes: 3));
        var delivered = false;
        while (DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(seconds: 5));
          delivered = (await plugin.getActiveNotifications()).any(
            (item) => item.id == scheduledId,
          );
          if (delivered) break;
        }
        expect(
          delivered,
          isTrue,
          reason:
              'Scheduled notification was not observed within three minutes; inexact alarms can be delayed by Android.',
        );
        debugPrint(
          'DEVICE_CHECK: scheduled notification is present in Android notification manager.',
        );
      } finally {
        await device.cancel(immediateId);
        await device.cancel(scheduledId);
        await device.cancel(cancelledId);
      }
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );

  testWidgets('Samsung reaches deployed backend over HTTPS', (tester) async {
    const base = String.fromEnvironment('API_BASE_URL');
    expect(base, isNotEmpty);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);
    try {
      final request = await client.getUrl(Uri.parse('$base/api/health'));
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      expect(response.statusCode, 200);
      expect(
        (jsonDecode(await utf8.decoder.bind(response).join()) as Map)['status'],
        'UP',
      );
      debugPrint(
        'DEVICE_CHECK: backend health returned 200 UP from the phone.',
      );
    } finally {
      client.close(force: true);
    }
  });
}
