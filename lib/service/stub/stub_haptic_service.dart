import '../../injectable.env.dart';
import '../haptic_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: HapticService)
class GoldenHapticService extends HapticService {
  GoldenHapticService() : super(isAvailable: true);
}
