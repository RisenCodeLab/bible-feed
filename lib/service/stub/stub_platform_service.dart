import '../../injectable.env.dart';
import '../platform_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: PlatformService)
class StubPlatformService extends PlatformService {
  StubPlatformService() : super(currentPlatform: TargetPlatform.android);
}
