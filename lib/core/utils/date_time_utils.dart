import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String getRelativeDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = target.difference(today).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    return DateFormat('EEEE').format(date);
  }

  static String formatDurationRemaining(DateTime targetTime) {
    final now = DateTime.now();
    final difference = targetTime.difference(now);

    if (difference.isNegative) {
      return 'Completed';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m left';
    }
    return '${minutes}m left';
  }

  static String formatStartCountdown(DateTime startTime) {
    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative) {
      return 'Ongoing';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return 'Starts in ${hours}h ${minutes}m';
    }
    return 'Starts in ${minutes}m';
  }
}
