import 'dart:math';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feed_manager.dart';
import '../model/list_wheel_state.dart';
import '_build_context_extension.dart';
import '_constants.dart';
import 'book_chapter_dialog_footer.dart';
import 'book_chapter_dialog_wheels.dart';

class BookChapterDialog(final FeedManager _feedManager) extends StatelessWidget {
  this {
    sl<BookListWheelState>().index = _feedManager.bookIndex;
    sl<ChapterListWheelState>().index = _feedManager.feed.chapter - 1;
  }

  @override
  build(context) {
    withBackground(Widget child) => // fix 3.19 -> 3.22 background color regression
        Container(alignment: .center, color: context.colorScheme.surfaceContainerHigh, child: child);

    return LayoutBuilder(
      builder: (_, constraints) {
        final maxHeight = constraints.maxHeight * 1.8;
        final maxWidth = [300, constraints.maxWidth * 0.5].reduce(max).toDouble();
        final isVisible = constraints.maxHeight > 280;

        return Dialog(
          clipBehavior: .hardEdge,
          child: Container(
            constraints: .new(maxHeight: maxHeight, maxWidth: maxWidth),
            child: Column(
              children: [
                Visibility(
                  visible: isVisible,
                  child: withBackground(
                    Padding(
                      padding: Spacing.all,
                      child: Text(_feedManager.readingList.name, style: const .new(fontWeight: .bold)),
                    ),
                  ),
                ),
                Expanded(child: BookChapterDialogWheels(_feedManager.readingList)),
                withBackground(BookChapterDialogFooter(_feedManager)),
              ],
            ),
          ),
        );
      },
    );
  }
}
