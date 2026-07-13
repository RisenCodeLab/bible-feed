import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';

import '../model/book.dart';
import '../model/reading_list.dart';

part '../model/feed.dart';
part '../model/feed.mapper.dart';

// FeedManager manages the reading state of a given list of books
class FeedManager with ChangeNotifier {
  final ReadingList _readingList;
  Feed _feed;

  FeedManager(this._readingList, this._feed);

  Book get book => _readingList.getBook(_feed._bookKey);
  int get bookIndex => _readingList.indexOf(book);
  int get chaptersRead => _feed._chapter - (_feed._isRead ? 0 : 1);
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  Feed get feed => _feed;

  set feed(Feed value) {
    _feed = value;
    notifyListeners();
  }

  void setBookChapterVerse(int bookIndex, int chapter, [int verse = 1]) {
    if (bookIndex == this.bookIndex && chapter == _feed._chapter && verse == _feed.verse) return;
    _feed._bookKey = readingList[bookIndex].key;
    _feed._chapter = chapter;
    _feed._verse = verse;
    _feed._isRead = false;
    _feed._dateModified = .now();
    notifyListeners();
  }

  void toggleIsRead() {
    _feed._isRead = !_feed._isRead;
    _feed._dateModified = .now();
    notifyListeners();
  }

  void touch() => notifyListeners();
}
