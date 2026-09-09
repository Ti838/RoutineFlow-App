import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

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
            title: 'Exercise',
            completedDays: 5,
            targetDays: 7,
            isCompletedToday: true,
            color: AppColors.primary,
          ),
          HabitItem(
            id: 'h_2',
            title: 'Read Book',
            completedDays: 3,
            targetDays: 7,
            isCompletedToday: false,
            color: AppColors.study,
          ),
          HabitItem(
            id: 'h_3',
            title: 'Meditate',
            completedDays: 4,
            targetDays: 7,
            isCompletedToday: true,
            color: AppColors.personal,
          ),
          HabitItem(
            id: 'h_4',
            title: 'Drink 3L Water',
            completedDays: 6,
            targetDays: 7,
            isCompletedToday: false,
            color: AppColors.freeTime,
          ),
          HabitItem(
            id: 'h_5',
            title: 'No Social Media',
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
          completedDays:
              nowCompleted ? h.completedDays + 1 : h.completedDays - 1,
        );
      }
      return h;
    }).toList();
  }
}

final habitsProvider =
    StateNotifierProvider<HabitsNotifier, List<HabitItem>>((ref) {
  return HabitsNotifier();
});

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habits',
            style:
                AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Weekly View Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                  label: const Text('Today'),
                  selected: true,
                  selectedColor: AppColors.primaryContainer,
                  onSelected: (_) {}),
              const SizedBox(width: 8),
              ChoiceChip(
                  label: const Text('Week'),
                  selected: false,
                  onSelected: (_) {}),
              const SizedBox(width: 8),
              ChoiceChip(
                  label: const Text('Month'),
                  selected: false,
                  onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Habits List
          ...habits.map((habit) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                        ref.read(habitsProvider.notifier).toggleHabit(habit.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: habit.isCompletedToday
                            ? habit.color
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: habit.color, width: 2),
                      ),
                      child: habit.isCompletedToday
                          ? const Icon(Icons.check,
                              size: 20, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title,
                            style: AppTypography.bodyMedium
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          '${habit.completedDays}/${habit.targetDays} days completed this week',
                          style: AppTypography.small
                              .copyWith(color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: habit.color.withAlpha(25),
                      borderRadius: AppRadius.radiusPill,
                    ),
                    child: Text(
                      '${habit.completedDays}/${habit.targetDays} days',
                      style: AppTypography.badge.copyWith(color: habit.color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
