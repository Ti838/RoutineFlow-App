import 'package:flutter_test/flutter_test.dart';
import 'package:routineflow_app/core/services/conflict_detection_service.dart';
import 'package:routineflow_app/features/activities/domain/models/activity.dart';
import 'package:routineflow_app/shared/models/activity_category.dart';

void main() {
  group('ConflictDetectionService Tests', () {
    final now = DateTime.now();

    final classActivity = Activity(
      id: '1',
      userId: 'user_1',
      title: 'CSE 301 Algorithms Class',
      date: DateTime(now.year, now.month, now.day),
      startTime: '10:00',
      endTime: '11:30',
      durationMinutes: 90,
      category: ActivityCategory.university,
      isUniversity: true,
      createdAt: now,
      updatedAt: now,
    );

    final conflictingStudy = Activity(
      id: '2',
      userId: 'user_1',
      title: 'Study Session',
      date: DateTime(now.year, now.month, now.day),
      startTime: '11:00',
      endTime: '12:30',
      durationMinutes: 90,
      category: ActivityCategory.study,
      createdAt: now,
      updatedAt: now,
    );

    final nonConflictingWorkout = Activity(
      id: '3',
      userId: 'user_1',
      title: 'Evening Workout',
      date: DateTime(now.year, now.month, now.day),
      startTime: '17:00',
      endTime: '18:00',
      durationMinutes: 60,
      category: ActivityCategory.health,
      createdAt: now,
      updatedAt: now,
    );

    test('detects overlapping activities as conflicts', () {
      final conflicts = ConflictDetectionService.detectConflicts([classActivity, conflictingStudy]);
      expect(conflicts.length, equals(1));
      expect(conflicts.first.sourceActivityId, equals('1'));
      expect(conflicts.first.targetActivityId, equals('2'));
      expect(conflicts.first.severity, equals(ConflictSeverity.critical));
    });

    test('returns empty when no activities overlap', () {
      final conflicts = ConflictDetectionService.detectConflicts([classActivity, nonConflictingWorkout]);
      expect(conflicts.isEmpty, isTrue);
    });
  });
}
