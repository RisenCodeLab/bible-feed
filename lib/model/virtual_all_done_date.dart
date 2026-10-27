import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VirtualAllDoneDate() with ChangeNotifier {
  DateTime _value = .now();

  DateTime get value => _value;

  set value(DateTime value) {
    _value = value;
    notifyListeners();
  }
}
