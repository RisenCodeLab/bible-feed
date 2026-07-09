import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(generateForDir: ['lib'])
// ignore: prefer-static-class, allow global
Future configureDependencies({required String environment}) async {
  await di.reset();
  await di.init(environment: environment);
}
