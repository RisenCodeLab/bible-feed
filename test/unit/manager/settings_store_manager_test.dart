import 'package:bible_feed/manager/settings_store_manager.dart';
import 'package:bible_feed/model/catchup_setting.dart';
import 'package:bible_feed/model/chapter_split_setting.dart';
import 'package:bible_feed/model/haptic_setting.dart';
import 'package:bible_feed/service/haptic_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_store_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StoreService>(), MockSpec<HapticService>()])
void main() {
  late MockHapticService hapticService;
  late MockStoreService storeService;

  late CatchupSetting catchupSetting;
  late ChapterSplitSetting chapterSplitSetting;
  late HapticSetting hapticSetting;

  setUp(() {
    hapticService = MockHapticService();
    storeService = MockStoreService();

    when(hapticService.isAvailable).thenReturn(true);

    catchupSetting = CatchupSetting();
    chapterSplitSetting = ChapterSplitSetting();
    hapticSetting = HapticSetting(hapticService);
  });

  test('initializes settings from defaults when store empty', () {
    SettingsStoreManager(storeService, catchupSetting, chapterSplitSetting, hapticSetting);

    expect(catchupSetting.value, catchupSetting.defaultValue);
    expect(chapterSplitSetting.value, chapterSplitSetting.defaultValue);
    expect(hapticSetting.value, hapticSetting.defaultValue);
  });

  test('initializes settings from store when values exist', () {
    when(storeService.get(catchupSetting.storeKey)).thenReturn(true);
    when(storeService.get(chapterSplitSetting.storeKey)).thenReturn(false);
    when(storeService.get(hapticSetting.storeKey)).thenReturn(false);

    SettingsStoreManager(storeService, catchupSetting, chapterSplitSetting, hapticSetting);

    expect(catchupSetting.value, true);
    expect(chapterSplitSetting.value, false);
    expect(hapticSetting.value, false);
  });

  test('persists setting changes to store', () {
    SettingsStoreManager(storeService, catchupSetting, chapterSplitSetting, hapticSetting);

    catchupSetting.value = !catchupSetting.defaultValue;
    chapterSplitSetting.value = !chapterSplitSetting.defaultValue;
    hapticSetting.value = !hapticSetting.defaultValue;

    verify(storeService.set(catchupSetting.storeKey, catchupSetting.value)).called(1);
    verify(storeService.set(chapterSplitSetting.storeKey, chapterSplitSetting.value)).called(1);
    verify(storeService.set(hapticSetting.storeKey, hapticSetting.value)).called(1);
  });
}
