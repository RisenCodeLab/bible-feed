import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import '../../injectable.env.dart';
import '../date_time_service.dart';

@golden
@integrationTest
@LazySingleton(as: DateTimeService)
class StubDateTimeService extends DateTimeService {
  var _now = baseNow;

  static final DateTime baseNow = .new(2026, 7, 12);

  @override
  DateTime get now => _now;

  set now(DateTime value) => _now = value;

  void advance1day() => _now = _now.add(1.days);

  void reset() => _now = baseNow;
}
