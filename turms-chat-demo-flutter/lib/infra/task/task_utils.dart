import 'dart:async';

typedef Callback = Future<bool> Function();

class TaskUtils {
  TaskUtils._();

  static final nameToTimer = <String, Timer>{};

  static bool addPeriodicTask(
      {required String name,
      required Duration duration,
      required Callback callback,
      bool runImmediately = false}) {
    final timer = nameToTimer[name];
    if (timer != null) {
      return false;
    }
    if (runImmediately) {
      callback();
    }
    nameToTimer[name] = Timer.periodic(duration, (timer) async {
      if (!await callback()) {
        timer.cancel();
      }
      nameToTimer.remove(name);
    });
    return true;
  }
}
