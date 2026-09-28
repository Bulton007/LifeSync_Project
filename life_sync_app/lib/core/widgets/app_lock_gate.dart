import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/services/app_lock_service.dart';

class AppLockGate extends StatelessWidget {
  const AppLockGate({required this.lock, required this.child, super.key});

  final AppLockService lock;
  final Widget child;

  @override
  Widget build(BuildContext context) => Obx(() {
    final hidden = !lock.ready.value || lock.locked.value;
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeFocus(
          excluding: hidden,
          child: Offstage(offstage: hidden, child: child),
        ),
        if (hidden)
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 48),
                      const SizedBox(height: 16),
                      Text('LifeSync is locked'.tr),
                      if (lock.error.value != null) ...[
                        const SizedBox(height: 12),
                        Text(lock.error.value!.tr, textAlign: TextAlign.center),
                      ],
                      const SizedBox(height: 16),
                      if (!lock.ready.value || lock.busy.value)
                        const CircularProgressIndicator()
                      else
                        FilledButton(
                          onPressed: lock.unlock,
                          child: Text('Unlock'.tr),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  });
}
