import 'package:flutter/foundation.dart';

import 'feed.dart';

@immutable
class const ChapterSplitter(final String bookKey, final int chapter, final List<int> verses) {
  // each section split starts at these verse numbers, excluding verse 1

  String _toNonBreakingSpace(String label) {
    const nonBreakingSpaceCharCode = 0x00A0;
    return label.replaceAll('_', .fromCharCode(nonBreakingSpaceCharCode));
  }

  int getNextVerse(Feed feed) {
    assert(feed.bookKey == bookKey);
    assert(feed.chapter == chapter);
    return verses.elementAtOrNull(verses.indexOf(feed.verse) + 1) ?? 1;
  }

  String getLabel(Feed feed) {
    assert(feed.bookKey == bookKey);
    assert(feed.chapter == chapter);
    final nextVerse = getNextVerse(feed);
    if (feed.verse == 1) return _toNonBreakingSpace('to_verse_${nextVerse - 1}');
    if (nextVerse == 1) return _toNonBreakingSpace('from_verse_${feed.verse}');
    return _toNonBreakingSpace('verse_${feed.verse}-${nextVerse - 1}');
  }
}
