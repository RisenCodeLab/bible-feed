import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/popup_action.dart';
import '../model/verse.dart';
import 'catchup_manager.dart';
import 'feeds_manager.dart';
import 'popup_manager.dart';
import 'virtual_all_done_date_manager.dart';

@lazySingleton
class CatchupPopupManager(
  final CatchupManager _catchupManager,
  final FeedsManager _feedsManager,
  super.onboardingManager,
  final VirtualAllDoneDateManager _virtualAllDoneDateManager,
) extends PopupManager {
  this {
    onboardingManager.onboardingStoreKeyFragment = 'catchup';
    _catchupManager.addListener(_maybeShow);
  }

  void _maybeShow() {
    if (_catchupManager.isBehind && !_feedsManager.areChaptersRead) show(); // auto show
  }

  @override
  Color get backgroundColor => _catchupManager.isVeryBehind ? Colors.red : Colors.yellow;

  @override
  Color get foregroundColor => _catchupManager.isVeryBehind ? Colors.white : Colors.black;

  @override
  PopupAction get popupAction => .new(
    action: _virtualAllDoneDateManager.reset,
    icon: const Icon(Icons.cancel),
    key: 'catchup_cancel',
    text: 'Ignore and Cancel',
  );

  @override
  String get text {
    assert(_catchupManager.isBehind);
    final chaptersToRead = _catchupManager.chaptersToRead;
    final daysBehind = "${_catchupManager.daysBehind} day${_catchupManager.daysBehind == 1 ? '' : 's'}";
    final alert = "You have $chaptersToRead chapters to read today, because you are now $daysBehind behind.";
    final exhortation = 'Beloved, do not neglect to feed daily upon the word of God, for it is written...';
    return '$alert\n\n$exhortation';
  }

  @override
  String get title => 'Catch Up!';

  @override
  List<Verse>? get verses => [
    .new(
      text: 'as newborn babes, desire the pure milk of the word, that you may grow thereby',
      reference: '1 Peter 2:2 NKJV',
    ),
    .new(text: 'Give us this day our daily bread', reference: 'Matthew 6:11 KJV'),
  ];
}
