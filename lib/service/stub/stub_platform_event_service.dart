import 'package:injectable/injectable.dart';

import '../../injectable.env.dart';
import '../platform_event_service.dart';

// prevent MissingPluginException(No implementation found for method listen on channel com.risencode.bible_feed/app_install_events)
@golden
@LazySingleton(as: PlatformEventService)
class StubPlatformEventService extends PlatformEventService {}

