import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feeds_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedStoreManager>()])
void main() async {
  late FeedsManager testee;
  late MockFeedStoreManager mockFeedStoreManager;
  late Feed feed0;
  late Feed feed1;

  setUp(() {
    mockFeedStoreManager = MockFeedStoreManager();
    feed0 = Feed(bookKey: b0.key, isRead: true, dateModified: DateTime(2025, 1, 1, 1));
    feed1 = Feed(bookKey: b1.key, dateModified: DateTime(2025, 1, 1, 2));
    when(mockFeedStoreManager.loadState(rl0)).thenReturn(feed0);
    when(mockFeedStoreManager.loadState(rl1)).thenReturn(feed1);
    testee = FeedsManager(mockFeedStoreManager, ReadingLists([rl0, rl1]));
  });

  group('property', () {
    test('[]', () {
      expect(testee.feedManagers[0].readingList, rl0);
      expect(testee.feedManagers[1].readingList, rl1);
    });

    test('areChaptersRead', () {
      expect(testee.areChaptersRead, false);
      testee.feedManagers[1].toggleIsRead();
      expect(testee.areChaptersRead, true);
    });

    test('chaptersToRead', () {
      expect(testee.chaptersToRead, 1);
      testee.feedManagers[0].toggleIsRead();
      expect(testee.chaptersToRead, 2);
      testee.feedManagers[1].toggleIsRead();
      expect(testee.chaptersToRead, 1);
      testee.feedManagers[0].toggleIsRead();
      expect(testee.chaptersToRead, 0);
    });

    group('lastModifiedFeed', () {
      test('should initialise from store', () {
        expect(testee.lastModifiedFeed, feed1);
      });

      test('should update on toggle', () {
        testee.feedManagers[0].toggleIsRead();
        expect(testee.lastModifiedFeed, feed0);
        testee.feedManagers[1].toggleIsRead();
        expect(testee.lastModifiedFeed, feed1);
        testee.feedManagers[0].toggleIsRead();
        expect(testee.lastModifiedFeed, feed0);
      });
    });
  });

  group('updating a feed', () {
    test('should update lastModifiedFeed', () {
      testee.feedManagers[0].toggleIsRead();
      expect(testee.lastModifiedFeed, feed0);
      testee.feedManagers[1].toggleIsRead();
      expect(testee.lastModifiedFeed, feed1);
    });

    test('should store the feed', () {
      testee.feedManagers[0].toggleIsRead();
      verify(mockFeedStoreManager.saveState(rl0, feed0)).called(1);
      verifyNever(mockFeedStoreManager.saveState(rl1, feed1));
      testee.feedManagers[1].toggleIsRead();
      verifyNever(mockFeedStoreManager.saveState(rl0, feed0));
      verify(mockFeedStoreManager.saveState(rl1, feed1)).called(1);
    });
  });
}
