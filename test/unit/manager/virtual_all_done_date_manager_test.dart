import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/virtual_all_done_date_manager.dart';
import 'package:bible_feed/model/catchup_setting.dart';
import 'package:bible_feed/model/virtual_all_done_date.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'catchup_manager_test.mocks.dart';

void main() {
  late MockDateTimeService mockDateTimeService;
  late MockFeedsAdvanceManager mockFeedsAdvanceManager;
  late MockStoreService mockStoreService;
  late CatchupManager catchupManager;
  late CatchupSetting catchupSetting;
  late VirtualAllDoneDate virtualAllDoneDate;
  late int notifications;

  final DateTime today = .new(2025, 10, 27);

  VirtualAllDoneDateManager createManager() => .new(
    catchupManager,
    catchupSetting,
    mockDateTimeService,
    mockFeedsAdvanceManager,
    mockStoreService,
    virtualAllDoneDate,
  );

  setUp(() {
    final MockAppLifecycleManager mockAppLifecycleManager = .new();
    final MockFeedsManager mockFeedsManager = .new();
    final MockMidnightManager mockMidnightManager = .new();
    mockDateTimeService = .new();
    mockFeedsAdvanceManager = .new();
    mockStoreService = .new();
    catchupSetting = .new();
    virtualAllDoneDate = .new();
    notifications = 0;

    when(mockDateTimeService.now).thenReturn(today);

    // Stub default StoreService behavior - return null for virtualAllDoneDate initially
    when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(null);
    when(mockStoreService.set<DateTime>('virtualAllDoneDate', any)).thenAnswer((_) async {});

    catchupManager = .new(
      mockAppLifecycleManager,
      catchupSetting,
      mockDateTimeService,
      mockFeedsManager,
      mockMidnightManager,
      virtualAllDoneDate,
    );
    catchupManager.addListener(() => notifications++);
  });

  test('initializes and persists yesterday when no date is stored', () {
    createManager();

    expect(virtualAllDoneDate.value, today - 1.days);
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today - 1.days)).called(1);
  });

  test('initializes the model with the stored date without normalizing it', () {
    final storedDate = today - 3.days + 5.hours;
    when(mockStoreService.get<DateTime>('virtualAllDoneDate')).thenReturn(storedDate);

    createManager();

    expect(virtualAllDoneDate.value, storedDate);
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', storedDate)).called(1);
  });

  test('CatchupSetting listener should reset virtualAllDoneDate to default and notifyListeners', () {
    createManager();

    // Set up: virtualAllDoneDate is 3 days ago, setting is disabled
    final threeDaysAgo = today - 3.days;
    virtualAllDoneDate.value = threeDaysAgo;
    clearInteractions(mockStoreService);
    notifications = 0;

    // Trigger the reset by enabling the setting
    catchupSetting.value = true;

    // Verify storeService.set was called with the default value (today - 1 day)
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today - 1.days)).called(1);
    verifyNoMoreInteractions(mockStoreService);
    expect(virtualAllDoneDate.value, today - 1.days);
    expect(notifications, 1);
  });

  test('disabling catchup also resets the model', () {
    catchupSetting.value = true;
    createManager();
    virtualAllDoneDate.value = today - 3.days;
    clearInteractions(mockStoreService);
    notifications = 0;

    catchupSetting.value = false;

    expect(virtualAllDoneDate.value, today - 1.days);
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today - 1.days)).called(1);
    expect(notifications, 1);
  });

  test('reset uses yesterday relative to the current date', () {
    final testee = createManager();
    when(mockDateTimeService.now).thenReturn(today + 2.days);
    clearInteractions(mockStoreService);
    notifications = 0;

    testee.reset();

    expect(virtualAllDoneDate.value, today + 1.days);
    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today + 1.days)).called(1);
    expect(notifications, 1);
  });

  test('external model changes are persisted and notify catchup exactly once', () {
    createManager();
    clearInteractions(mockStoreService);
    notifications = 0;

    virtualAllDoneDate.value = today - 4.days;

    verify(mockStoreService.set<DateTime>('virtualAllDoneDate', today - 4.days)).called(1);
    expect(notifications, 1);
  });

  parameterizedTest(
    'FeedsAdvanceManager listener should advance virtualAllDoneDate and notifyListeners',
    [
      [true, 0, 0],
      [true, 1, 0],
      [true, 2, 1],
      [true, 3, 2],
      [true, -1, 0],
      [false, 3, 0],
    ],
    (bool isEnabled, int daysBehind, int expectNewDaysBehind) {
      catchupSetting.value = isEnabled;
      createManager();

      // Set up: virtualAllDoneDate is N days ago
      final virtualDate = today - daysBehind.days;
      virtualAllDoneDate.value = virtualDate;
      clearInteractions(mockStoreService);
      notifications = 0;

      // Trigger feeds advance
      final listener = verify(mockFeedsAdvanceManager.addListener(captureAny)).captured.single as VoidCallback;
      listener();

      // Verify storeService.set was called with the new value
      final expectedDate = today - expectNewDaysBehind.days;
      expect(virtualAllDoneDate.value, expectedDate);
      verify(mockStoreService.set<DateTime>('virtualAllDoneDate', expectedDate)).called(1);
      expect(notifications, 1);
    },
  );
}
