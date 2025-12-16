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
class HapticManager extends RouteObserver<PageRoute<dynamic>> {
  final DebounceManager _debounceManager;
  final HapticService _hapticService;
  final HapticSetting _hapticSetting;

  HapticManager(
    this._debounceManager,
    this._hapticService,
    this._hapticSetting,
    BibleReaderLinkManager bibleReaderLinkManager,
    BookListWheelState bookListWheelState,
    CatchupSetting catchupSetting,
    ChapterListWheelState chapterListWheelState,
    ChapterSplitSetting chapterSplitSetting,
    FeedTapManager feedTapManager,
  ) {
    final notifiers = [
      bookListWheelState,
      chapterListWheelState,
      feedTapManager,
      // settings
      bibleReaderLinkManager,
      catchupSetting,
      chapterSplitSetting,
      _hapticSetting,
    ];
    for (final notifier in notifiers) {
      notifier.addListener(_maybeImpact);
    }
  }

  void _maybeImpact() {
    _debounceManager.run(() {
      if (_hapticSetting.value) _hapticService.impact();
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();
}
