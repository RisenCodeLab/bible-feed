import 'package:dart_mappable/dart_mappable.dart';

part 'feed.mapper.dart';

@MappableClass()
class Feed with FeedMappable {
  String bookKey;
  int chapter;
  DateTime? dateModified;
  bool isRead;
  int verse;

  Feed({required this.bookKey, this.chapter = 1, this.verse = 1, this.isRead = false, this.dateModified});
}
