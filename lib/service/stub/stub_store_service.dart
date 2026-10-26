import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../injectable.env.dart';
import '../store_service.dart';

@integrationTest
@LazySingleton(as: StoreService)
class StubStoreService(super._sharedPreferences) extends StoreService {
  @factoryMethod
  @preResolve
  static Future<StoreService> create() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    return .new(sp);
  }
}
