import 'package:flutter/services.dart';

void playFocusSoundPlatform(String soundName) {
  try {
    SystemSound.play(SystemSoundType.click);
  } catch (_) {}
}
