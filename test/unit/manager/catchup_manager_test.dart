import 'package:bible_feed/manager/app_lifecycle_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/model/catchup_setting.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'catchup_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLifecycleManager>(),
  MockSpec<DateTimeService>(),
  MockSpec<FeedManager>(),
  MockSpec<FeedsAdvanceManager>(),
  MockSpec<FeedsManager>(),
  MockSpec<MidnightManager>(),
  MockSpec<StoreService>(),
])
void main() {
  late MockAppLifecycleManager mockAppLifecycleManager;
  late MockDateTimeService mockDateTimeService;
  late MockFeedsManager mockFeedsManager;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockMidnightManager mockMidnightManager;
  late MockStoreService mockStoreService;
  late CatchupSetting catchupSetting;
  late CatchupManager testee;
  late bool notified;

  final today = DateTime(2025, 10, 27);

  setUp(() {
    mockAppLifecycleManager = MockAppLifecycleManager();
    mockDateTimeService = MockDateTimeService();
    mockFeedsManager = MockFeedsManager();
    mockFeedsAdvanceManager = MockFeedsAdvanceManager();
    mockMidnightManager = MockMidnightManager();
    mockStoreService = MockStoreService();
    catchupSetting = CatchupSetting();
    notified = false;

    // Stub default DateTimeService behavior
    when(mockDateTimeService.now).thenReturn(today);

    // Stub default FeedsManager behavior
    when(mockFeedsManager.chaptersToRead).thenReturn(7);
    when(mockFeedsManager.feedManagers).thenReturn(List.generate(10, (_) => MockFeedManager()));

    // Stub default StoreService behavior - return null for virtualAllDoneDate initially
    when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(null);
    when(mockStoreService.set<DateTime>('virtualAllDoneDate', any)).thenAnswer((_) async {});

    testee = CatchupManager(
      mockAppLifecycleManager,
      catchupSetting,
      mockDateTimeService,
      mockFeedsManager,
      mockFeedsAdvanceManager,
      mockMidnightManager,
      mockStoreService,
    );

    testee.addListener(() => notified = true);
    clearInteractions(mockStoreService);
  });

  test('CatchupSettingManager listener should reset virtualAllDoneDate to default and notifyListeners', () {
    // Set up: virtualAllDoneDate is 3 days ago, setting is disabled
    final threeDaysAgo = today - 3.days;
    when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(threeDaysAgo);

    // Trigger the reset by enabling the setting
    catchupSetting.value = true;

    // Verify storeService.set was called with the default value (today - 1 day)
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today - 1.days)).called(1);
    verifyNoMoreInteractions(mockStoreService);
    expect(notified, isTrue);
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [false, null, 0, 0, 7, false, false],
      [false, 0, 0, 0, 7, false, false],
      [false, -1, 0, 0, 7, false, false],
      [false, -2, 0, 0, 7, false, false],
      [false, -3, 0, 0, 7, false, false],
      [true, null, 0, 0, 7, false, false],
      [true, 0, 0, 0, 7, false, false],
      [true, -1, 0, 0, 7, false, false],
      [true, -2, 1, 1, 17, true, false],
      [true, -3, 2, 2, 27, true, true],
      [true, -4, 3, 2, 37, true, true],
    ],
    customDescriptionBuilder: (_, _, values) {
      final daysOffset = values[1];
      final daysLabel = daysOffset == null ? 'null' : 'Now $daysOffset days';
      return 'when isSettingEnabled=${values[0]} and virtualAllDoneDate=$daysLabel, expect ${values[2]}';
    },
    (
      bool isSettingEnabled,
      int? daysOffset,
      int expectDaysBehind,
      int expectDaysBehindClamped,
      int expectChaptersToRead,
      bool expectIsBehind,
      bool expectIsVeryBehind,
    ) {
      catchupSetting.value = isSettingEnabled;

      // Set up virtualAllDoneDate based on daysOffset
      final virtualDate = daysOffset != null ? today.add(daysOffset.days) : null;
      when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(virtualDate);

      expect(testee.daysBehind, expectDaysBehind);
      expect(testee.daysBehindClamped, expectDaysBehindClamped);
      expect(testee.chaptersToRead, expectChaptersToRead);
      expect(testee.isBehind, expectIsBehind);
      expect(testee.isVeryBehind, expectIsVeryBehind);
    },
  );

  parameterizedTest(
    'FeedsAdvanceManager listener should advance virtualAllDoneDate and notifyListeners',
    [
      [0, 0],
      [1, 0],
      [2, 1],
      [3, 2],
    ],
    (int daysBehind, int expectNewDaysBehind) {
      // Set up: virtualAllDoneDate is N days ago
      final virtualDate = today - daysBehind.days;
      when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(virtualDate);
      catchupSetting.value = true;
      clearInteractions(mockStoreService);
      notified = false;

      // Trigger feeds advance
      final listener = verify(mockFeedsAdvanceManager.addListener(captureAny)).captured.single as VoidCallback;
      listener();

      // Verify storeService.set was called with the new value
      final expectedDate = today - expectNewDaysBehind.days;
      verify(mockStoreService.set<DateTime>('virtualAllDoneDate', expectedDate)).called(1);
      expect(notified, isTrue);
    },
  );
}
