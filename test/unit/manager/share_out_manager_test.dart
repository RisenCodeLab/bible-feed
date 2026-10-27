import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart' show FeedsManager;
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/model/virtual_all_done_date.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'share_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<FeedManager>(), MockSpec<FeedsManager>()])
void main() {
  final dateTimeService = StubDateTimeService();
  late MockAppService mockAppService;
  late MockFeedsManager mockFeedsManager;
  late ShareOutManager testee;
  late VirtualAllDoneDate virtualAllDoneDateModel;

  setUp(() {
    mockAppService = .new();
    mockFeedsManager = .new();
    virtualAllDoneDateModel = .new();
    testee = .new(mockAppService, mockFeedsManager, virtualAllDoneDateModel);
  });

  test('getJson returns correct JSON string', () {
    final Feed feed1 = .new(bookKey: b0.key, chapter: 1);
    final Feed feed2 = .new(bookKey: b1.key, chapter: 2);
    final FeedManager feedManager1 = .new(dateTimeService, feed1, rl0);
    final FeedManager feedManager2 = .new(dateTimeService, feed2, rl1);

    final buildNumber = '1.2.3';
    final virtualAllDoneDate = DateTime(2025, 12, 30);

    when(mockAppService.version).thenReturn(buildNumber);
    virtualAllDoneDateModel.value = virtualAllDoneDate;
    when(mockFeedsManager.feedManagers).thenReturn([feedManager1, feedManager2]);

    final expectDto = ShareDto(version: buildNumber, feedList: [feed1, feed2], virtualAllDoneDate: virtualAllDoneDate);
    expect(testee.getJson(), expectDto.toJson());
  });
}
