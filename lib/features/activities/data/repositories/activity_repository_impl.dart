import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/activity_category.dart';
import '../../../../shared/models/priority.dart';
import '../../domain/models/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../../../core/sync/sync_engine.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final SyncEngine _syncEngine;
  final List<Activity> _activities = [];

  ActivityRepositoryImpl({required SyncEngine syncEngine})
      : _syncEngine = syncEngine {
    _initSeedData();
  }

  void _initSeedData() {
    final now = DateTime.now();
    _activities.addAll([
      Activity(
        id: 'act-1',
        userId: 'user_1',
        title: 'CSE 301: Algorithms & Data Structures',
        description: 'Lecture on Dynamic Programming and Graph Traversal',
        date: DateTime(now.year, now.month, now.day),
        startTime: '09:30',
        endTime: '11:00',
        durationMinutes: 90,
        location: 'Room 402, CS Building',
        category: ActivityCategory.university,
        priority: Priority.high,
        isUniversity: true,
        courseCode: 'CSE 301',
        facultyName: 'Prof. Ada Lovelace',
        room: 'Lab 402',
        createdAt: now,
        updatedAt: now,
      ),
      Activity(
        id: 'act-2',
        userId: 'user_1',
        title: 'Deep Work: Algorithm Problem Set',
        description: 'Solve LeetCode Top 150 DP problems',
        date: DateTime(now.year, now.month, now.day),
        startTime: '11:30',
        endTime: '13:00',
        durationMinutes: 90,
        location: 'Central Library Floor 2',
        category: ActivityCategory.study,
        priority: Priority.high,
        createdAt: now,
        updatedAt: now,
      ),
      Activity(
        id: 'act-3',
        userId: 'user_1',
        title: 'BBA 201: Principles of Management',
        description: 'Case study discussion on Agile Leadership',
        date: DateTime(now.year, now.month, now.day),
        startTime: '14:00',
        endTime: '15:30',
        durationMinutes: 90,
        location: 'Auditorium B',
        category: ActivityCategory.university,
        priority: Priority.medium,
        isUniversity: true,
        courseCode: 'BBA 201',
        facultyName: 'Prof. Edgar Codd',
        room: 'Auditorium B',
        createdAt: now,
        updatedAt: now,
      ),
      Activity(
        id: 'act-4',
        userId: 'user_1',
        title: 'Evening Physical Workout',
        description: 'Leg day + 20 min cycling',
        date: DateTime(now.year, now.month, now.day),
        startTime: '17:00',
        endTime: '18:15',
        durationMinutes: 75,
        location: 'Campus Fitness Center',
        category: ActivityCategory.health,
        priority: Priority.medium,
        createdAt: now,
        updatedAt: now,
      ),
    ]);
  }

  @override
  Future<List<Activity>> getActivities({DateTime? date}) async {
    if (date == null) return List.unmodifiable(_activities);
    return _activities.where((a) {
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    }).toList();
  }

  @override
  Future<Activity> createActivity(Activity activity) async {
    final newActivity = activity.id.isEmpty
        ? activity.copyWith(id: const Uuid().v4())
        : activity;
    _activities.add(newActivity);

    await _syncEngine.enqueueSync(
      entityType: 'activities',
      entityId: newActivity.id,
      action: 'insert',
      payload: newActivity.toJson(),
    );

    return newActivity;
  }

  @override
  Future<Activity> updateActivity(Activity activity) async {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
      await _syncEngine.enqueueSync(
        entityType: 'activities',
        entityId: activity.id,
        action: 'update',
        payload: activity.toJson(),
      );
    }
    return activity;
  }

  @override
  Future<void> deleteActivity(String id) async {
    _activities.removeWhere((a) => a.id == id);
    await _syncEngine.enqueueSync(
      entityType: 'activities',
      entityId: id,
      action: 'delete',
      payload: {},
    );
  }

  @override
  Future<Activity> updateStatus(String id, ActivityStatus status) async {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _activities[index].copyWith(status: status, updatedAt: DateTime.now());
      _activities[index] = updated;
      await _syncEngine.enqueueSync(
        entityType: 'activities',
        entityId: id,
        action: 'update',
        payload: updated.toJson(),
      );
      return updated;
    }
    throw Exception('Activity not found');
  }
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return ActivityRepositoryImpl(syncEngine: syncEngine);
});
