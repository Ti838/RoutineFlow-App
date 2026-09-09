import '../../presentation/screens/tasks_screen.dart';

abstract class TaskRepository {
  Future<List<TaskItem>> getTasks({required String userId});
  Future<TaskItem> createTask(TaskItem task);
  Future<TaskItem> updateTask(TaskItem task);
  Future<void> deleteTask(String id);
}
