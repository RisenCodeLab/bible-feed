import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_link_manager.dart';
import '../manager/feed_manager.dart';
import '../manager/feeds_manager.dart';
import 'feed_body.dart';
import 'feed_semantics.dart';

class Feed extends WatchingWidget {
  final FeedManager feedManager;
  const Feed(this.feedManager);

  @override
  build(context) {
    watch(feedManager);
    final isLinked = watchIt<BibleReaderLinkManager>().isLinked;
    final isRead = feedManager.feed.isRead;
    final isLastReadAndLinked = isRead && isLinked && identical(feedManager, sl<FeedsManager>().lastModifiedFeed);
    final timeToFade = (isLastReadAndLinked ? 30 : 0).seconds;
    final opacity = isRead ? 0.25 : 1.0;
    final elevation = isRead ? 0.0 : 12.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: timeToFade,
      child: Card(
        elevation: elevation,
        clipBehavior: .hardEdge,
        child: FeedSemantics(feedManager: feedManager, child: FeedBody(feedManager)),
      ),
    );
  }
}
