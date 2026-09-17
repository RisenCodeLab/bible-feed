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
