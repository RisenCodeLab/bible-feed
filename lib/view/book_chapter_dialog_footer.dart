import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feed_manager.dart';
import '../model/list_wheel_state.dart';
import '_build_context_extension.dart';

class BookChapterDialogFooter extends WatchingWidget {
  final FeedManager feedManager;
  const BookChapterDialogFooter(this.feedManager);

  @override
  build(context) {
    var bookIndex = watchIt<BookListWheelState>().index;
    var chapter = watchIt<ChapterListWheelState>().index + 1;

    return Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: context.colorScheme.surface,
          value: feedManager.readingList.progressTo(bookIndex, chapter),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  '${feedManager.readingList.chaptersTo(bookIndex, chapter)} of ${feedManager.readingList.totalChapters}',
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                feedManager.setBookChapterVerse(bookIndex, chapter);
                Navigator.pop(context);
              },
              child: const Padding(padding: EdgeInsets.only(right: 8.0), child: Text('Update')),
            ),
          ],
        ),
      ],
    );
  }
}
