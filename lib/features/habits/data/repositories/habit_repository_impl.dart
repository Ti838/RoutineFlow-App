import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../presentation/screens/habits_screen.dart';
import '../../../../core/sync/sync_engine.dart';

class HabitRepositoryImpl implements HabitRepository {
  final SyncEngine _syncEngine;
  final List<HabitItem> _habits = [];

  HabitRepositoryImpl({required SyncEngine syncEngine})
      : _syncEngine = syncEngine {
    _initSeedHabits();
  }

  void _initSeedHabits() {
    _habits.addAll([
      HabitItem(
        id: 'habit-1',
        title: 'Morning Code & LeetCode Sprint',
        completedDays: 5,
        targetDays: 7,
        color: const Color(0xFF2563EB),
      ),
      HabitItem(
        id: 'habit-2',
        title: 'Drink 2.5L Water Daily',
        completedDays: 6,
        targetDays: 7,
        color: const Color(0xFF06B6D4),
      ),
      HabitItem(
        id: 'habit-3',
        title: 'Evening Workout & Cardio',
        completedDays: 4,
        targetDays: 5,
        color: const Color(0xFF10B981),
      ),
    ]);
  }

  @override
  Future<List<HabitItem>> getHabits({required String userId}) async {
    return List.unmodifiable(_habits);
  }

  @override
  Future<HabitItem> createHabit(HabitItem habit) async {
    final newHabit = habit.id.isEmpty ? habit.copyWith(id: const Uuid().v4()) : habit;
    _habits.add(newHabit);
    await _syncEngine.enqueueSync(
      entityType: 'habits',
      entityId: newHabit.id,
      action: 'insert',
      payload: {
        'id': newHabit.id,
        'title': newHabit.title,
        'target_days': newHabit.targetDays,
      },
    );
    return newHabit;
  }

  @override
  Future<HabitItem> logHabitCompletion(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final current = _habits[index];
      final updated = current.copyWith(
        completedDays: current.completedDays + 1,
        isCompletedToday: true,
      );
      _habits[index] = updated;

      await _syncEngine.enqueueSync(
        entityType: 'habit_logs',
        entityId: const Uuid().v4(),
        action: 'insert',
        payload: {
          'habit_id': habitId,
          'completed_date': date.toIso8601String().split('T').first,
        },
      );
      return updated;
    }
    throw Exception('Habit not found');
  }

  @override
  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _syncEngine.enqueueSync(
      entityType: 'habits',
      entityId: id,
      action: 'delete',
      payload: {},
    );
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return HabitRepositoryImpl(syncEngine: syncEngine);
});
