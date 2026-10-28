import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'bible_reader.dart';

@immutable
@lazySingleton
class BibleReaders(super._items) extends BaseList<BibleReader> {}

// Android bible readers must be added to the queries section of AndroidManifest.xml.
// IOS bible reader schemes must be added to LSApplicationQueriesSchemes in Info.plist.
//
// Certain Bible readers are uncertified due to the following issues:
//
// Accordance Bible ios: accord://read/John+3:17 displays verse 17 in isolation
// AndBible: see below
// Life Bible: see below
// WeDevote android: not detected
//
@module
abstract class BibleReadersModule {
  @lazySingleton
  List<BibleReader> get bibleReader => [
    .new(key: .none, type: .none, name: 'None', urlTemplate: .new(''), certifiedPlatforms: const [.android, .iOS]),
    .new(
      key: .andBibleApp,
      type: .app,
      name: 'AndBible',
      urlTemplate: .new('https://read.andbible.org/BOOK.CHAPTER'),
      // Not certified because deep links are not working: https://github.com/AndBible/and-bible/issues/3210
    ),
    .new(
      key: .blueLetterApp,
      type: .app,
      name: 'Blue Letter Bible',
      urlTemplate: .byPlatform(android: 'blb://bible/BOOK/CHAPTER', iOS: 'blb://BOOK/CHAPTER'),
      certifiedPlatforms: const [.android, .iOS],
      bookKeyExternaliser: .blueLetter,
      urlVersePath: '/VERSE',
    ),
    .new(
      key: .blueLetterWeb,
      type: .web,
      name: 'Blue Letter Bible',
      urlTemplate: .new('https://www.blueletterbible.org/nkjv/BOOK/CHAPTER'),
      certifiedPlatforms: const [.android, .iOS],
      bookKeyExternaliser: .blueLetter,
      urlVersePath: '/VERSE',
    ),
    .new(
      key: .lifeBibleApp,
      type: .app,
      name: 'Life Bible',
      urlTemplate: .new('tecartabible://BOOK CHAPTER'), // 'https://tecartabible.com/bible/BOOK+CHAPTER'
      // Not certified due to these issues:
      // - :VERSE works only via https
      // - forcibly reverts translation over https
      // - 3-letter book keys are not documented, but mostly work on ios or over https on android (e.g. 2 chronicles broken)
      // - android back button works but needs 2 taps
      urlVersePath: ':VERSE',
    ),
    .new(
      key: .logosBibleApp,
      type: .app,
      name: 'Logos Bible',
      urlTemplate: .new('logosref:Bible.BOOK.CHAPTER'),
      certifiedPlatforms: const [.android, .iOS],
      bookKeyExternaliser: .logos,
      urlVersePath: '.VERSE',
    ),
    .new(
      key: .oliveTreeApp,
      type: .app,
      name: 'Olive Tree',
      urlTemplate: .new('olivetree://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [.android, .iOS],
      bookKeyExternaliser: .oliveTree,
      urlVersePath: '.VERSE',
    ),
    .new(
      key: .openBibleApp,
      type: .app,
      name: 'OpenBible',
      urlTemplate: .new('openbible://BOOK/CHAPTER'),
      certifiedPlatforms: const [.android],
      bookKeyExternaliser: .openBible,
      urlVersePath: '/VERSE',
    ),
    .new(
      key: .weDevoteApp,
      type: .app,
      name: 'WeDevote',
      urlTemplate: .new('wdbible://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [.iOS], // not detected on android
      bookKeyExternaliser: .osisParatext,
      urlVersePath: '.VERSE',
    ),
    .new(
      key: .youVersionApp,
      type: .app,
      name: 'YouVersion',
      urlTemplate: .new('youversion://bible?reference=BOOK.CHAPTER'),
      certifiedPlatforms: const [.android, .iOS],
      bookKeyExternaliser: .osisParatext,
      urlVersePath: '.VERSE',
    ),
  ];
}
