import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/conflict_detection_service.dart';
import '../../../../core/services/free_time_service.dart';
import '../../../activities/domain/models/activity.dart';
import '../../../activities/presentation/providers/activity_provider.dart';

enum MyDayFilter { all, personal, university }

class MyDayState {
  final DateTime selectedDate;
  final MyDayFilter filter;
  final Activity? currentActivity;
  final Activity? nextUpActivity;
  final List<Activity> timelineActivities;
  final List<FreeTimeSlot> freeTimeSlots;
  final List<ScheduleConflict> conflicts;
  final int completedCount;
  final int totalCount;

  MyDayState({
    required this.selectedDate,
    this.filter = MyDayFilter.all,
    this.currentActivity,
    this.nextUpActivity,
    required this.timelineActivities,
    required this.freeTimeSlots,
    required this.conflicts,
    required this.completedCount,
    required this.totalCount,
  });

  double get completionProgress => totalCount > 0 ? (completedCount / totalCount) : 0.0;
}

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final myDayFilterProvider = StateProvider<MyDayFilter>((ref) => MyDayFilter.all);

final myDayStateProvider = Provider<AsyncValue<MyDayState>>((ref) {
  final activitiesAsync = ref.watch(activityNotifierProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final filter = ref.watch(myDayFilterProvider);

  return activitiesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (allActivities) {
      final dateActivities = allActivities.where((a) =>
        a.date.year == selectedDate.year &&
        a.date.month == selectedDate.month &&
        a.date.day == selectedDate.day
      ).toList();

      dateActivities.sort((a, b) => a.startTime.compareTo(b.startTime));

      final freeSlots = FreeTimeService.calculateFreeTimeSlots(
        date: selectedDate,
        activities: dateActivities,
      );

      final conflicts = ConflictDetectionService.detectConflicts(dateActivities);

      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;
      final isToday = selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day;

      Activity? current;
      Activity? nextUp;

      if (isToday) {
        for (final act in dateActivities) {
          final sParts = act.startTime.split(':');
          final sMin = (int.tryParse(sParts[0]) ?? 0) * 60 + (int.tryParse(sParts.length > 1 ? sParts[1] : '0') ?? 0);
          final eParts = act.endTime.split(':');
          final eMin = (int.tryParse(eParts[0]) ?? 0) * 60 + (int.tryParse(eParts.length > 1 ? eParts[1] : '0') ?? 0);

          if (currentMinutes >= sMin && currentMinutes < eMin && !act.isCompleted && !act.isSkipped) {
            current = act;
          } else if (currentMinutes < sMin && nextUp == null && !act.isCompleted && !act.isSkipped) {
            nextUp = act;
          }
        }
      }

      if (current == null && dateActivities.isNotEmpty) {
        current = dateActivities.firstWhere(
          (a) => a.isInProgress || (!a.isCompleted && !a.isSkipped),
          orElse: () => dateActivities.first,
        );
      }

      if (nextUp == null && dateActivities.length > 1) {
        nextUp = dateActivities.firstWhere(
          (a) => a.id != current?.id && !a.isCompleted && !a.isSkipped,
          orElse: () => dateActivities[1],
        );
      }

      List<Activity> filteredList = dateActivities;
      if (filter == MyDayFilter.personal) {
        filteredList = dateActivities.where((a) => !a.isUniversity).toList();
      } else if (filter == MyDayFilter.university) {
        filteredList = dateActivities.where((a) => a.isUniversity).toList();
      }

      final completed = dateActivities.where((a) => a.isCompleted).length;

      return AsyncValue.data(
        MyDayState(
          selectedDate: selectedDate,
          filter: filter,
          currentActivity: current,
          nextUpActivity: nextUp,
          timelineActivities: filteredList,
          freeTimeSlots: freeSlots,
          conflicts: conflicts,
          completedCount: completed,
          totalCount: dateActivities.length,
        ),
      );
    },
  );
});
