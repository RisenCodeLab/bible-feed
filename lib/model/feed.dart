import 'package:dart_mappable/dart_mappable.dart';

part 'feed.mapper.dart';

@MappableClass()
class Feed({
  required var String bookKey,
  var int chapter = 1,
  var int verse = 1,
  var bool isRead = false,
  var DateTime? dateModified,
}) with FeedMappable;
