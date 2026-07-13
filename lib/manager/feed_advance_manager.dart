import 'package:injectable/injectable.dart';

import 'feed_manager.dart';
import 'chapter_split_manager.dart';

@lazySingleton
class FeedAdvanceManager {
  final ChapterSplitManager _chapterSplitService;

  FeedAdvanceManager(this._chapterSplitService);

  void advance(FeedManager feedManager) {
    final state = feedManager.state;
    assert(state.isRead);
    var bookIndex = feedManager.bookIndex;
    var chapter = state.chapter;
    final verse = _chapterSplitService.getNextVerse(state);
    if (verse == 1 && ++chapter > feedManager.book.chapterCount) {
      bookIndex = (feedManager.bookIndex + 1) % feedManager.readingList.length;
      chapter = 1;
    }
    feedManager.setBookChapterVerse(bookIndex, chapter, verse);
  }
}
