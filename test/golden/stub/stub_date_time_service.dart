import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: DateTimeService)
class StubDateTimeService extends DateTimeService {
  var _now = DateTime(2026,7,12);

  @override
  DateTime get now => _now;

  set now(DateTime value) => _now = value;

  void advance1day() => _now = _now.add(const Duration(days: 1));
}
