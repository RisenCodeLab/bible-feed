// ignore_for_file: no-magic-number
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'reading_list.dart';

@immutable
@lazySingleton
class ReadingLists(super._items) extends BaseList<ReadingList> {}

@module
abstract class ReadingListsModule {
  @lazySingleton
  List<ReadingList> get readingLists => [
    .new('gos', 'Gospels', const [
      .new('mat', 'Matthew', 28),
      .new('mar', 'Mark', 16),
      .new('luk', 'Luke', 24),
      .new('jhn', 'John', 21),
    ]),
    .new('pen', 'Pentateuch', const [
      .new('gen', 'Genesis', 50),
      .new('exo', 'Exodus', 40),
      .new('lev', 'Leviticus', 27),
      .new('num', 'Numbers', 36),
      .new('deu', 'Deuteronomy', 34),
    ]),
    .new('ep1', 'Epistles I', const [
      .new('rom', 'Romans', 16),
      .new('1co', '1 Corinthians', 16),
      .new('2co', '2 Corinthians', 13),
      .new('gal', 'Galatians', 6),
      .new('eph', 'Ephesians', 6),
      .new('php', 'Philippians', 4),
      .new('col', 'Colossians', 4),
      .new('heb', 'Hebrews', 13),
    ]),
    .new('ep2', 'Epistles II', const [
      .new('1th', '1 Thessalo...', 5),
      .new('2th', '2 Thessalo...', 3),
      .new('1ti', '1 Timothy', 6),
      .new('2ti', '2 Timothy', 4),
      .new('tit', 'Titus', 3),
      .new('phm', 'Philemon', 1),
      .new('jam', 'James', 5),
      .new('1pe', '1 Peter', 5),
      .new('2pe', '2 Peter', 3),
      .new('1jn', '1 John', 5),
      .new('2jn', '2 John', 1),
      .new('3jn', '3 John', 1),
      .new('jud', 'Jude', 1),
      .new('rev', 'Revelation', 22),
    ]),
    .new('wis', 'Wisdom', const [
      .new('job', 'Job', 42),
      .new('ecc', 'Ecclesiastes', 12),
      .new('sos', 'Song of Solomon', 8),
    ]),
    .new('psa', 'Psalms', const [.new('psa', 'Psalm', 150)]),
    .new('prv', 'Proverbs', const [.new('prv', 'Proverbs', 31)]),
    .new('his', 'History', const [
      .new('jos', 'Joshua', 24),
      .new('jdg', 'Judges', 21),
      .new('rth', 'Ruth', 4),
      .new('1sa', '1 Samuel', 31),
      .new('2sa', '2 Samuel', 24),
      .new('1ki', '1 Kings', 22),
      .new('2ki', '2 Kings', 25),
      .new('1cr', '1 Chronicles', 29),
      .new('2cr', '2 Chronicles', 36),
      .new('ezr', 'Ezra', 10),
      .new('neh', 'Nehemiah', 13),
      .new('est', 'Esther', 10),
    ]),
    .new('prp', 'Prophets', const [
      .new('isa', 'Isaiah', 66),
      .new('jer', 'Jeremiah', 52),
      .new('lam', 'Lamentations', 5),
      .new('eze', 'Ezekiel', 48),
      .new('dan', 'Daniel', 12),
      .new('hos', 'Hosea', 14),
      .new('joe', 'Joel', 3),
      .new('amo', 'Amos', 9),
      .new('obd', 'Obadiah', 1),
      .new('jon', 'Jonah', 4),
      .new('mic', 'Micah', 7),
      .new('nah', 'Nahum', 3),
      .new('hab', 'Habakkuk', 3),
      .new('zep', 'Zephaniah', 3),
      .new('hag', 'Haggai', 2),
      .new('zec', 'Zechariah', 14),
      .new('mal', 'Malachi', 4),
    ]),
    .new('act', 'Acts', const [.new('act', 'Acts', 28)]),
  ];
}
