import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../../../core/sync/sync_engine.dart';

class GoalRepositoryImpl implements GoalRepository {
  final SyncEngine _syncEngine;
  final List<Goal> _goals = [];

  GoalRepositoryImpl({required SyncEngine syncEngine})
      : _syncEngine = syncEngine {
    _initSeedGoals();
  }

  void _initSeedGoals() {
    final now = DateTime.now();
    _goals.addAll([
      Goal(
        id: 'goal-1',
        userId: 'user-1',
        title: 'Achieve 3.8+ GPA this Semester',
        description: 'Score A in Algorithms, Database Systems, and Linear Algebra',
        targetDate: DateTime(now.year, now.month + 3, 20),
        progressPercentage: 65.0,
        category: 'Academic',
      ),
      Goal(
        id: 'goal-2',
        userId: 'user-1',
        title: 'Complete Full-Stack Flutter Certification',
        description: 'Build production mobile portfolio applications with Supabase',
        targetDate: DateTime(now.year, now.month + 1, 15),
        progressPercentage: 80.0,
        category: 'Career',
      ),
    ]);
  }

  @override
  Future<List<Goal>> getGoals({required String userId}) async {
    return List.unmodifiable(_goals);
  }

  @override
  Future<Goal> createGoal(Goal goal) async {
    final newGoal = goal.id.isEmpty ? goal.copyWith(id: const Uuid().v4()) : goal;
    _goals.add(newGoal);
    await _syncEngine.enqueueSync(
      entityType: 'goals',
      entityId: newGoal.id,
      action: 'insert',
      payload: {
        'id': newGoal.id,
        'user_id': newGoal.userId,
        'title': newGoal.title,
        'description': newGoal.description,
        'progress_percentage': newGoal.progressPercentage,
        'category': newGoal.category,
      },
    );
    return newGoal;
  }

  @override
  Future<Goal> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await _syncEngine.enqueueSync(
        entityType: 'goals',
        entityId: goal.id,
        action: 'update',
        payload: {
          'id': goal.id,
          'title': goal.title,
          'progress_percentage': goal.progressPercentage,
          'is_completed': goal.isCompleted,
        },
      );
    }
    return goal;
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    await _syncEngine.enqueueSync(
      entityType: 'goals',
      entityId: id,
      action: 'delete',
      payload: {},
    );
  }
}

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return GoalRepositoryImpl(syncEngine: syncEngine);
});
