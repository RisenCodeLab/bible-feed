import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'feed_manager.dart';
import '../model/reading_lists.dart';
import 'feed_store_manager.dart';

@lazySingleton
class FeedsManager with ChangeNotifier {
  final FeedStoreManager _feedStoreManager;

  FeedsManager(this._feedStoreManager, ReadingLists readingLists)
    : _feeds = readingLists.map((rl) => FeedManager(rl, _feedStoreManager.loadState(rl))).toList() {
    for (FeedManager fm in _feeds) {
      if (fm.state.dateModified?.isAfter(_lastModifiedFeed?.state.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = fm;
      }

      fm.addListener(() {
        notifyListeners();
        _lastModifiedFeed = fm;
        _feedStoreManager.saveState(fm.readingList, fm.state);
      });
    }
  }

  final List<FeedManager> _feeds;
  FeedManager? _lastModifiedFeed;

  bool get areChaptersRead => chaptersToRead == 0;
  int get chaptersToRead => _feeds.where((feed) => !feed.state.isRead).length;
  List<FeedManager> get feeds => _feeds;
  FeedManager? get lastModifiedFeed => _lastModifiedFeed;
}
