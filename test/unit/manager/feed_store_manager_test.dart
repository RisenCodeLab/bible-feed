import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feed_store_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StoreService>()])
void main() async {
  late MockStoreService mockStoreService;
  late FeedStoreManager testee;

  final DateTime yesterday = DateTime.now() - 1.days;

  setUp(() async {
    mockStoreService = MockStoreService();
    testee = FeedStoreManager(mockStoreService);
  });

  group('loadState', () {
    void verify({
      required String bookKey,
      required int chapter,
      required DateTime? dateModified,
      required bool isRead,
      required int verse,
    }) {
      final state = testee.load(rl1);
      expect(state.bookKey, bookKey);
      expect(state.chapter, chapter);
      expect(state.dateModified, dateModified);
      expect(state.isRead, isRead);
      expect(state.verse, verse);
    }

    test('should load defaults if store is empty', () async {
      verify(bookKey: b0.key, chapter: 1, dateModified: null, isRead: false, verse: 1);
    });

    test('should load from store if store is populated', () async {
      when(mockStoreService.get('rl1.book')).thenReturn('b1');
      when(mockStoreService.get('rl1.chapter')).thenReturn(2);
      when(mockStoreService.get('rl1.dateModified')).thenReturn(yesterday);
      when(mockStoreService.get('rl1.isRead')).thenReturn(true);
      when(mockStoreService.get('rl1.verse')).thenReturn(3);
      verify(bookKey: b1.key, chapter: 2, dateModified: yesterday, isRead: true, verse: 3);
    });
  });

  group('saveState', () {
    test('should save to store', () async {
      await testee.save(rl1, Feed(bookKey: b1.key, chapter: 2, dateModified: yesterday, isRead: true, verse: 3));
      verify(mockStoreService.set('rl1.book', 'b1')).called(1);
      verify(mockStoreService.set('rl1.chapter', 2)).called(1);
      verify(mockStoreService.set('rl1.dateModified', yesterday)).called(1);
      verify(mockStoreService.set('rl1.isRead', true)).called(1);
      verify(mockStoreService.set('rl1.verse', 3)).called(1);
    });
  });
}
