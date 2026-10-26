import 'dart:async';

abstract interface class TimerHelper {
  static Timer? _timer;

  static void throttle(Function fn, {int delay = 500}) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: delay), () {
      _timer = null;
      fn();
    });
  }

  static Timer? _debounceTimer;

  static void debounce(Function fn, {int delay = 500}) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(Duration(milliseconds: delay), () {
      _debounceTimer = null;
      fn();
    });
  }

  static void dispose() => _timer?.cancel();
}
