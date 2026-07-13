import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/chapter_split_manager.dart';
import '../manager/feed_manager.dart';
import '../model/chapter_split_setting.dart';
import '_constants.dart';

class FeedBookChapter extends WatchingWidget {
  final FeedManager feedManager;
  const FeedBookChapter(this.feedManager);

  @override
  build(context) {
    const maxLines = 2;
    final chapterSplitLabel = sl<ChapterSplitManager>().getLabel(feedManager.feed);
    watchIt<ChapterSplitSetting>();

    return Expanded(
      child: Padding(
        padding: Constants.defaultPadding,
        child: Center(
          child: AutoSizeText(
            '${feedManager.book.name} ${feedManager.feed.chapter} $chapterSplitLabel'.trim(),
            maxLines: maxLines,
            overflow: .ellipsis,
            textAlign: .center,
          ),
        ),
      ),
    );
  }
}
