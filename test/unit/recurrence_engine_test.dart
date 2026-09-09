import 'package:flutter_test/flutter_test.dart';
import 'package:routineflow_app/core/utils/recurrence_engine.dart';
import 'package:routineflow_app/core/utils/date_time_utils.dart';
import 'package:routineflow_app/shared/models/recurrence_type.dart';

void main() {
  group('RecurrenceEngine Tests', () {
    test('Expands daily recurrence occurrences properly', () {
      final initial = DateTime(2026, 9, 1);
      final rangeStart = DateTime(2026, 9, 1);
      final rangeEnd = DateTime(2026, 9, 5);

      final occurrences = RecurrenceEngine.expandOccurrences(
        initialDate: initial,
        type: RecurrenceType.daily,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      expect(occurrences.length, 5);
      expect(occurrences.first.day, 1);
      expect(occurrences.last.day, 5);
    });

    test('Expands weekly recurrence occurrences properly', () {
      final initial = DateTime(2026, 9, 1);
      final rangeStart = DateTime(2026, 9, 1);
      final rangeEnd = DateTime(2026, 9, 30);

      final occurrences = RecurrenceEngine.expandOccurrences(
        initialDate: initial,
        type: RecurrenceType.weekly,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      // Sept 1, Sept 8, Sept 15, Sept 22, Sept 29
      expect(occurrences.length, 5);
    });
  });

  group('DateTimeUtils Tests', () {
    test('Formats time with AM/PM', () {
      final time = DateTime(2026, 9, 9, 10, 30);
      expect(DateTimeUtils.formatTime(time), '10:30 AM');
    });

    test('Provides relative day label for today', () {
      final now = DateTime.now();
      expect(DateTimeUtils.getRelativeDayLabel(now), 'Today');
    });
  });
}
