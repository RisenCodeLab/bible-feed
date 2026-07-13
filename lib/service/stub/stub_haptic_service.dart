import '../../injectable.env.dart';
import '../haptic_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: HapticService)
class StubHapticService extends HapticService {
  StubHapticService() : super(isAvailable: true);
}
