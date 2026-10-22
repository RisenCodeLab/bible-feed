// ignore_for_file: no-magic-number

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'chapter_splitter.dart';
import 'feed.dart';

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
    const .new('1cr', 6, [44]),
    const .new('1ki', 8, [37]),
    const .new('1ki', 18, [25]),
    const .new('1ki', 20, [23]),
    const .new('1ki', 22, [29]),
    const .new('1sa', 14, [24]),
    const .new('act', 7, [30]),
    const .new('deu', 28, [36]),
    const .new('eze', 16, [35]),
    const .new('eze', 20, [33]),
    const .new('exo', 12, [29]),
    const .new('gen', 24, [33]),
    const .new('jdg', 9, [26]),
    const .new('jdg', 20, [24]),
    const .new('jer', 32, [26]),
    const .new('jer', 48, [26]),
    const .new('jer', 49, [20]),
    const .new('jer', 50, [23]),
    const .new('jer', 51, [33]),
    const .new('jhn', 6, [34]),
    const .new('jos', 15, [33]),
    const .new('lam', 3, [33]),
    const .new('lev', 13, [29]),
    const .new('lev', 14, [33]),
    const .new('lev', 25, [35]),
    const .new('luk', 1, [39]),
    const .new('luk', 9, [28]),
    const .new('luk', 12, [32]),
    const .new('luk', 22, [35]),
    const .new('mar', 14, [32]),
    const .new('mat', 26, [36]),
    const .new('mat', 27, [35]),
    const .new('neh', 7, [37]),
    const .new('num', 1, [28]),
    const .new('num', 7, [48]),
    const .new('num', 14, [20]),
    const .new('num', 26, [35]),
    const .new('num', 31, [25]),
    const .new('num', 33, [38]),
    const .new('psa', 18, [25]),
    const .new('psa', 78, [36]),
    const .new('psa', 119, ChapterSplitters.psalm119VerseList),
  ];
}
