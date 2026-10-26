import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class HapticService({required final bool isAvailable}) {
  void impact() {
    // BUG: flutter's services HapticFeedback.lightImpact() does nothing on Samsung Tab S6
    if (isAvailable) Haptics.vibrate(.medium);
  }
}

@integrationTest
@prod
@LazySingleton(as: HapticService)
class ProductionHapticService({required super.isAvailable}) extends HapticService {
  @factoryMethod
  @preResolve
  static Future<HapticService> create() async => HapticService(isAvailable: await Haptics.canVibrate());
}
