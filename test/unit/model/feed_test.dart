import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../test_data.dart';

void main() async {
  late StubDateTimeService dateTimeService;
  late FeedManager testee;
  late Feed feed;

  setUpAll(() {
    dateTimeService = StubDateTimeService();
    sl.registerSingleton<DateTimeService>(dateTimeService);
  });

  setUp(() {
    dateTimeService.reset();
    feed = Feed(bookKey: b1.key);
    testee = FeedManager(rl1, feed);
  });

  group('property', () {
    test('book get', () {
      expect(testee.book, b1);
    });

    test('bookIndex get', () {
      expect(testee.bookIndex, 1);
    });

    test('chapter get', () {
      expect(testee.feed.chapter, 1);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(testee.feed.isRead, false);
      expect(testee.chaptersRead, 0);
      testee.toggleIsRead();
      expect(testee.feed.isRead, true);
      expect(testee.chaptersRead, 1);
    });

    test('progress get', () {
      expect(testee.progress, 0.25);
    });

    test('reading list get', () {
      expect(testee.readingList, rl1);
    });

    test('state get', () {
      expect(testee.feed, feed);
    });

    test('state set', () {
      final feed0 = Feed(bookKey: b0.key);
      testee.feed = feed0;
      expect(testee.feed, feed0);
    });
  });

  group('method', () {
    void checkState(Book expectedBook, int expectedChapter, [int expectedVerse = 1]) {
      expect(testee.book, expectedBook);
      expect(testee.feed.chapter, expectedChapter);
      expect(testee.feed.verse, expectedVerse);
    }

    test('setBookChapterVerse should set book/chapter/verse and reset isRead', () {
      testee.toggleIsRead();
      testee.setBookChapterVerse(1, 2);
      checkState(b1, 2);
      expect(testee.feed.isRead, false);
    });

    test('toggleIsRead should toggle', () {
      testee.toggleIsRead();
      expect(testee.feed.isRead, true);
      testee.toggleIsRead();
      expect(testee.feed.isRead, false);
      checkState(b1, 1); // ensure no side effects
    });
  });
}
