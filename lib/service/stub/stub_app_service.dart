import 'dart:io';

import '../../injectable.env.dart';
import '../app_service.dart' as base;
import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

@golden
@LazySingleton(as: base.AppService)
class StubAppService extends base.AppService {
  StubAppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<StubAppService> create() async {
    final yaml = loadYaml(await File('pubspec.yaml').readAsString());
    final versionAndBuild = yaml['version'].split('+');
    return StubAppService(buildNumber: versionAndBuild[1].toString(), version: versionAndBuild[0].toString());
  }
}
