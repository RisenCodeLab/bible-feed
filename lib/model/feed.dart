import 'package:dart_mappable/dart_mappable.dart';

part 'feed.mapper.dart';

@MappableClass()
class Feed with FeedMappable {
  String bookKey;
  int chapter;
  DateTime? dateModified;
  bool isRead;
  int verse;

  Feed({required String bookKey, int chapter = 1, int verse = 1, bool isRead = false, DateTime? dateModified})
    : bookKey = bookKey,
      chapter = chapter,
      dateModified = dateModified,
      isRead = isRead,
      verse = verse;
}
