import 'package:flutter/services.dart';
import 'dart:io';

Future<void> playFocusSoundPlatform(String soundName) async {
  try {
    if (Platform.isAndroid) {
      await const MethodChannel(
        'lifesync/focus_audio',
      ).invokeMethod<void>('play', soundName);
    } else {
      await SystemSound.play(SystemSoundType.alert);
    }
  } on PlatformException {
    await SystemSound.play(SystemSoundType.alert);
  } on MissingPluginException {
    await SystemSound.play(SystemSoundType.alert);
  }
}
