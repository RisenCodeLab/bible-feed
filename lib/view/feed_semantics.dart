import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_link_manager.dart';
import '../manager/feed_manager.dart';

class FeedSemantics extends WatchingWidget {
  final Widget? child;
  final FeedManager feedManager;

  const FeedSemantics({required this.feedManager, required this.child});

  @override
  build(context) {
    watch(feedManager);
    final brlm = watchIt<BibleReaderLinkManager>();
    final state = feedManager.state;
    final isRead = state.isRead;

    final semanticsLabel = '${feedManager.book.name} chapter ${state.chapter} is currently ${isRead ? 'read' : 'unread'}';
    final semanticsHint =
        'Tap to ${brlm.isLinked && !isRead ? 'open Bible reader and' : ''} mark as ${isRead ? 'unread' : 'read'}. Long press to change the book and chapter.';

    return Semantics(excludeSemantics: true, label: semanticsLabel, hint: semanticsHint, child: child);
  }
}
