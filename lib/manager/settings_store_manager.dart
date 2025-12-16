import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../model/chapter_split_setting.dart';
import '../model/haptic_setting.dart';
import '../model/setting.dart';
import '../service/store_service.dart';

@singleton
class SettingsStoreManager {
  final StoreService _storeService;

  SettingsStoreManager(
    this._storeService,
    CatchupSetting catchupSetting,
    ChapterSplitSetting chapterSplitSetting,
    HapticSetting hapticSetting,
  ) {
    _init(catchupSetting);
    _init(chapterSplitSetting);
    _init(hapticSetting);
  }

  void _init(Setting setting) {
    setting.value = _storeService.get(setting.storeKey) ?? setting.defaultValue;
    setting.addListener(() => _storeService.set(setting.storeKey, setting.value));
  }
}
