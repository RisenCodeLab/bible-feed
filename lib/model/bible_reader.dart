import 'package:flutter/foundation.dart';

import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';
import 'url_template.dart';

@immutable
class const BibleReader({
  required final BibleReaderKey key,
  required final BibleReaderType type,
  required final String name,
  required final UrlTemplate urlTemplate,
  final BookKeyExternaliser bookKeyExternaliser = .identity,
  final List<TargetPlatform> certifiedPlatforms = const [], // platforms confirmed working with no issues
  final String? urlVersePath,
}) {
  // calculated getters
  String get displayName => '$name ${isNone ? '' : type.name}'.trim();
  bool get isApp => type == .app;
  bool get isNone => type == .none;
}
