import 'package:flutter/material.dart';

abstract class Setting<T> with ChangeNotifier {
  //// abstract

  T get defaultValue;

  String get storeKeyFragment;
  String get subtitle;
  String get title;

  //// concrete

  T? _value;

  bool isAvailable = true;

  String get storeKey => 'isEnabled.$storeKeyFragment';

  T get value => _value ?? defaultValue;

  set value(T value) {
    if (value == _value) return;
    _value = value;
    notifyListeners();
  }
}
