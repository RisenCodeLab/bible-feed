import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../injectable.env.dart';

abstract class AppService({required final String buildNumber, required final String version});

@integrationTest
@prod
@LazySingleton(as: AppService)
class ProductionAppService({required super.buildNumber, required super.version}) extends AppService {
  @factoryMethod
  @preResolve
  static Future<AppService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return ProductionAppService(buildNumber: packageInfo.buildNumber, version: packageInfo.version);
  }
}
