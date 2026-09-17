import 'package:bible_feed/manager/debounce_manager.dart';
import 'package:dartx/dartx.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DebounceManager testee;

  setUp(() {
    testee = DebounceManager();
    testee.delay = 100.milliseconds;
  });

  group('run', () {
    test('should execute immediately and debounce subsequent calls', () {
      fakeAsync((async) {
        var executionCount = 0;

        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        testee.run(() => executionCount++);
        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        async.elapse(100.milliseconds);

        testee.run(() => executionCount++);
        expect(executionCount, equals(2));
      });
    });

    test('should not reset timer on subsequent calls', () {
      fakeAsync((async) {
        var executionCount = 0;

        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        async.elapse(50.milliseconds);
        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        async.elapse(40.milliseconds);
        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        async.elapse(100.milliseconds);

        testee.run(() => executionCount++);
        expect(executionCount, equals(2));
      });
    });
  });

  group('runAsync', () {
    test('should return result when executed', () async {
      final result = await testee.runAsync(() async => 42);
      expect(result, equals(42));
    });

    test('should return null when debounced', () async {
      fakeAsync((async) async {
        final first = testee.runAsync(() async => 42);
        final second = testee.runAsync(() async => 99);

        expect(await first, equals(42));
        expect(await second, isNull);

        async.elapse(100.milliseconds);

        final third = testee.runAsync(() async => 100);
        expect(await third, equals(100));
      });
    });

    test('should not reset timer on subsequent calls', () async {
      fakeAsync((async) async {
        var executionCount = 0;

        await testee.runAsync(() async {
          executionCount++;
          return executionCount;
        });
        expect(executionCount, equals(1));

        async.elapse(50.milliseconds);
        await testee.runAsync(() async {
          executionCount++;
          return executionCount;
        });
        expect(executionCount, equals(1));

        async.elapse(40.milliseconds);
        await testee.runAsync(() async {
          executionCount++;
          return executionCount;
        });
        expect(executionCount, equals(1));

        async.elapse(100.milliseconds);

        await testee.runAsync(() async {
          executionCount++;
          return executionCount;
        });
        expect(executionCount, equals(2));
      });
    });
  });

  group('dispose', () {
    test('should prevent execution after dispose', () {
      fakeAsync((async) {
        var executionCount = 0;

        testee.run(() => executionCount++);
        expect(executionCount, equals(1));

        async.elapse(50.milliseconds);
        testee.dispose();
        async.elapse(100.milliseconds);

        testee.run(() => executionCount++);
        expect(executionCount, equals(1));
      });
    });
  });
}
