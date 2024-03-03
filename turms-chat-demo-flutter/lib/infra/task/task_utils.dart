import 'dart:async';

typedef Callback = Future<bool> Function();

class TaskUtils {
  TaskUtils._();

  static final _idToCallback = <Object, Future<dynamic>>{};
  static final _idToTimer = <String, Timer>{};

  static Future<T> addTask<T>(
      {required Object id, required Future<T> Function() callback}) {
    final result = _idToCallback[id];
    if (result != null) {
      return result as Future<T>;
    }
    final value = callback();
    _idToCallback[id] = value;
    return value.whenComplete(() => _idToCallback.remove(id));
  }

  static bool addPeriodicTask(
      {required String id,
      required Duration duration,
      required Callback callback,
      bool runImmediately = false}) {
    final timer = _idToTimer[id];
    if (timer != null) {
      return false;
    }
    if (runImmediately) {
      callback();
    }
    _idToTimer[id] = Timer.periodic(duration, (timer) async {
      if (!await callback()) {
        timer.cancel();
      }
      _idToTimer.remove(id);
    });
    return true;
  }

  static void removeTask(String id) {
    _idToTimer.remove(id);
  }
}
