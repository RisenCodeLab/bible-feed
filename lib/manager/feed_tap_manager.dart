import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'bible_reader_launch_manager.dart';
import 'bible_reader_link_manager.dart';
import 'feed_manager.dart';

@lazySingleton
class FeedTapManager(
  final BibleReaderLaunchManager _bibleReaderLaunchManager,
  final BibleReaderLinkManager _bibleReaderLinkManager,
) with ChangeNotifier {
  Future<void> handleTap(FeedManager feedManager) {
    notifyListeners();
    feedManager.toggleIsRead();
    return _bibleReaderLaunchManager.maybeLaunch(_bibleReaderLinkManager.linkedBibleReader, feedManager.feed);
  }
}
