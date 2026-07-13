import 'package:bible_feed/manager/catchup_manager.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart' show FeedsManager;
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<CatchupManager>(), MockSpec<FeedManager>(), MockSpec<FeedsManager>()])
void main() {
  late MockAppService mockAppService;
  late MockCatchupManager mockCatchupManager;
  late MockFeedsManager mockFeedsManager;
  late ShareOutManager testee;

  setUp(() {
    mockAppService = MockAppService();
    mockCatchupManager = MockCatchupManager();
    mockFeedsManager = MockFeedsManager();
    testee = ShareOutManager(mockAppService, mockCatchupManager, mockFeedsManager);
  });

  test('getJson returns correct JSON string', () {
    final feedState1 = Feed(bookKey: b0.key, chapter: 1);
    final feedState2 = Feed(bookKey: b1.key, chapter: 2);
    final feed1 = FeedManager(rl0, feedState1);
    final feed2 = FeedManager(rl1, feedState2);

    final buildNumber = '123';
    final virtualAllDoneDate = DateTime(2025, 12, 30);

    when(mockAppService.buildNumber).thenReturn(buildNumber);
    when(mockCatchupManager.virtualAllDoneDate).thenReturn(virtualAllDoneDate);
    when(mockFeedsManager.feedManagers).thenReturn([feed1, feed2]);

    final expectDto = ShareDto(
      buildNumber: buildNumber,
      feedStateList: [feedState1, feedState2],
      virtualAllDoneDate: virtualAllDoneDate,
    );
    expect(testee.getJson(), expectDto.toJson());
  });
}
