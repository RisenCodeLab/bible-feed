import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

import '../../injectable.env.dart';
import '../app_service.dart' as base;

@golden
@LazySingleton(as: base.AppService)
class StubAppService({required super.buildNumber, required super.version}) extends base.AppService {
  @factoryMethod
  @preResolve
  static Future<StubAppService> create() async {
    final yaml = loadYaml(await File('pubspec.yaml').readAsString());
    final versionAndBuild = yaml['version'].split('+');
    return .new(buildNumber: versionAndBuild[1].toString(), version: versionAndBuild[0].toString());
  }
}
