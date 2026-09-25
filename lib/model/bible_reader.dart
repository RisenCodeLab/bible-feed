import 'package:flutter/foundation.dart';

import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';
import 'url_template.dart';

@immutable
class BibleReader {
  const BibleReader({
    required this.key,
    required this.type,
    required this.name,
    required this.urlTemplate,
    this.certifiedPlatforms = const [],
    this.bookKeyExternaliser = BookKeyExternaliser.identity,
    this.urlVersePath,
  });

  final BookKeyExternaliser bookKeyExternaliser;
  final List<TargetPlatform> certifiedPlatforms; // platforms confirmed working with no issues
  final BibleReaderKey key;
  final String name;
  final UrlTemplate urlTemplate;
  final BibleReaderType type;
  final String? urlVersePath;

  // calculated getters
  String get displayName => '$name ${isNone ? '' : type.name}'.trim();
  bool get isApp => type == BibleReaderType.app;
  bool get isNone => type == BibleReaderType.none;
}
