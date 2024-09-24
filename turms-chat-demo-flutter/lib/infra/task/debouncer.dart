import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({required this.timeout});

  // static final Map<String, Debouncer> _keyToDebouncer = {};

  final Duration timeout;
  Timer? _timer;

  void run(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(timeout, callback);
  }

  void cancel() {
    _timer?.cancel();
  }

// static void debounce(
//   String key,
//   Duration duration,
//   VoidCallback callback,
// ) {
//   if (duration == Duration.zero) {
//     callback();
//     cancel(key);
//   } else {
//     cancel(key);
//     _keyToTimer[key] = Timer(
//       duration,
//       () {
//         callback();
//         cancel(key);
//       },
//     );
//   }
// }
//
// static void cancel(String key) {
//   _keyToTimer.remove(key)?.cancel();
// }
//
// static void clear() {
//   _keyToTimer
//     ..forEach((key, timer) {
//       timer.cancel();
//     })
//     ..clear();
// }
}