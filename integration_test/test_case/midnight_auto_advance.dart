import 'package:bible_feed/injectable.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/manager/stub/stub_midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/stub/stub_date_time_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';

import '_helper.dart';

Future runMidnightAdvanceTest() async {
  testWidgets('auto advance at midnight', (t) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await configureDependencies(environment: 'integration_test');

    final stubDateTimeService = sl<DateTimeService>() as StubDateTimeService;
    final stubMidnightManager = sl<MidnightManager>() as StubMidnightManager;

    await t.startApp();
    await t.tapAllLists();
    expectText('All done');

    stubDateTimeService.advance1day();
    stubMidnightManager.notify();

    await t.pumpAndSettle(); // must wait for async code to run
    expectChapters(2);
    expectNoText('All done');
  });
}
