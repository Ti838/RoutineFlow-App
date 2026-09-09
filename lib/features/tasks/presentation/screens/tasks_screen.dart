import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../shared/models/priority.dart';
import '../../../../shared/widgets/empty_state_view.dart';

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
            title: 'Complete Data Structures Assignment (Graph Algorithms)',
            dueDate: DateTime.now(),
            priority: Priority.urgent,
            status: TaskStatus.todo,
            category: 'University',
          ),
          TaskItem(
            id: 'task_2',
            title: 'Read Database Systems Chapter 5 (Transactions & Indexing)',
            dueDate: DateTime.now(),
            priority: Priority.high,
            status: TaskStatus.todo,
            category: 'Study',
          ),
          TaskItem(
            id: 'task_3',
            title: 'Refactor Routine Flow UI Architecture & Responsive Shell',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            priority: Priority.medium,
            status: TaskStatus.todo,
            category: 'Personal',
          ),
          TaskItem(
            id: 'task_4',
            title: 'Purchase Academic Notebooks and Stationery',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            priority: Priority.low,
            status: TaskStatus.todo,
            category: 'Personal',
          ),
          TaskItem(
            id: 'task_5',
            title: 'Cardio Workout & Core Training',
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
    final isWide = ResponsiveBreakpoints.isMedium(context) || ResponsiveBreakpoints.isExpanded(context);

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
        title: Text('Tasks & Priorities', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
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

          // Tasks List / Empty State
          Expanded(
            child: filteredTasks.isEmpty
                ? EmptyStateView(
                    icon: Icons.check_circle_outline,
                    title: 'No Tasks Found',
                    description: filter == TaskFilter.completed
                        ? 'No completed tasks yet. Finish your pending tasks to see them here!'
                        : 'Your task list is clean and clear for this filter.',
                    actionText: 'Add New Task',
                    onAction: () => _showAddTaskDialog(context, ref),
                  )
                : isWide
                    ? GridView.builder(
                        padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 80,
                        ),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) => _buildTaskTile(context, ref, filteredTasks[index]),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: filteredTasks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => _buildTaskTile(context, ref, filteredTasks[index]),
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

  Widget _buildTaskTile(BuildContext context, WidgetRef ref, TaskItem task) {
    Color priorityColor = AppColors.primary;
    if (task.priority == Priority.urgent) {
      priorityColor = AppColors.error;
    } else if (task.priority == Priority.high) {
      priorityColor = AppColors.warning;
    }

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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              task.category != null ? '${task.category!} • Today' : 'Today',
              style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textMutedLight),
          onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
        ),
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
    Priority selectedPriority = Priority.medium;
    String selectedCategory = 'University';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g. Prepare presentation slides...',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'University', child: Text('University')),
                  DropdownMenuItem(value: 'Study', child: Text('Study')),
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Health', child: Text('Health')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Priority>(
                initialValue: selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority Level'),
                items: const [
                  DropdownMenuItem(value: Priority.urgent, child: Text('🔴 Urgent')),
                  DropdownMenuItem(value: Priority.high, child: Text('🟠 High')),
                  DropdownMenuItem(value: Priority.medium, child: Text('🟡 Medium')),
                  DropdownMenuItem(value: Priority.low, child: Text('🟢 Low')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedPriority = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  ref.read(tasksProvider.notifier).addTask(controller.text.trim(), selectedPriority, selectedCategory);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
