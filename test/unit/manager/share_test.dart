import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<CatchupManager>(), MockSpec<StoreService>()])
void main() {
  final dateModified = DateTime.now();
  final readingLists = ReadingLists([rl0, rl1]);
  late MockAppService mockAppService;
  late MockCatchupManager mockCatchupManager;
  late MockStoreService mockInStoreService;
  late MockStoreService mockOutStoreService;
  late FeedsManager inFeedsManager;
  late FeedsManager outFeedsManager;
  late ShareInManager shareInManager;
  late ShareOutManager shareOutManager;

  setUp(() {
    mockAppService = MockAppService();
    mockCatchupManager = MockCatchupManager();
    mockInStoreService = MockStoreService();
    mockOutStoreService = MockStoreService();
  });

  test('sync-out sync-in interaction: should transfer across', () {
    final buildNumber = '123';
    final virtualAllDoneDate = DateTime(2025, 12, 30);
    when(mockOutStoreService.get('rl1.dateModified')).thenReturn(dateModified);
    when(mockOutStoreService.get('rl1.book')).thenReturn('b1');
    when(mockOutStoreService.get('rl1.chapter')).thenReturn(3);
    when(mockOutStoreService.get('rl1.verse')).thenReturn(5);
    when(mockOutStoreService.get('rl1.isRead')).thenReturn(true);
    when(mockAppService.buildNumber).thenReturn(buildNumber);
    when(mockCatchupManager.virtualAllDoneDate).thenReturn(virtualAllDoneDate);
    inFeedsManager = FeedsManager(FeedStoreManager(mockInStoreService), readingLists);
    outFeedsManager = FeedsManager(FeedStoreManager(mockOutStoreService), readingLists);
    shareInManager = ShareInManager(mockAppService, mockCatchupManager, inFeedsManager);
    shareOutManager = ShareOutManager(mockAppService, mockCatchupManager, outFeedsManager);

    // AI fails to improve this code!?
    DateTime? capturedDate;
    when(mockCatchupManager.virtualAllDoneDate = any).thenAnswer((invocation) {
      capturedDate = invocation.positionalArguments[0] as DateTime;
    });

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
    expect(capturedDate?.millisecondsSinceEpoch, virtualAllDoneDate.millisecondsSinceEpoch);
  });
}
