import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feed_manager.dart';
import '../manager/feeds_manager.dart';
import '_build_context_extension.dart';
import 'book_chapter_dialog.dart';

class const FeedTitleBar(final FeedManager feedManager) extends WatchingWidget {
  @override
  build(context) {
    final feedsManager = watchIt<FeedsManager>();

    return Row(
      children: [
        Visibility(
          visible: feedManager.feed.isRead && identical(feedManager.feed, feedsManager.lastModifiedFeed),
          child: const Padding(
            padding: .only(left: 8.0),
            child: Tooltip(message: 'This is the last chapter you read', child: Icon(Icons.auto_stories)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const .only(left: 8.0),
            child: Text(feedManager.readingList.name, style: const .new(fontSize: 18), overflow: .ellipsis),
          ),
        ),
        IconButton(
          key: .new(feedManager.readingList.key), // for screenshot generator
          icon: const Icon(Icons.unfold_more),
          onPressed: () => context.showDialogWithBlurBackground(BookChapterDialog(feedManager)),
        ),
      ],
    );
  }
}
