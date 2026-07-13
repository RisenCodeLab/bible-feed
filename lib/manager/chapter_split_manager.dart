import 'package:injectable/injectable.dart';

import '../model/chapter_split_setting.dart';
import '../model/chapter_splitters.dart';
import 'feed_manager.dart';

@lazySingleton
class ChapterSplitManager {
  final ChapterSplitters _chapterSplitters;
  final ChapterSplitSetting _chapterSplitSetting;

  ChapterSplitManager(this._chapterSplitters, this._chapterSplitSetting);

  int getNextVerse(Feed state) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;

  String getLabel(Feed state) =>
      _chapterSplitSetting.value ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';
}
