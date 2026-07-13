import 'package:bible_feed/model/chapter_split_setting.dart';
import 'package:bible_feed/model/chapter_splitter.dart';
import 'package:bible_feed/model/chapter_splitters.dart';
import 'package:bible_feed/manager/feed_manager.dart';
import 'package:bible_feed/manager/chapter_split_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'chapter_split_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChapterSplitter>(), MockSpec<ChapterSplitters>(), MockSpec<ChapterSplitSetting>()])
void main() {
  final mockChapterSplitter = MockChapterSplitter();
  final mockChapterSplitters = MockChapterSplitters();
  final mockChapterSplitSetting = MockChapterSplitSetting();
  final feed = Feed(bookKey: b0.key);
  late ChapterSplitManager testee;

  setUp(() {
    when(mockChapterSplitSetting.value).thenReturn(true);
    testee = ChapterSplitManager(mockChapterSplitters, mockChapterSplitSetting);
  });

  group('getNextVerse', () {
    test('disabled, should return 1 and empty string', () {
      when(mockChapterSplitSetting.value).thenReturn(false);
      expect(testee.getNextVerse(feed), 1);
      expect(testee.getLabel(feed), '');
    });

    test('no splitter, should return 1 and empty string', () {
      when(mockChapterSplitters.find(feed)).thenReturn(null);
      expect(testee.getNextVerse(feed), 1);
      expect(testee.getLabel(feed), '');
    });

    test('enabled splitter, should return next verse and label from splitter', () {
      when(mockChapterSplitter.getNextVerse(feed)).thenReturn(2);
      when(mockChapterSplitter.getLabel(feed)).thenReturn('label');
      when(mockChapterSplitters.find(feed)).thenReturn(mockChapterSplitter);
      expect(testee.getNextVerse(feed), 2);
      expect(testee.getLabel(feed), 'label');
    });
  });
}
