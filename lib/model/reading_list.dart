import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'book.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) without state
@immutable
final class ReadingList(final String key, final String name, super._items) extends BaseList<Book> {
  final int totalChapters = _items.totalChapters;

  /// methods
  int chaptersTo(int bookIndex, int chapter) => sublistTo(bookIndex).totalChapters + chapter;
  Book getBook(String key) => where((Book b) => b.key == key).single;
  double progressTo(int bookIndex, int chapter) => chaptersTo(bookIndex, chapter) / totalChapters;
}

extension ListExtension on List<Book> {
  int get totalChapters => fold(0, (t, b) => t + b.chapterCount);
}
