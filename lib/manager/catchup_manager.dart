import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../model/virtual_all_done_date.dart';
import '../service/date_time_service.dart';
import 'app_lifecycle_manager.dart';
import 'feeds_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager(
  final AppLifecycleManager _appLifecycleManager,
  final CatchupSetting _catchupSetting,
  final DateTimeService _dateTimeService,
  final FeedsManager _feedsManager,
  final MidnightManager _midnightManager,
  final VirtualAllDoneDate _virtualAllDoneDate,
) with ChangeNotifier {
  this {
    _appLifecycleManager.onResume(notifyListeners);
    _midnightManager.addListener(notifyListeners);
    _virtualAllDoneDate.addListener(notifyListeners);
  }

  int get chaptersToRead => daysBehind * _feedsManager.feedManagers.length + _feedsManager.chaptersToRead;

  int get daysBehind {
    if (!_catchupSetting.value) return 0;
    return max(0, _dateTimeService.now.date.difference(_virtualAllDoneDate.value).inDays - 1);
  }

  int get daysBehindClamped {
    final upperLimit = 2;
    return daysBehind.clamp(0, upperLimit);
  }

  bool get isBehind => daysBehind > 0;

  bool get isVeryBehind => daysBehind > 1;
}
