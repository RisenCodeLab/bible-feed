import 'package:bible_feed/model/virtual_all_done_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('assignments update the value and notify even when unchanged', () {
    final VirtualAllDoneDate testee = .new();
    final DateTime date = .new(2025, 10, 27);
    var notifications = 0;
    testee.addListener(() => notifications++);

    testee.value = date;
    expect(testee.value, date);
    expect(notifications, 1);

    testee.value = date;
    expect(testee.value, date);
    expect(notifications, 2);
  });
}
