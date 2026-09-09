import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String? payload;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.payload,
    this.isRead = false,
  });
}

class NotificationService extends StateNotifier<List<AppNotification>> {
  NotificationService() : super([]);

  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final notification = AppNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
    );

    state = [...state.where((n) => n.id != id), notification];
    debugPrint('Scheduled notification [$title] for $scheduledTime');
  }

  Future<void> cancelNotification(String id) async {
    state = state.where((n) => n.id != id).toList();
  }

  Future<void> scheduleClassReminder({
    required String courseName,
    required String room,
    required DateTime startTime,
  }) async {
    final alertTime = startTime.subtract(const Duration(minutes: 15));
    if (alertTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 'class_${courseName}_${startTime.millisecondsSinceEpoch}',
        title: 'Upcoming Class: $courseName',
        body: 'Starts in 15 minutes at $room. Tap to view details.',
        scheduledTime: alertTime,
      );
    }
  }

  Future<void> scheduleExamAlert({
    required String examTitle,
    required DateTime examDate,
    required String room,
  }) async {
    final dayBefore = examDate.subtract(const Duration(hours: 24));
    final minuteStr = examDate.minute.toString().padLeft(2, '0');
    if (dayBefore.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 'exam_${examTitle}_${examDate.millisecondsSinceEpoch}',
        title: 'Exam Tomorrow: $examTitle',
        body: 'Scheduled in $room at ${examDate.hour}:$minuteStr',
        scheduledTime: dayBefore,
      );
    }
  }
}

final notificationServiceProvider =
    StateNotifierProvider<NotificationService, List<AppNotification>>((ref) {
  return NotificationService();
});
