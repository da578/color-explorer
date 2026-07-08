import 'dart:async';

import 'package:flutter/services.dart';

int _lastPlayTime = 0;

/// Plays a short system click sound on native platforms.
///
/// This implementation is throttled to prevent audio clipping.
void playBeepThrottled() {
  final now = DateTime.now().millisecondsSinceEpoch;
  if (now - _lastPlayTime < 80) {
    return;
  }

  _lastPlayTime = now;
  unawaited(SystemSound.play(SystemSoundType.click));
}
