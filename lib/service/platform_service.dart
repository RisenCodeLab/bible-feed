import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class PlatformService({required final TargetPlatform currentPlatform}) {
  bool get isAndroid => currentPlatform == .android;
  bool get isIOS => currentPlatform == .iOS;
}

@integrationTest
@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService() extends PlatformService {
  this : super(currentPlatform: defaultTargetPlatform);
}
