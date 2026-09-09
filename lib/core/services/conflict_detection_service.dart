import '../../features/activities/domain/models/activity.dart';

enum ConflictSeverity { info, warning, critical }

class ScheduleConflict {
  final String id;
  final String sourceActivityId;
  final String sourceTitle;
  final String targetActivityId;
  final String targetTitle;
  final ConflictSeverity severity;
  final String message;
  final String suggestedResolution;
  final DateTime conflictTime;

  ScheduleConflict({
    required this.id,
    required this.sourceActivityId,
    required this.sourceTitle,
    required this.targetActivityId,
    required this.targetTitle,
    required this.severity,
    required this.message,
    required this.suggestedResolution,
    required this.conflictTime,
  });
}

class ConflictDetectionService {
  static List<ScheduleConflict> detectConflicts(List<Activity> activities) {
    final conflicts = <ScheduleConflict>[];
    final activeActivities = activities.where((a) => !a.isCancelled && !a.isSkipped).toList();

    for (int i = 0; i < activeActivities.length; i++) {
      for (int j = i + 1; j < activeActivities.length; j++) {
        final a = activeActivities[i];
        final b = activeActivities[j];

        if (_isSameDay(a.date, b.date)) {
          final aStart = _combineDateAndTime(a.date, a.startTime);
          final aEnd = _combineDateAndTime(a.date, a.endTime);
          final bStart = _combineDateAndTime(b.date, b.startTime);
          final bEnd = _combineDateAndTime(b.date, b.endTime);

          if (aStart.isBefore(bEnd) && aEnd.isAfter(bStart)) {
            final isUniConflict = a.isUniversity || b.isUniversity;
            conflicts.add(
              ScheduleConflict(
                id: 'conflict_${a.id}_${b.id}',
                sourceActivityId: a.id,
                sourceTitle: a.title,
                targetActivityId: b.id,
                targetTitle: b.title,
                severity: isUniConflict ? ConflictSeverity.critical : ConflictSeverity.warning,
                message: '${a.title} overlaps with ${b.title}',
                suggestedResolution: isUniConflict
                    ? 'Reschedule personal activity "${a.isUniversity ? b.title : a.title}" to an open free-time slot.'
                    : 'Adjust start time of ${b.title} to after ${a.endTime}.',
                conflictTime: aStart,
              ),
            );
          }
        }
      }
    }
    return conflicts;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _combineDateAndTime(DateTime date, String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1].split(' ')[0] : '0') ?? 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
