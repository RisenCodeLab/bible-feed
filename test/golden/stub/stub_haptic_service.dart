import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/haptic_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: HapticService)
class GoldenHapticService extends HapticService {
  GoldenHapticService() : super(isAvailable: true);
}
