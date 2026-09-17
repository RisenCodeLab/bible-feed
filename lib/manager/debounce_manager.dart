import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DebounceManager {
  Duration delay = 10.milliseconds;

  Timer? _timer;
  bool _isRunning = false;

  void run(void Function() action) {
    if (_isRunning) return;
    _isRunning = true;

    action();

    _timer?.cancel();
    _timer = Timer(delay, () => _isRunning = false);
  }

  void dispose() {
    _timer?.cancel();
  }
}
