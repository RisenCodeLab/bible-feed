import 'package:bible_feed/manager/app_lifecycle_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/model/catchup_setting.dart';
import 'package:bible_feed/model/virtual_all_done_date.dart';
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
  late MockMidnightManager mockMidnightManager;
  late CatchupSetting catchupSetting;
  late CatchupManager testee;
  late VirtualAllDoneDate virtualAllDoneDate;
  late bool notified;

  final today = DateTime(2025, 10, 27);

  setUp(() {
    mockAppLifecycleManager = .new();
    mockDateTimeService = .new();
    mockFeedsManager = .new();
    mockMidnightManager = .new();
    catchupSetting = .new();
    virtualAllDoneDate = .new()..value = today - 1.days;
    notified = false;

    // Stub default DateTimeService behavior
    when(mockDateTimeService.now).thenReturn(today);

    // Stub default FeedsManager behavior
    when(mockFeedsManager.chaptersToRead).thenReturn(7);
    when(mockFeedsManager.feedManagers).thenReturn(List<MockFeedManager>.generate(10, (_) => .new()));

    testee = .new(
      mockAppLifecycleManager,
      catchupSetting,
      mockDateTimeService,
      mockFeedsManager,
      mockMidnightManager,
      virtualAllDoneDate,
    );

    testee.addListener(() => notified = true);
  });

  test('model changes should notifyListeners', () {
    virtualAllDoneDate.value = today - 3.days;
    expect(notified, isTrue);
  });

  test('app resume should notifyListeners', () {
    final listener = verify(mockAppLifecycleManager.onResume(captureAny)).captured.single as VoidCallback;
    listener();
    expect(notified, isTrue);
  });

  test('midnight should notifyListeners', () {
    final listener = verify(mockMidnightManager.addListener(captureAny)).captured.single as VoidCallback;
    listener();
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
      virtualAllDoneDate.value = daysOffset != null ? today.add(daysOffset.days) : today - 1.days;

      expect(testee.daysBehind, expectDaysBehind);
      expect(testee.daysBehindClamped, expectDaysBehindClamped);
      expect(testee.chaptersToRead, expectChaptersToRead);
      expect(testee.isBehind, expectIsBehind);
      expect(testee.isVeryBehind, expectIsVeryBehind);
    },
  );
}
