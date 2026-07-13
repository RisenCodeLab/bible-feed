import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/chapter_split_manager.dart';
import 'package:bible_feed/manager/feed_advance_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feed_advance_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChapterSplitManager>()])
void main() async {
  final mockChapterSplitManager = MockChapterSplitManager();
  late FeedManager feedManager;
  late Feed feed;
  late FeedAdvanceManager testee;

  setUp(() {
    feed = Feed(bookKey: b1.key);
    feedManager = FeedManager(rl1, feed, StubDateTimeService());
    when(mockChapterSplitManager.getNextVerse(feed)).thenReturn(1);
    testee = FeedAdvanceManager(mockChapterSplitManager);
  });

  test('should fail assertion if not read', () {
    expect(() => testee.advance(feedManager), throwsAssertionError);
  });

  test('should not change chaptersRead', () {
    feedManager.toggleIsRead();
    expect(feedManager.chaptersRead, 1);
    testee.advance(feedManager);
    expect(feedManager.chaptersRead, 1);
  });

  test('should reset isRead', () {
    feedManager.toggleIsRead();
    testee.advance(feedManager);
    expect(feedManager.feed.isRead, false);
  });

  void advance() {
    if (!feed.isRead) feedManager.toggleIsRead();
    testee.advance(feedManager);
  }

  void checkState(Book expectBook, int expectChapter, [int expectVerse = 1]) {
    expect(feed.bookKey, expectBook.key);
    expect(feed.chapter, expectChapter);
    expect(feed.verse, expectVerse);
  }

  test('full cycle: should advance/reset chapter and book', () {
    checkState(b1, 1);
    advance();
    checkState(b1, 2);
    advance();
    checkState(b1, 3);
    advance();
    checkState(b0, 1);
    advance();
    checkState(b1, 1);
  });

  test('with chapter split, should advance verse only', () {
      when(mockChapterSplitManager.getNextVerse(feed)).thenReturn(3);
    checkState(b1, 1, 1);
      feedManager.toggleIsRead();
      testee.advance(feedManager);
    checkState(b1, 1, 3);
  });
}
