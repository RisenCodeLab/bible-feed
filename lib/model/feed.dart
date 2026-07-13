part of 'package:bible_feed/manager/feed_manager.dart';

@MappableClass()
class Feed with FeedMappable {
  String _bookKey;
  int _chapter;
  DateTime? _dateModified;
  bool _isRead;
  int _verse;

  Feed({required String bookKey, int chapter = 1, int verse = 1, bool isRead = false, DateTime? dateModified})
    : _bookKey = bookKey,
      _chapter = chapter,
      _dateModified = dateModified,
      _isRead = isRead,
      _verse = verse;

  String get bookKey => _bookKey;
  int get chapter => _chapter;
  DateTime? get dateModified => _dateModified;
  bool get isRead => _isRead;
  int get verse => _verse;
}
