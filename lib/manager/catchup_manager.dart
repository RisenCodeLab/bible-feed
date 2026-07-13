import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'app_lifecycle_manager.dart';
import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager with ChangeNotifier {
  final AppLifecycleManager _appLifecycleManager;
  final CatchupSetting _catchupSetting;
  final DateTimeService _dateTimeService;
  final FeedsManager _feedsManager;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;
  final StoreService _storeService;

  CatchupManager(
    this._appLifecycleManager,
    this._catchupSetting,
    this._dateTimeService,
    this._feedsManager,
    this._feedsAdvanceManager,
    this._midnightManager,
    this._storeService,
  ) {
    _appLifecycleManager.onResume(notifyListeners);

    _feedsAdvanceManager.addListener(() {
      virtualAllDoneDate = isBehind ? virtualAllDoneDate + 1.days : _dateTimeService.now.date;
    });

    _catchupSetting.addListener(reset);
    _midnightManager.addListener(notifyListeners);

    virtualAllDoneDate = virtualAllDoneDate; // ensure default is stored
  }

  static const _storeKey = 'virtualAllDoneDate';

  DateTime get _defaultVirtualAllDoneDate => _dateTimeService.now.date - 1.days;

  //// public

  int get chaptersToRead => daysBehind * _feedsManager.feedManagers.length + _feedsManager.chaptersToRead;

  int get daysBehind {
    if (!_catchupSetting.value) return 0;
    return max(0, _dateTimeService.now.date.difference(virtualAllDoneDate).inDays - 1);
  }

  int get daysBehindClamped {
    final upperLimit = 2;
    return daysBehind.clamp(0, upperLimit);
  }

  bool get isBehind => daysBehind > 0;

  bool get isVeryBehind => daysBehind > 1;

  DateTime get virtualAllDoneDate => _storeService.get(_storeKey) ?? _defaultVirtualAllDoneDate;

  set virtualAllDoneDate(DateTime value) {
    _storeService.set(_storeKey, value);
    notifyListeners();
  }

  void reset() {
    virtualAllDoneDate = _defaultVirtualAllDoneDate;
  }
}
