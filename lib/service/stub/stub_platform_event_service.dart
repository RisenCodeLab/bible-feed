import '../../injectable.env.dart';
import '../platform_event_service.dart';
import 'package:injectable/injectable.dart';

// prevent MissingPluginException(No implementation found for method listen on channel com.abian.app_install_events/app_monitor)
@golden
@LazySingleton(as: PlatformEventService)
class StubPlatformEventService extends PlatformEventService {}
