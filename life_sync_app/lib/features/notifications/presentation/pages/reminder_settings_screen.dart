import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/notification_delivery_service.dart';

class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final service = Get.find<NotificationDeliveryService>();
    return Scaffold(
      appBar: AppBar(title: Text('Reminder'.tr)),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Enable phone notifications'.tr),
              subtitle: Text(
                (service.device.supported
                        ? 'Task, habit reminders and account alerts'
                        : 'Phone reminders are available on Android.')
                    .tr,
              ),
              value: service.enabled.value,
              onChanged: service.device.supported && !service.busy.value
                  ? service.setEnabled
                  : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Daily reminder time'.tr),
              subtitle: Text(
                TimeOfDay(
                  hour: service.hour.value,
                  minute: service.minute.value,
                ).format(context),
              ),
              trailing: const Icon(Icons.schedule),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: service.hour.value,
                    minute: service.minute.value,
                  ),
                );
                if (time != null) await service.setTime(time.hour, time.minute);
              },
            ),
            Text(
              'Incomplete tasks use the next reminder time if overdue. Habit reminders cover the next seven days; open LifeSync regularly to refresh them. Android may delay delivery to save battery.'
                  .tr,
            ),
            const SizedBox(height: 12),
            Text(
              'Scheduled tasks: @count'.trParams({
                'count': '${service.scheduledCount.value}',
              }),
            ),
            Text(
              'Habit reminder days: @count'.trParams({
                'count': '${service.scheduledHabitCount.value}',
              }),
            ),
            if (service.error.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  service.error.value!.tr,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: service.enabled.value
                  ? () => service.testNotification()
                  : null,
              child: Text('Send test notification'.tr),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: service.enabled.value
                  ? () async {
                      await service.testNotification(delayed: true);
                      if (context.mounted && service.error.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Test scheduled for about one minute. Put the app in the background.'
                                  .tr,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: Text('Test background reminder'.tr),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: service.device.supported
                  ? service.device.openSettings
                  : null,
              child: Text('Android notification settings'.tr),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: service.refresh, child: Text('Refresh'.tr)),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Notification history'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed<void>(AppRoutes.notifications),
            ),
            const SizedBox(height: 12),
            Text(
              'Account alerts refresh while LifeSync is open. Remote push delivery is not enabled yet.'
                  .tr,
            ),
          ],
        ),
      ),
    );
  }
}
