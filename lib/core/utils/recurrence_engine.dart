import '../../shared/models/recurrence_type.dart';

class RecurrenceEngine {
  static List<DateTime> expandOccurrences({
    required DateTime initialDate,
    required RecurrenceType type,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final occurrences = <DateTime>[];
    if (type == RecurrenceType.none) {
      if (initialDate.isAfter(rangeStart.subtract(const Duration(days: 1))) &&
          initialDate.isBefore(rangeEnd.add(const Duration(days: 1)))) {
        occurrences.add(initialDate);
      }
      return occurrences;
    }

    DateTime current = initialDate;
    while (current.isBefore(rangeEnd.add(const Duration(days: 1)))) {
      if (current.isAfter(rangeStart.subtract(const Duration(days: 1)))) {
        occurrences.add(current);
      }
      switch (type) {
        case RecurrenceType.daily:
          current = current.add(const Duration(days: 1));
          break;
        case RecurrenceType.weekly:
          current = current.add(const Duration(days: 7));
          break;
        case RecurrenceType.monthly:
          current = DateTime(current.year, current.month + 1, current.day, current.hour, current.minute);
          break;
        case RecurrenceType.none:
          break;
      }
    }
    return occurrences;
  }
}
