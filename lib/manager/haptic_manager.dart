import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/catchup_setting.dart';
import '../model/chapter_split_setting.dart';
import '../model/haptic_setting.dart';
import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'debounce_manager.dart';
import 'feed_tap_manager.dart';

@singleton
class HapticManager(
  final BibleReaderLinkManager _bibleReaderLinkManager,
  final BookListWheelState _bookListWheelState,
  final CatchupSetting _catchupSetting,
  final ChapterListWheelState _chapterListWheelState,
  final ChapterSplitSetting _chapterSplitSetting,
  final DebounceManager _debounceManager,
  final FeedTapManager _feedTapManager,
  final HapticService _hapticService,
  final HapticSetting _hapticSetting,
) extends RouteObserver<PageRoute<dynamic>> {
  this {
    final notifiers = [
      _bookListWheelState,
      _chapterListWheelState,
      _feedTapManager,
      // settings
      _bibleReaderLinkManager,
      _catchupSetting,
      _chapterSplitSetting,
      _hapticSetting,
    ];
    _hapticSetting.isAvailable = _hapticService.isAvailable;
    for (final notifier in notifiers) {
      notifier.addListener(_maybeImpact);
    }
  }

  void _maybeImpact() {
    _debounceManager.run(
      delay: 10.milliseconds, // ignore: no-magic-number, debounce delay is self-explanatory
      fn: () {
        if (_hapticSetting.value) _hapticService.impact();
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();
}
