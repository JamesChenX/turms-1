import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer._();

  static final Map<String, Timer> _keyToTimer = {};

  static void debounce(
    String key,
    Duration duration,
    VoidCallback callback,
  ) {
    if (duration == Duration.zero) {
      callback();
      cancel(key);
    } else {
      cancel(key);
      _keyToTimer[key] = Timer(
        duration,
        () {
          callback();
          cancel(key);
        },
      );
    }
  }

  static void cancel(String key) {
    _keyToTimer.remove(key)?.cancel();
  }

  static void clear() {
    _keyToTimer
      ..forEach((key, timer) {
        timer.cancel();
      })
      ..clear();
  }
}
