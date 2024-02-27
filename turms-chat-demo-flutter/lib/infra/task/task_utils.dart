import 'dart:async';

typedef Callback = Future<bool> Function();

class TaskUtils {
  TaskUtils._();

  static final _idToCallback = <Object, Future<dynamic>>{};
  static final _nameToTimer = <String, Timer>{};

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
      {required String name,
      required Duration duration,
      required Callback callback,
      bool runImmediately = false}) {
    final timer = _nameToTimer[name];
    if (timer != null) {
      return false;
    }
    if (runImmediately) {
      callback();
    }
    _nameToTimer[name] = Timer.periodic(duration, (timer) async {
      if (!await callback()) {
        timer.cancel();
      }
      _nameToTimer.remove(name);
    });
    return true;
  }
}
