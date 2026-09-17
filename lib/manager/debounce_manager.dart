import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DebounceManager {
  Duration delay = 10.milliseconds;

  Timer? _timer;
  bool _isRunning = false;

  bool _tryAcquire() {
    if (_isRunning) return false;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer(delay, () => _isRunning = false);
    return true;
  }

  void run(void Function() action) {
    if (!_tryAcquire()) return;
    action();
  }

  Future<T?> runAsync<T>(Future<T> Function() action) {
    if (!_tryAcquire()) return Future.value(null);
    return action();
  }

  void dispose() {
    _timer?.cancel();
  }
}
