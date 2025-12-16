import 'package:injectable/injectable.dart';

import '../service/haptic_service.dart';
import 'setting_manager.dart';

@lazySingleton
class HapticSettingManager extends SettingManager {
  final HapticService _hapticService;

  HapticSettingManager(super._storeService, this._hapticService);


  @override
  bool get canEnable => _hapticService.isAvailable;

  @override
  bool get isEnabledByDefault => false;

  @override
  get storeKeyFragment => 'haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
