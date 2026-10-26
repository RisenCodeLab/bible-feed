import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/reading_lists.dart';
import 'feed_manager.dart';
import 'feed_store_manager.dart';

@lazySingleton
class FeedsManager(final FeedStoreManager _feedStoreManager, ReadingLists readingLists) with ChangeNotifier {
  final List<FeedManager> _feedManagers = readingLists
      .map((rl) => FeedManager(rl, _feedStoreManager.load(rl)))
      .toList();
  Feed? _lastModifiedFeed;

  this {
    for (FeedManager fm in _feedManagers) {
      if (fm.feed.dateModified?.isAfter(_lastModifiedFeed?.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = fm.feed;
      }

      fm.addListener(() {
        notifyListeners();
        _lastModifiedFeed = fm.feed;
        _feedStoreManager.save(fm.readingList, fm.feed);
      });
    }
  }

  bool get areChaptersRead => chaptersToRead == 0;
  int get chaptersToRead => _feedManagers.where((fm) => !fm.feed.isRead).length;
  List<FeedManager> get feedManagers => _feedManagers;
  Feed? get lastModifiedFeed => _lastModifiedFeed;
}
