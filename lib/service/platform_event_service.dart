import 'package:df_log/df_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../service/platform_service.dart';
import '/injectable.env.dart';

abstract class PlatformEventService with ChangeNotifier {}

@integrationTest
@prod
@LazySingleton(as: PlatformEventService)
class ProductionPlatformEventService extends PlatformEventService {
  ProductionPlatformEventService(PlatformService platformService) {
    if (platformService.isIOS) return; // IOS cannot detect app (un)install events.
    const EventChannel('com.risencode.bible_feed/app_install_events').receiveBroadcastStream().listen((event) {
      Log.info(event);
      notifyListeners();
    });
  }
}
