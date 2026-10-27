import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../service/platform_event_service.dart';
import 'bible_reader_launch_manager.dart';
import 'bible_reader_link_manager.dart';

@lazySingleton
class AppInstallManager(
  final BibleReaderLaunchManager _bibleReaderLaunchManager,
  final BibleReaderLinkManager _bibleReaderLinkManager,
  final PlatformEventService _platformEventService,
) with ChangeNotifier {
  this {
    _platformEventService.addListener(_handleAppInstallOrUninstall);
  }

  Future<void> _handleAppInstallOrUninstall() async {
    if (await _bibleReaderLaunchManager.isAvailable(_bibleReaderLinkManager.linkedBibleReader)) {
      notifyListeners();
    } else {
      _bibleReaderLinkManager.unlinkBibleReader(); // The linked bible reader has been uninstalled.
    }
  }
}
