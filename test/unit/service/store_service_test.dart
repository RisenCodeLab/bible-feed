import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible_feed/service/store_service.dart';

void main() {
  late StoreService testee;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sp = await SharedPreferences.getInstance();
    testee = StoreService(sp);
  });

  test('stores and retrieves bool', () async {
    await testee.set('boolKey', true);
    final value = testee.get<bool>('boolKey');
    expect(value, true);
  });

  test('stores and retrieves int', () async {
    await testee.set('intKey', 42);
    final value = testee.get<int>('intKey');
    expect(value, 42);
  });

  test('stores and retrieves string', () async {
    await testee.set('stringKey', 'hello');
    final value = testee.get<String>('stringKey');
    expect(value, 'hello');
  });

  test('stores and retrieves DateTime', () async {
    final now = DateTime.utc(2024, 1, 1, 12);
    await testee.set('dateKey', now);
    final value = testee.get<DateTime>('dateKey');
    expect(value, now);
  });

  test('returns null for missing key', () {
    final value = testee.get<String>('missingKey');
    expect(value, isNull);
  });
}
