import 'package:injectable/injectable.dart';

import '../model/chapter_split_setting.dart';
import '../model/chapter_splitters.dart';
import '../model/feed.dart';

@lazySingleton
class ChapterSplitManager(final ChapterSplitSetting _chapterSplitSetting, final ChapterSplitters _chapterSplitters) {
  String getLabel(Feed feed) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(feed)?.getLabel(feed) ?? '') : '';

  int getNextVerse(Feed feed) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(feed)?.getNextVerse(feed) ?? 1) : 1;
}
