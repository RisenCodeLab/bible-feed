import 'package:injectable/injectable.dart';

import '../../injectable.env.dart';
import '../midnight_manager.dart';

@golden
@integrationTest
@LazySingleton(as: MidnightManager)
class StubMidnightManager extends MidnightManager {
  void notify() {
    notifyListeners();
  }
}
