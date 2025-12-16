import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class HapticService {
  HapticService({required this.isAvailable});

  final bool isAvailable;

  void impact() {
    // BUG: flutter's services HapticFeedback.lightImpact() does nothing on Samsung Tab S6
    if (isAvailable) Haptics.vibrate(HapticsType.medium);
  }
}

@integrationTest
@prod
@LazySingleton(as: HapticService)
class ProductionHapticService extends HapticService {
  ProductionHapticService({required super.isAvailable});

  @factoryMethod
  @preResolve
  static Future<HapticService> create() async => HapticService(isAvailable: await Haptics.canVibrate());
}
