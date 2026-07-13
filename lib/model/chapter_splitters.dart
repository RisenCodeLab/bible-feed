import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'chapter_splitter.dart';
import '../manager/feed_manager.dart';

ChapterSplitter splitter(String bookKey, int chapter, List<int> verses) => ChapterSplitter(bookKey, chapter, verses);

@immutable
@lazySingleton
class ChapterSplitters extends BaseList<ChapterSplitter> {
  const ChapterSplitters(super._items);

  static const psalm119VerseList = [17, 33, 49, 65, 81, 97, 113, 129, 145, 161]; // used by unit test

  ChapterSplitter? find(Feed state) =>
      firstOrNullWhere((item) => item.bookKey == state.bookKey && item.chapter == state.chapter);
}

@module
abstract class ChapterSplittersModule {
  @lazySingleton
  List<ChapterSplitter> get chapterSplitters => [
    splitter('1cr', 6, [44]),
    splitter('1ki', 8, [37]),
    splitter('1sa', 14, [24]),
    splitter('act', 7, [30]),
    splitter('deu', 28, [36]),
    splitter('eze', 16, [35]),
    splitter('gen', 24, [33]),
    splitter('jdg', 9, [26]),
    splitter('jdg', 20, [24]),
    splitter('jer', 48, [26]),
    splitter('jer', 49, [20]),
    splitter('jer', 50, [23]),
    splitter('jer', 51, [33]),
    splitter('jhn', 6, [34]),
    splitter('jos', 15, [33]),
    splitter('lam', 3, [33]),
    splitter('lev', 13, [29]),
    splitter('lev', 25, [35]),
    splitter('luk', 1, [39]),
    splitter('luk', 9, [28]),
    splitter('luk', 12, [32]),
    splitter('mar', 14, [32]),
    splitter('mat', 26, [36]),
    splitter('mat', 27, [35]),
    splitter('neh', 7, [37]),
    splitter('num', 1, [28]),
    splitter('num', 7, [48]),
    splitter('num', 14, [20]),
    splitter('num', 26, [35]),
    splitter('num', 31, [25]),
    splitter('num', 33, [38]),
    splitter('psa', 18, [25]),
    splitter('psa', 78, [36]),
    splitter('psa', 119, ChapterSplitters.psalm119VerseList),
  ];
}
