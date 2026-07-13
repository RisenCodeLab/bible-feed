import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'feed_manager.dart';
import '../model/feeds_advance_state.dart';
import '../service/date_time_service.dart';
import 'feed_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class FeedsAdvanceManager with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedAdvanceManager _feedAdvanceManager;
  final FeedsManager _feedsManager;

  FeedsAdvanceManager(this._dateTimeService, this._feedAdvanceManager, this._feedsManager);

  FeedsAdvanceState advance() {
    for (FeedManager fm in _feedsManager.feedManagers) {
      _feedAdvanceManager.advance(fm);
    }
    notifyListeners();
    return FeedsAdvanceState.listsAdvanced;
  }

  FeedsAdvanceState maybeAdvance() {
    if (!_feedsManager.areChaptersRead) return FeedsAdvanceState.notAllRead;
    final lastDateModified = _feedsManager.lastModifiedFeed?.feed.dateModified;
    if (lastDateModified == null) return FeedsAdvanceState.notAllRead;
    if (_dateTimeService.now.date.isAfter(lastDateModified.date)) return advance();
    return FeedsAdvanceState.allReadAwaitingTomorrow;
  }
}
