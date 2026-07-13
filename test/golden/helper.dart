import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/model/chapter_split_setting.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

class Helper {
  static Future clearSharedPrefs() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }

  static void enableVerseScopes() {
    sl<ChapterSplitSetting>().value = true;
  }

  static void initialiseFeeds() {
    final baseDateTime = DateTime(2026, 7, 12);
    var bookState = [
      [0, 1],
      [4, 6],
      [0, 0],
      [0, 5],
      [0, 0],
    ];
    var chapterState = [
      [5, 12],
      [4, 2],
      [40, 144],
      [15, 17],
      [40, 7],
    ];
    var chapterReadState = [
      [false, true],
      [false, false],
      [true, false],
      [false, true],
      [true, false],
    ];
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 2; col++) {
        final feed = sl<FeedsManager>().feeds[row * 2 + col];
        feed.feed = Feed(
          bookKey: feed.readingList[bookState[row][col]].key,
          chapter: chapterState[row][col],
          verse: 1,
          isRead: chapterReadState[row][col],
          dateModified: baseDateTime.add(Duration(minutes: row * 2 + col)),
        );
      }
    }
  }
}
