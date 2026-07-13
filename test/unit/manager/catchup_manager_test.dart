import 'package:bible_feed/manager/app_lifecycle_manager.dart';
import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feeds_advance_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/priority_notifier.dart';
import 'package:bible_feed/model/catchup_setting.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds_advance_state.dart';
import 'package:bible_feed/model/priority.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

class FakeAppLifecycleManager implements AppLifecycleManager {
  final listeners = <VoidCallback>[];

  @override
  void onResume(VoidCallback callback, {Priority priority = Priority.normal}) {
    listeners.add(callback);
  }

  @override
  void runCallbacks() {
    for (final callback in List<VoidCallback>.of(listeners)) {
      callback();
    }
  }
}

class FakeDateTimeService implements DateTimeService {
  FakeDateTimeService(this.now);

  @override
  DateTime now;
}

class FakeStoreService implements StoreService {
  final values = <String, Object?>{};
  final writes = <MapEntry<String, Object?>>[];

  @override
  T? get<T>(String key) => values[key] as T?;

  @override
  Future<void> set<T>(String key, T value) async {
    values[key] = value;
    writes.add(MapEntry(key, value));
  }
}

class FakeCatchupSetting extends CatchupSetting {
  final listeners = <VoidCallback>[];
  bool currentValue = false;

  @override
  bool get defaultValue => false;

  @override
  String get storeKeyFragment => 'catchup';

  @override
  String get subtitle => 'subtitle';

  @override
  String get title => 'title';

  @override
  bool get value => currentValue;

  @override
  set value(bool value) {
    if (value == currentValue) return;
    currentValue = value;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    listeners.add(listener);
    super.addListener(listener);
  }
}

class FakeFeedsManager extends ChangeNotifier implements FeedsManager {
  FakeFeedsManager({
    required this.feedManagers,
    required this.chaptersToRead,
    required this.areChaptersRead,
    required this.lastModifiedFeed,
  });

  @override
  List<FeedManager> feedManagers;

  @override
  int chaptersToRead;

  @override
  bool areChaptersRead;

  @override
  Feed? lastModifiedFeed;
}

class FakeFeedsAdvanceManager extends ChangeNotifier implements FeedsAdvanceManager {
  final listeners = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    listeners.add(listener);
    super.addListener(listener);
  }

  @override
  FeedsAdvanceState advance() => FeedsAdvanceState.listsAdvanced;

  @override
  FeedsAdvanceState maybeAdvance() => FeedsAdvanceState.notAllRead;
}

class FakeMidnightManager extends ChangeNotifier with PriorityNotifier implements MidnightManager {}

void main() {
  late FakeAppLifecycleManager fakeAppLifecycleManager;
  late FakeCatchupSetting fakeCatchupSetting;
  late FakeDateTimeService fakeDateTimeService;
  late FakeFeedsManager fakeFeedsManager;
  late FakeFeedsAdvanceManager fakeFeedsAdvanceManager;
  late FakeMidnightManager fakeMidnightManager;
  late FakeStoreService fakeStoreService;
  late CatchupManager testee;
  late bool notified;

  final today = DateTime.now().date;
  final feedManagers = List.generate(10, (index) {
    final rl = index.isEven ? rl0 : rl1;
    return FeedManager(rl, Feed(bookKey: rl[0].key));
  });

  setUp(() {
    fakeAppLifecycleManager = FakeAppLifecycleManager();
    fakeCatchupSetting = FakeCatchupSetting();
    fakeDateTimeService = FakeDateTimeService(DateTime.now());
    fakeFeedsManager = FakeFeedsManager(
      feedManagers: feedManagers,
      chaptersToRead: 7,
      areChaptersRead: false,
      lastModifiedFeed: feedManagers[1].feed,
    );
    fakeFeedsAdvanceManager = FakeFeedsAdvanceManager();
    fakeMidnightManager = FakeMidnightManager();
    fakeStoreService = FakeStoreService();
    notified = false;

    testee = CatchupManager(
      fakeAppLifecycleManager,
      fakeCatchupSetting,
      fakeDateTimeService,
      fakeFeedsManager,
      fakeFeedsAdvanceManager,
      fakeMidnightManager,
      fakeStoreService,
    );

    testee.addListener(() => notified = true);
  });

  test('CatchupSettingManager listener should reset virtualAllDoneDate to default and notifyListeners', () {
    fakeStoreService.writes.clear();
    fakeStoreService.values['virtualAllDoneDate'] = today - 3.days;

    fakeCatchupSetting.listeners.first();

    expect(fakeStoreService.writes.single.key, 'virtualAllDoneDate');
    expect(fakeStoreService.writes.single.value, today - 1.days);
    expect(notified, isTrue);
  });

  parameterizedTest(
    'daysBehind, isBehind properties',
    [
      [false, null, 0, 0, 7, false, false],
      [false, today, 0, 0, 7, false, false],
      [false, today - 1.days, 0, 0, 7, false, false],
      [false, today - 2.days, 0, 0, 7, false, false],
      [false, today - 3.days, 0, 0, 7, false, false],
      [true, null, 0, 0, 7, false, false],
      [true, today, 0, 0, 7, false, false],
      [true, today - 1.days, 0, 0, 7, false, false],
      [true, today - 2.days, 1, 1, 17, true, false],
      [true, today - 3.days, 2, 2, 27, true, true],
      [true, today - 4.days, 3, 2, 37, true, true],
    ],
    customDescriptionBuilder: (_, _, values) {
      return 'when areChaptersRead=${values[0]} and lastDateModified=(Now - ${values[1]}), expect ${values[2]}';
    },
    (
      isSettingEnabled,
      virtualAllDoneDate,
      expectDaysBehind,
      expectDaysBehindClamped,
      expectChaptersToRead,
      expectIsBehind,
      expectIsVeryBehind,
    ) {
      fakeCatchupSetting.currentValue = isSettingEnabled;
      fakeStoreService.values['virtualAllDoneDate'] = virtualAllDoneDate ?? today - 1.days;

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
      [0.days, 0.days],
      [1.days, 0.days],
      [2.days, 1.days],
      [3.days, 2.days],
    ],
    (daysBehind, expectNewDaysBehind) {
      fakeStoreService.writes.clear();
      fakeStoreService.values['virtualAllDoneDate'] = today - daysBehind;
      fakeCatchupSetting.currentValue = true;

      fakeFeedsAdvanceManager.notifyListeners();

      expect(fakeStoreService.writes.single.key, 'virtualAllDoneDate');
      expect(fakeStoreService.writes.single.value, today - expectNewDaysBehind);
      expect(notified, isTrue);
    },
  );
}
