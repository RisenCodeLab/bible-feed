import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/reading_lists.dart';
import 'feed_manager.dart';
import 'feed_store_manager.dart';

@lazySingleton
class FeedsManager(final FeedStoreManager _feedStoreManager, ReadingLists readingLists) with ChangeNotifier {
  this {
    for (FeedManager fm in _feedManagers) {
      if (fm.feed.dateModified?.isAfter(_lastModifiedFeed?.dateModified ?? .new(0)) ?? false) {
        _lastModifiedFeed = fm.feed;
      }

      fm.addListener(() {
        notifyListeners();
        _lastModifiedFeed = fm.feed;
        _feedStoreManager.save(fm.readingList, fm.feed);
      });
    }
  }

  final List<FeedManager> _feedManagers = readingLists
      .map<FeedManager>((rl) => .new(_feedStoreManager.load(rl), rl))
      .toList();
  Feed? _lastModifiedFeed;

  bool get areChaptersRead => chaptersToRead == 0;
  int get chaptersToRead => _feedManagers.where((fm) => !fm.feed.isRead).length;
  List<FeedManager> get feedManagers => _feedManagers;
  Feed? get lastModifiedFeed => _lastModifiedFeed;
}
