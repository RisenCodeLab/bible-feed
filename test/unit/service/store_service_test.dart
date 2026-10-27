import 'package:bible_feed/service/store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StoreService testee;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    testee = .new(await SharedPreferences.getInstance());
  });

  parameterizedTest(
    'stores and retrieves values',
    [
      ['boolKey', true, (String k) => testee.get<bool>(k)],
      ['intKey', 42, (String k) => testee.get<int>(k)],
      ['stringKey', 'hello', (String k) => testee.get<String>(k)],
      ['dateKey', DateTime.utc(2024, 1, 1, 12), (String k) => testee.get<DateTime>(k)],
    ],
    (String key, Object value, Object? Function(String) getter) async {
      await testee.set(key, value);
      expect(getter(key), value);
    },
  );

  test('date-like strings are intentionally coerced to DateTime', () async {
    const value = '2026-09-07T10:30:00.000Z';
    await testee.set('dateLikeStringKey', value);
    expect(testee.get<DateTime>('dateLikeStringKey'), DateTime.parse(value));
  });

  test('returns null for missing key', () {
    expect(testee.get<String>('missingKey'), isNull);
  });

  test('setting null removes the key', () async {
    await testee.set('key', 42);
    expect(testee.get<int>('key'), 42);
    await testee.set('key', null);
    expect(testee.get<int>('key'), isNull);
  });
}
