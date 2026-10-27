import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../model/chapter_split_setting.dart';
import '../model/haptic_setting.dart';
import '../model/setting.dart';
import '../service/store_service.dart';

@singleton
class SettingsStoreManager(
  final CatchupSetting _catchupSetting,
  final ChapterSplitSetting _chapterSplitSetting,
  final HapticSetting _hapticSetting,
  final StoreService _storeService,
) {
  this {
    _init(_catchupSetting);
    _init(_chapterSplitSetting);
    _init(_hapticSetting);
  }

  void _init(Setting setting) {
    setting.value = _storeService.get(setting.storeKey) ?? setting.defaultValue;
    setting.addListener(() => _storeService.set(setting.storeKey, setting.value));
  }
}
