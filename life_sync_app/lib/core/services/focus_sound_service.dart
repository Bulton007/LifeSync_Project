import 'focus_sound_service_stub.dart'
    if (dart.library.io) 'focus_sound_service_io.dart'
    if (dart.library.js_interop) 'focus_sound_service_web.dart'
    if (dart.library.html) 'focus_sound_service_web.dart';

abstract final class FocusSoundService {
  static const List<String> availableSounds = [
    'Focus Bell',
    'Meditation Gong',
    'Clock Ticking',
    'Gentle Rain',
    'Completion Fanfare',
  ];

  static void play(String soundName) {
    playFocusSoundPlatform(soundName);
  }
}
