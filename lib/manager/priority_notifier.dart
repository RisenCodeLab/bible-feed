import 'package:flutter/foundation.dart';

import '../model/priority.dart';

mixin PriorityNotifier on ChangeNotifier {
  final Map<Priority, List<VoidCallback>> _listeners = {.high: [], .normal: [], .low: []};

  @override
  void addListener(VoidCallback listener, {Priority priority = .normal}) {
    _listeners[priority]!.add(listener);
  }

  @override
  void notifyListeners() {
    for (final priority in Priority.values) {
      for (final listener in List<VoidCallback>.of(_listeners[priority]!)) {
        listener();
      }
    }
  }
}
