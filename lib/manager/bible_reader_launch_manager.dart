import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import '../model/bible_reader.dart';
import '../model/chapter_split_setting.dart';
import '../model/feed.dart';
import '../service/platform_service.dart';
import '../service/url_launch_service.dart';
import 'debounce_manager.dart';

@lazySingleton
class BibleReaderLaunchManager(
  final ChapterSplitSetting _chapterSplitSetting,
  final DebounceManager _debounceManager,
  final PlatformService _platformService,
  final UrlLaunchService _urlLaunchService,
) {
  String _getDeeplinkUrl(BibleReader bibleReader, String internalBookKey, int chapter, [int verse = 1]) {
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey(internalBookKey);
    var url = bibleReader.urlTemplate[_platformService.currentPlatform]!;
    url = url.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', chapter.toString());
    if (bibleReader.urlVersePath == null || verse == 1) return url;
    // ignore: avoid-non-null-assertion, passed above null check
    return url + bibleReader.urlVersePath!.replaceAll('VERSE', verse.toString());
  }

  Future<bool> isAvailable(BibleReader bibleReader) {
    if (bibleReader.isNone) return Future.value(true);
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey('mat');
    return _urlLaunchService.canLaunchUrl(_getDeeplinkUrl(bibleReader, externalBookKey, 1));
  }

  Future<void> maybeLaunch(BibleReader bibleReader, Feed feed) async {
    if (bibleReader.isNone || !feed.isRead) return;
    final verse = _chapterSplitSetting.value ? feed.verse : 1;
    final url = _getDeeplinkUrl(bibleReader, feed.bookKey, feed.chapter, verse);

    // Debounce URL launches to prevent iOS from rejecting concurrent launch attempts.
    // When two cards are tapped simultaneously, iOS only allows one launch at a time.
    // Without debouncing, the second concurrent call returns false and throws an exception.
    final success = await _debounceManager.runAsync(delay: 1.seconds, fn: () => _urlLaunchService.launchUrl(url));

    if (success == null) return; // debounced, no action
    if (!success) throw Exception('_urlLaunchService.launchUrl($url)');
  }
}
