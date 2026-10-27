import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/share_in_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/share_dto.dart';
import 'package:bible_feed/model/virtual_all_done_date.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'share_in_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppService>(), MockSpec<FeedManager>(), MockSpec<FeedsManager>()])
void main() {
  late MockAppService mockAppService;
  late MockFeedManager mockFeedManager1;
  late MockFeedManager mockFeedManager2;
  late MockFeedsManager mockFeedsManager;
  late ShareInManager testee;
  late VirtualAllDoneDate virtualAllDoneDateModel;

  final version = '1.2.3';
  final virtualAllDoneDate = DateTime(2025, 12, 30);

  setUpAll(() {
    provideDummy(rl0);
  });

  setUp(() {
    mockAppService = .new();
    mockFeedManager1 = .new();
    mockFeedManager2 = .new();
    mockFeedsManager = .new();
    virtualAllDoneDateModel = .new()..value = DateTime(2000);

    when(mockAppService.version).thenReturn(version);
    when(mockFeedManager1.book).thenReturn(b0);
    when(mockFeedManager1.readingList).thenReturn(rl0);
    when(mockFeedManager2.book).thenReturn(b1);
    when(mockFeedManager2.readingList).thenReturn(rl1);
    when(mockFeedsManager.feedManagers).thenReturn([mockFeedManager1, mockFeedManager2]);

    testee = .new(mockAppService, mockFeedsManager, virtualAllDoneDateModel);
  });

  parameterizedTest(
    'sync throws exception on null, empty, or invalid JSON',
    [
      [null],
      [''],
      ['invalid json'],
    ],
    (String? json) {
      expect(() => testee.sync(json), throwsException);
    },
  );

  test('sync throws exception on mismatched version', () {
    final Feed feed = .new(bookKey: b0.key, chapter: 1);
    final ShareDto shareDto = .new(version: 'wrong_version', feedList: [feed], virtualAllDoneDate: virtualAllDoneDate);

    expect(() => testee.sync(shareDto.toJson()), throwsException);
  });

  test('sync updates feed states and VirtualAllDoneDate on valid JSON with matching version', () {
    final Feed feed1 = .new(bookKey: b0.key, chapter: 1);
    final Feed feed2 = .new(bookKey: b1.key, chapter: 2);
    final ShareDto shareDto = .new(feedList: [feed1, feed2], version: version, virtualAllDoneDate: virtualAllDoneDate);

    testee.sync(shareDto.toJson());

    verify(mockFeedManager1.feed = feed1).called(1);
    verify(mockFeedManager2.feed = feed2).called(1);
    expect(virtualAllDoneDateModel.value.millisecondsSinceEpoch, virtualAllDoneDate.millisecondsSinceEpoch);
  });

  parameterizedTest(
    'sync rejects invalid feeds without mutating any state',
    [
      [
        'unknown book key in first feed',
        <Feed>[.new(bookKey: 'unknown', chapter: 1), .new(bookKey: b1.key, chapter: 2)],
      ],
      [
        'invalid chapter in second feed',
        <Feed>[.new(bookKey: b0.key, chapter: 1), .new(bookKey: b1.key, chapter: 99)],
      ],
    ],
    customDescriptionBuilder: (_, description, values) => '$description: ${values[0]}',
    (String _, List<Feed> feedList) {
      final ShareDto shareDto = .new(feedList: feedList, version: version, virtualAllDoneDate: virtualAllDoneDate);
      var notifications = 0;
      virtualAllDoneDateModel.addListener(() => notifications++);

      expect(() => testee.sync(shareDto.toJson()), throwsException);

      verifyNever(mockFeedManager1.feed = any);
      verifyNever(mockFeedManager2.feed = any);
      expect(virtualAllDoneDateModel.value, DateTime(2000));
      expect(notifications, 0);
    },
  );
}
