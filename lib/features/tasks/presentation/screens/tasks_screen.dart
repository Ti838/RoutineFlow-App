import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/models/priority.dart';

enum TaskStatus { todo, inProgress, completed, cancelled }

class TaskItem {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final Priority priority;
  final TaskStatus status;
  final List<String> subtasks;
  final String? category;

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = Priority.medium,
    this.status = TaskStatus.todo,
    this.subtasks = const [],
    this.category,
  });

  bool get isCompleted => status == TaskStatus.completed;

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    TaskStatus? status,
    List<String>? subtasks,
    String? category,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subtasks: subtasks ?? this.subtasks,
      category: category ?? this.category,
    );
  }
}

class TasksNotifier extends StateNotifier<List<TaskItem>> {
  TasksNotifier()
      : super([
          TaskItem(
            id: 'task_1',
            title: 'Complete DSA assignment',
            dueDate: DateTime.now(),
            priority: Priority.urgent,
            status: TaskStatus.todo,
            category: 'University',
          ),
          TaskItem(
            id: 'task_2',
            title: 'Read database chapter 5',
            dueDate: DateTime.now(),
            priority: Priority.high,
            status: TaskStatus.todo,
            category: 'Study',
          ),
          TaskItem(
            id: 'task_3',
            title: 'Build portfolio website',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            priority: Priority.medium,
            status: TaskStatus.todo,
            category: 'Personal',
          ),
          TaskItem(
            id: 'task_4',
            title: 'Buy course materials',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            priority: Priority.low,
            status: TaskStatus.todo,
            category: 'Personal',
          ),
          TaskItem(
            id: 'task_5',
            title: 'Workout session',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            priority: Priority.medium,
            status: TaskStatus.completed,
            category: 'Health',
          ),
        ]);

  void toggleTask(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(
          status: task.isCompleted ? TaskStatus.todo : TaskStatus.completed,
        );
      }
      return task;
    }).toList();
  }

  void addTask(String title, Priority priority, String category) {
    final newTask = TaskItem(
      id: const Uuid().v4(),
      title: title,
      dueDate: DateTime.now(),
      priority: priority,
      category: category,
    );
    state = [newTask, ...state];
  }

  void deleteTask(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskItem>>((ref) {
  return TasksNotifier();
});

enum TaskFilter { all, today, upcoming, completed }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksProvider);
    final filter = ref.watch(taskFilterProvider);

    final filteredTasks = allTasks.where((task) {
      switch (filter) {
        case TaskFilter.all:
          return true;
        case TaskFilter.today:
          return !task.isCompleted && task.dueDate.day == DateTime.now().day;
        case TaskFilter.upcoming:
          return !task.isCompleted && task.dueDate.isAfter(DateTime.now());
        case TaskFilter.completed:
          return task.isCompleted;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(ref, 'All', TaskFilter.all, filter),
                  const SizedBox(width: 8),
                  _filterChip(ref, 'Today', TaskFilter.today, filter),
                  const SizedBox(width: 8),
                  _filterChip(ref, 'Upcoming', TaskFilter.upcoming, filter),
                  const SizedBox(width: 8),
                  _filterChip(ref, 'Completed', TaskFilter.completed, filter),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Tasks List
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Text('No tasks found in this section', style: AppTypography.body.copyWith(color: AppColors.textSecondaryLight)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: AppRadius.radiusLg,
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (_) => ref.read(tasksProvider.notifier).toggleTask(task.id),
                          ),
                          title: Text(
                            task.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? AppColors.textMutedLight : null,
                            ),
                          ),
                          subtitle: Text(
                            task.category != null ? '${task.category!} • Today' : 'Today',
                            style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textMutedLight),
                            onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(WidgetRef ref, String label, TaskFilter filterVal, TaskFilter active) {
    final selected = filterVal == active;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primaryContainer,
      onSelected: (_) => ref.read(taskFilterProvider.notifier).state = filterVal,
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(tasksProvider.notifier).addTask(controller.text.trim(), Priority.medium, 'Personal');
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
