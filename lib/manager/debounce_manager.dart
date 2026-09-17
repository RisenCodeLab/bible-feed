import 'dart:async';

import 'package:injectable/injectable.dart';

@injectable // must not be a singleton
class DebounceManager {
  Timer? _timer;
  bool _isRunning = false;

  bool _tryAcquire(Duration delay) {
    if (_isRunning) return false;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer(delay, () => _isRunning = false);
    return true;
  }

  void run({required Duration delay, required void Function() fn}) {
    if (!_tryAcquire(delay)) return;
    fn();
  }

  Future<T?> runAsync<T>({required Duration delay, required Future<T> Function() fn}) {
    if (!_tryAcquire(delay)) return Future.value(null);
    return fn();
  }

  void dispose() {
    _timer?.cancel();
  }
}
