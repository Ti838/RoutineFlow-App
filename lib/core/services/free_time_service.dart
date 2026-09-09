import '../../features/activities/domain/models/activity.dart';

class FreeTimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  FreeTimeSlot({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  String get formattedRange {
    final startStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startStr - $endStr';
  }
}

class FreeTimeService {
  static List<FreeTimeSlot> calculateFreeTimeSlots({
    required DateTime date,
    required List<Activity> activities,
    int dayStartHour = 8,
    int dayEndHour = 22,
    int minSlotMinutes = 30,
  }) {
    final dayActivities = activities
        .where((a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day &&
            !a.isCancelled &&
            !a.isSkipped)
        .toList();

    dayActivities.sort((a, b) => a.startTime.compareTo(b.startTime));

    final freeSlots = <FreeTimeSlot>[];
    DateTime cursor = DateTime(date.year, date.month, date.day, dayStartHour, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, dayEndHour, 0);

    for (final act in dayActivities) {
      final actStart = _parseTime(date, act.startTime);
      final actEnd = _parseTime(date, act.endTime);

      if (actStart.isAfter(cursor)) {
        final gapMinutes = actStart.difference(cursor).inMinutes;
        if (gapMinutes >= minSlotMinutes) {
          freeSlots.add(FreeTimeSlot(
            startTime: cursor,
            endTime: actStart,
            durationMinutes: gapMinutes,
          ));
        }
      }

      if (actEnd.isAfter(cursor)) {
        cursor = actEnd;
      }
    }

    if (cursor.isBefore(dayEnd)) {
      final gapMinutes = dayEnd.difference(cursor).inMinutes;
      if (gapMinutes >= minSlotMinutes) {
        freeSlots.add(FreeTimeSlot(
          startTime: cursor,
          endTime: dayEnd,
          durationMinutes: gapMinutes,
        ));
      }
    }

    return freeSlots;
  }

  static DateTime _parseTime(DateTime date, String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1].split(' ')[0] : '0') ?? 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
