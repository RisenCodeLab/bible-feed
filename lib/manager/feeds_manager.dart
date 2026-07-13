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
    for (FeedManager f in _feeds) {
      if (f.state.dateModified?.isAfter(_lastModifiedFeed?.state.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = f;
      }

      f.addListener(() {
        notifyListeners();
        _lastModifiedFeed = f;
        _feedStoreManager.saveState(f.readingList, f.state);
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
