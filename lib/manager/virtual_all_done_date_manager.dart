import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../model/virtual_all_done_date.dart';
import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'catchup_manager.dart';
import 'feeds_advance_manager.dart';

@singleton
class VirtualAllDoneDateManager(
  final CatchupManager _catchupManager,
  final CatchupSetting _catchupSetting,
  final DateTimeService _dateTimeService,
  final FeedsAdvanceManager _feedsAdvanceManager,
  final StoreService _storeService,
  final VirtualAllDoneDate _virtualAllDoneDate,
) {
  this {
    _catchupSetting.addListener(reset);
    _feedsAdvanceManager.addListener(_update);
    _virtualAllDoneDate.addListener(_store);

    // ensure default is stored
    _virtualAllDoneDate.value = _storeService.get<DateTime>(_storeKey) ?? _defaultValue;
  }

  static const _storeKey = 'virtualAllDoneDate';

  DateTime get _defaultValue => _dateTimeService.now.date - 1.days;

  void _store() => _storeService.set(_storeKey, _virtualAllDoneDate.value);

  void _update() {
    _virtualAllDoneDate.value = _catchupManager.isBehind
        ? _virtualAllDoneDate.value + 1.days
        : _dateTimeService.now.date;
  }

  void reset() => _virtualAllDoneDate.value = _defaultValue;
}
