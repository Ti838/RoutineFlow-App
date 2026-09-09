import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/priority.dart';
import '../../domain/repositories/task_repository.dart';
import '../../presentation/screens/tasks_screen.dart';
import '../../../../core/sync/sync_engine.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SyncEngine _syncEngine;
  final List<TaskItem> _tasks = [];

  TaskRepositoryImpl({required SyncEngine syncEngine})
      : _syncEngine = syncEngine {
    _initSeedTasks();
  }

  void _initSeedTasks() {
    final now = DateTime.now();
    _tasks.addAll([
      TaskItem(
        id: 'task-1',
        title: 'Submit CSE 301 Lab Assignment 2',
        description: 'Implement Dijkstra and Bellman-Ford algorithms',
        dueDate: DateTime(now.year, now.month, now.day, 23, 59),
        priority: Priority.urgent,
        category: 'CSE 301',
      ),
      TaskItem(
        id: 'task-2',
        title: 'Prepare Slide Deck for BBA Group Presentation',
        description: 'Cover financial projections & team breakdown',
        dueDate: now.add(const Duration(days: 2)),
        priority: Priority.high,
        category: 'BBA 201',
      ),
      TaskItem(
        id: 'task-3',
        title: 'Read Chapter 4: SQL Indexing and Optimization',
        description: 'Database Systems textbook pages 120-155',
        dueDate: now.add(const Duration(days: 3)),
        priority: Priority.medium,
        category: 'CSE 320',
      ),
    ]);
  }

  @override
  Future<List<TaskItem>> getTasks({required String userId}) async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<TaskItem> createTask(TaskItem task) async {
    final newTask = task.id.isEmpty ? task.copyWith(id: const Uuid().v4()) : task;
    _tasks.add(newTask);
    await _syncEngine.enqueueSync(
      entityType: 'tasks',
      entityId: newTask.id,
      action: 'insert',
      payload: {
        'id': newTask.id,
        'title': newTask.title,
        'description': newTask.description,
        'due_date': newTask.dueDate.toIso8601String(),
        'priority': newTask.priority.name,
        'is_completed': newTask.isCompleted,
      },
    );
    return newTask;
  }

  @override
  Future<TaskItem> updateTask(TaskItem task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _syncEngine.enqueueSync(
        entityType: 'tasks',
        entityId: task.id,
        action: 'update',
        payload: {
          'id': task.id,
          'title': task.title,
          'is_completed': task.isCompleted,
        },
      );
    }
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _syncEngine.enqueueSync(
      entityType: 'tasks',
      entityId: id,
      action: 'delete',
      payload: {},
    );
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return TaskRepositoryImpl(syncEngine: syncEngine);
});
