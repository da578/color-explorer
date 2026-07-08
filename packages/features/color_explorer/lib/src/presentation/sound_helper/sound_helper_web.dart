import 'dart:js_interop';

@JS('eval')
external void _eval(String code);

int _lastPlayTime = 0;

/// Plays a short synthesized beep sound on Web using the Web Audio API.
///
/// This implementation is throttled to prevent audio clipping.
void playBeepThrottled() {
  final now = DateTime.now().millisecondsSinceEpoch;
  if (now - _lastPlayTime < 80) {
    return;
  }
  _lastPlayTime = now;

  try {
    _eval('''
      (function() {
        var ctx = new (window.AudioContext || window.webkitAudioContext)();
        var osc = ctx.createOscillator();
        var gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.frequency.value = 600;
        gain.gain.setValueAtTime(0.02, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.00001, ctx.currentTime + 0.08);
        osc.start(ctx.currentTime);
        osc.stop(ctx.currentTime + 0.08);
      })();
    ''');
  } on Exception catch (_) {
    // Ignore errors if audio context is blocked or unsupported.
  }
}
