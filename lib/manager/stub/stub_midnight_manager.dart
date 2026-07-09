import 'package:injectable/injectable.dart';

import '../../injectable.env.dart';
import '../midnight_manager.dart';

@integrationTest
@LazySingleton(as: MidnightManager)
class StubMidnightManager extends MidnightManager {
  void notify() {
    notifyListeners();
  }
}
