import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';

import '../model/book.dart';
import '../model/feed.dart';
import '../model/reading_list.dart';
import '../service/date_time_service.dart';

class FeedManager with ChangeNotifier {
  final ReadingList _readingList;
  Feed _feed;

  FeedManager(this._readingList, this._feed);

  Book get book => _readingList.getBook(_feed.bookKey);
  int get bookIndex => _readingList.indexOf(book);
  int get chaptersRead => _feed.chapter - (_feed.isRead ? 0 : 1);
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  Feed get feed => _feed;

  set feed(Feed value) {
    _feed = value;
    notifyListeners();
  }

  void setBookChapterVerse(int bookIndex, int chapter, [int verse = 1]) {
    if (bookIndex == this.bookIndex && chapter == _feed.chapter && verse == _feed.verse) return;
    _feed.bookKey = readingList[bookIndex].key;
    _feed.chapter = chapter;
    _feed.verse = verse;
    _feed.isRead = false;
    _feed.dateModified = sl<DateTimeService>().now;
    notifyListeners();
  }

  void toggleIsRead() {
    _feed.isRead = !_feed.isRead;
    _feed.dateModified = sl<DateTimeService>().now;
    notifyListeners();
  }

  void touch() => notifyListeners();
}
