import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feed_manager.dart';
import '../model/list_wheel_state.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class const BookChapterDialogFooter(final FeedManager feedManager) extends WatchingWidget {
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
                padding: Spacing.left,
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
              child: const Padding(padding: Spacing.right, child: Text('Update')),
            ),
          ],
        ),
      ],
    );
  }
}
