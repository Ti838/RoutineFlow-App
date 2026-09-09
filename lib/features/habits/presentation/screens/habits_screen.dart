import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../shared/widgets/empty_state_view.dart';

class HabitItem {
  final String id;
  final String title;
  final int completedDays;
  final int targetDays;
  final bool isCompletedToday;
  final Color color;

  HabitItem({
    required this.id,
    required this.title,
    required this.completedDays,
    this.targetDays = 7,
    this.isCompletedToday = false,
    required this.color,
  });

  HabitItem copyWith({
    String? id,
    String? title,
    int? completedDays,
    int? targetDays,
    bool? isCompletedToday,
    Color? color,
  }) {
    return HabitItem(
      id: id ?? this.id,
      title: title ?? this.title,
      completedDays: completedDays ?? this.completedDays,
      targetDays: targetDays ?? this.targetDays,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      color: color ?? this.color,
    );
  }
}

class HabitsNotifier extends StateNotifier<List<HabitItem>> {
  HabitsNotifier()
      : super([
          HabitItem(
            id: 'h_1',
            title: 'Morning Workout & Cardio',
            completedDays: 5,
            targetDays: 7,
            isCompletedToday: true,
            color: AppColors.primary,
          ),
          HabitItem(
            id: 'h_2',
            title: 'Read Academic Book / Paper',
            completedDays: 3,
            targetDays: 7,
            isCompletedToday: false,
            color: AppColors.study,
          ),
          HabitItem(
            id: 'h_3',
            title: 'Mindfulness & Meditation',
            completedDays: 4,
            targetDays: 7,
            isCompletedToday: true,
            color: AppColors.personal,
          ),
          HabitItem(
            id: 'h_4',
            title: 'Drink 3L Water Daily',
            completedDays: 6,
            targetDays: 7,
            isCompletedToday: false,
            color: AppColors.freeTime,
          ),
          HabitItem(
            id: 'h_5',
            title: 'Competitive Programming Practice',
            completedDays: 4,
            targetDays: 7,
            isCompletedToday: false,
            color: AppColors.exam,
          ),
        ]);

  void toggleHabit(String id) {
    state = state.map((h) {
      if (h.id == id) {
        final nowCompleted = !h.isCompletedToday;
        return h.copyWith(
          isCompletedToday: nowCompleted,
          completedDays: (nowCompleted ? h.completedDays + 1 : h.completedDays - 1).clamp(0, h.targetDays),
        );
      }
      return h;
    }).toList();
  }

  void addHabit(String title, Color color, int targetDays) {
    final newHabit = HabitItem(
      id: const Uuid().v4(),
      title: title,
      completedDays: 0,
      targetDays: targetDays,
      isCompletedToday: false,
      color: color,
    );
    state = [...state, newHabit];
  }

  void deleteHabit(String id) {
    state = state.where((h) => h.id != id).toList();
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<HabitItem>>((ref) {
  return HabitsNotifier();
});

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    final isWide = ResponsiveBreakpoints.isMedium(context) || ResponsiveBreakpoints.isExpanded(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habits & Streaks', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: habits.isEmpty
          ? EmptyStateView(
              icon: Icons.repeat,
              title: 'No Active Habits',
              description: 'Start tracking daily habits like workout, reading, or meditation to build consistent streaks.',
              actionText: 'Add First Habit',
              onAction: () => _showAddHabitDialog(context, ref),
            )
          : ListView(
              padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
              children: [
                // Header Consistency Banner
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.surfaceDark, Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.radiusLg,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withAlpha(120),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_fire_department, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weekly Routine Consistency', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(
                              '${habits.where((h) => h.isCompletedToday).length} of ${habits.length} habits logged for today',
                              style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Habit Cards Grid / List
                if (isWide)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 88,
                    ),
                    itemCount: habits.length,
                    itemBuilder: (context, index) => _buildHabitCard(context, ref, habits[index]),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: habits.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _buildHabitCard(context, ref, habits[index]),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, WidgetRef ref, HabitItem habit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => ref.read(habitsProvider.notifier).toggleHabit(habit.id),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: habit.isCompletedToday ? habit.color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: habit.color, width: 2),
              ),
              child: habit.isCompletedToday
                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  habit.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: habit.isCompletedToday ? TextDecoration.none : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${habit.completedDays}/${habit.targetDays} days completed this week',
                  style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMutedLight),
            onPressed: () => ref.read(habitsProvider.notifier).deleteHabit(habit.id),
          ),
        ],
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    Color selectedColor = AppColors.primary;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Habit Title',
                  hintText: 'e.g., Morning Workout, Read 10 Pages',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Pick Color Tag', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _colorOption(AppColors.primary, selectedColor, () => setDialogState(() => selectedColor = AppColors.primary)),
                  _colorOption(AppColors.study, selectedColor, () => setDialogState(() => selectedColor = AppColors.study)),
                  _colorOption(AppColors.personal, selectedColor, () => setDialogState(() => selectedColor = AppColors.personal)),
                  _colorOption(AppColors.freeTime, selectedColor, () => setDialogState(() => selectedColor = AppColors.freeTime)),
                  _colorOption(AppColors.exam, selectedColor, () => setDialogState(() => selectedColor = AppColors.exam)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  ref.read(habitsProvider.notifier).addHabit(controller.text.trim(), selectedColor, 7);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color, Color current, VoidCallback onTap) {
    final isSelected = color.toARGB32() == current.toARGB32();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}
