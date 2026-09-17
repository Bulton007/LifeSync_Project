import 'package:web/web.dart' as web;

void playFocusSoundPlatform(String soundName) {
  try {
    final ctx = web.AudioContext();
    final now = ctx.currentTime;

    switch (soundName) {
      case 'Meditation Gong':
        _playTone(ctx, 216.0, now, 1.8);
      case 'Clock Ticking':
        _playTone(ctx, 880.0, now, 0.08);
        _playTone(ctx, 660.0, now + 0.15, 0.08);
      case 'Gentle Rain':
        _playTone(ctx, 330.0, now, 1.2);
        _playTone(ctx, 392.0, now + 0.2, 1.0);
      case 'Completion Fanfare':
        _playTone(ctx, 440.0, now, 0.2);
        _playTone(ctx, 554.37, now + 0.18, 0.2);
        _playTone(ctx, 659.25, now + 0.36, 0.6);
      case 'Focus Bell':
      default:
        _playTone(ctx, 528.0, now, 1.4);
    }
  } catch (_) {}
}

void _playTone(web.AudioContext ctx, double freq, double startTime, double duration) {
  try {
    final osc = ctx.createOscillator();
    final gain = ctx.createGain();
    osc.frequency.value = freq;
    osc.connect(gain);
    gain.connect(ctx.destination);
    gain.gain.setValueAtTime(0.22, startTime);
    gain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);
    osc.start(startTime);
    osc.stop(startTime + duration);
  } catch (_) {}
}
