import 'package:flutter/foundation.dart';

// an individual book e.g. Matthew
// marking as final breaks ShareInManagerTest
@immutable
class const Book(final String key, final String name, final int chapterCount);
