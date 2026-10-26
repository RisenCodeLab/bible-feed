import 'package:injectable/injectable.dart';

import '../../injectable.env.dart';
import '../haptic_service.dart';

@golden
@LazySingleton(as: HapticService)
class StubHapticService() extends HapticService {
  this : super(isAvailable: true);
}
