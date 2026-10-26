import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'app_lifecycle_manager.dart';
import 'feeds_advance_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class AutoAdvanceManager(
  final AppLifecycleManager _appLifecycleManager,
  final FeedsAdvanceManager _feedsAdvanceManager,
  final MidnightManager _midnightManager,
) with ChangeNotifier {
  this {
    _appLifecycleManager.onResume(_maybeAdvance, priority: .high); // must run before catchup
    _midnightManager.addListener(_maybeAdvance, priority: .high); // must run before catchup
    _maybeAdvance();
  }

  void _maybeAdvance() {
    if (_feedsAdvanceManager.maybeAdvance() == .listsAdvanced) notifyListeners();
  }
}
