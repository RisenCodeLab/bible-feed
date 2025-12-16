import 'package:injectable/injectable.dart';

import '../service/haptic_service.dart';
import 'setting.dart';

@lazySingleton
class HapticSetting extends Setting<bool> {
  final HapticService _hapticService;

  HapticSetting(this._hapticService);

  @override
  bool get isAvailable => _hapticService.isAvailable;

  @override
  bool get defaultValue => false;

  @override
  get storeKeyFragment => 'haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => isAvailable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
