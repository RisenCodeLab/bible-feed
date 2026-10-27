import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/model/virtual_all_done_date.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<StoreService>()])
void main() {
  final dateTimeService = StubDateTimeService();
  final dateModified = DateTime.now();
  final readingLists = ReadingLists([rl0, rl1]);
  late MockAppService mockAppService;
  late MockStoreService mockInStoreService;
  late MockStoreService mockOutStoreService;
  late FeedsManager inFeedsManager;
  late FeedsManager outFeedsManager;
  late ShareInManager shareInManager;
  late ShareOutManager shareOutManager;
  late VirtualAllDoneDate inVirtualAllDoneDate;
  late VirtualAllDoneDate outVirtualAllDoneDate;

  setUp(() {
    mockAppService = .new();
    mockInStoreService = .new();
    mockOutStoreService = .new();
    inVirtualAllDoneDate = .new();
    outVirtualAllDoneDate = .new();
  });

  test('sync-out sync-in interaction: should transfer across', () {
    final buildNumber = '123';
    final virtualAllDoneDate = DateTime(2025, 12, 30);
    when(mockOutStoreService.get('rl1.dateModified')).thenReturn(dateModified);
    when(mockOutStoreService.get('rl1.book')).thenReturn('b1');
    when(mockOutStoreService.get('rl1.chapter')).thenReturn(3);
    when(mockOutStoreService.get('rl1.verse')).thenReturn(5);
    when(mockOutStoreService.get('rl1.isRead')).thenReturn(true);
    when(mockAppService.version).thenReturn(buildNumber);
    outVirtualAllDoneDate.value = virtualAllDoneDate;
    inFeedsManager = .new(dateTimeService, .new(mockInStoreService), readingLists);
    outFeedsManager = .new(dateTimeService, .new(mockOutStoreService), readingLists);
    shareInManager = .new(mockAppService, inFeedsManager, inVirtualAllDoneDate);
    shareOutManager = .new(mockAppService, outFeedsManager, outVirtualAllDoneDate);

    shareInManager.sync(shareOutManager.getJson());

    final feed0 = outFeedsManager.feedManagers[0].feed;
    final feed1 = outFeedsManager.feedManagers[1].feed;
    expect(feed0.bookKey, b0.key);
    expect(feed0.chapter, 1);
    expect(feed0.verse, 1);
    expect(feed0.isRead, false);
    expect(feed0.dateModified, null);
    expect(feed1.bookKey, b1.key);
    expect(feed1.chapter, 3);
    expect(feed1.verse, 5);
    expect(feed1.isRead, true);
    expect(feed1.dateModified, dateModified);
    expect(inVirtualAllDoneDate.value.millisecondsSinceEpoch, virtualAllDoneDate.millisecondsSinceEpoch);
  });
}
