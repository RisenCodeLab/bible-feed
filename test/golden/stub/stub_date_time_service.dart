import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: DateTimeService)
class StubDateTimeService extends DateTimeService {
  static final DateTime baseNow = DateTime(2026, 7, 12);

  var _now = baseNow;

  @override
  DateTime get now => _now;

  void advance1day() => _now = _now.add(const Duration(days: 1));

  void reset() => _now = baseNow;
}
