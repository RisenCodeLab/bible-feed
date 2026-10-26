import 'package:injectable/injectable.dart';

import '../model/chapter_split_setting.dart';
import '../model/chapter_splitters.dart';
import '../model/feed.dart';

@lazySingleton
class ChapterSplitManager(final ChapterSplitSetting _chapterSplitSetting, final ChapterSplitters _chapterSplitters) {
  String getLabel(Feed state) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';

  int getNextVerse(Feed state) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;
}
