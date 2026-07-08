/// A cross-platform utility to play a short beep sound.
library;

export 'sound_helper_stub.dart'
    if (dart.library.js_interop) 'sound_helper_web.dart'
    if (dart.library.io) 'sound_helper_native.dart';
