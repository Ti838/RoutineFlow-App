import 'package:flutter_test/flutter_test.dart';
import 'package:routineflow_app/core/services/free_time_service.dart';
import 'package:routineflow_app/features/activities/domain/models/activity.dart';
import 'package:routineflow_app/shared/models/activity_category.dart';

void main() {
  group('FreeTimeService Tests', () {
    final today = DateTime(2026, 9, 9);
    final now = DateTime.now();

    test('Calculates free time slots between scheduled activities', () {
      final act1 = Activity(
        id: '1',
        userId: 'u1',
        title: 'Morning Class',
        date: today,
        startTime: '09:00',
        endTime: '10:00',
        durationMinutes: 60,
        category: ActivityCategory.university,
        createdAt: now,
        updatedAt: now,
      );

      final act2 = Activity(
        id: '2',
        userId: 'u1',
        title: 'Afternoon Study',
        date: today,
        startTime: '11:30',
        endTime: '13:00',
        durationMinutes: 90,
        category: ActivityCategory.study,
        createdAt: now,
        updatedAt: now,
      );

      final freeSlots = FreeTimeService.calculateFreeTimeSlots(
        date: today,
        activities: [act1, act2],
        dayStartHour: 8,
        dayEndHour: 18,
      );

      // Slot 1: 08:00 - 09:00 (60 min)
      // Slot 2: 10:00 - 11:30 (90 min)
      // Slot 3: 13:00 - 18:00 (300 min)
      expect(freeSlots.length, 3);
      expect(freeSlots[1].formattedRange, '10:00 - 11:30');
      expect(freeSlots[1].durationMinutes, 90);
    });
  });
}
