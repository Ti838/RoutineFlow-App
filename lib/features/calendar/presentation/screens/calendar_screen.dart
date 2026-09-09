import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../activities/domain/models/activity.dart';
import '../../../activities/presentation/providers/activity_provider.dart';
import '../../../activities/presentation/screens/create_edit_activity_sheet.dart';

enum CalendarViewType { day, week, month }

final calendarViewTypeProvider =
    StateProvider<CalendarViewType>((ref) => CalendarViewType.day);
final calendarSelectedDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(calendarViewTypeProvider);
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final activitiesAsync = ref.watch(activityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar ${selectedDate.year}',
          style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(calendarSelectedDateProvider.notifier).state =
                  selectedDate.subtract(const Duration(days: 7));
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(calendarSelectedDateProvider.notifier).state =
                  selectedDate.add(const Duration(days: 7));
            },
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              ref.read(calendarSelectedDateProvider.notifier).state =
                  DateTime.now();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // View Type Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<CalendarViewType>(
              segments: const [
                ButtonSegment(value: CalendarViewType.day, label: Text('Day')),
                ButtonSegment(
                    value: CalendarViewType.week, label: Text('Week')),
                ButtonSegment(
                    value: CalendarViewType.month, label: Text('Month')),
              ],
              selected: {viewType},
              onSelectionChanged: (set) {
                ref.read(calendarViewTypeProvider.notifier).state = set.first;
              },
            ),
          ),
          const Divider(height: 1),

          // Calendar Content
          Expanded(
            child: activitiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
              data: (activities) {
                return _buildCalendarView(
                    context, ref, viewType, selectedDate, activities);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            CreateEditActivitySheet.show(context, defaultDate: selectedDate),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    WidgetRef ref,
    CalendarViewType viewType,
    DateTime selectedDate,
    List<Activity> activities,
  ) {
    // Day Schedule
    final dayActivities = activities
        .where((a) =>
            a.date.year == selectedDate.year &&
            a.date.month == selectedDate.month &&
            a.date.day == selectedDate.day)
        .toList();
    dayActivities.sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Days Row
        _buildDaysHeader(ref, selectedDate),
        const SizedBox(height: AppSpacing.lg),

        // Timeline Schedule Grid
        if (dayActivities.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            child: Text(
              'No events scheduled for ${DateTimeUtils.formatShortDate(selectedDate)}',
              style: AppTypography.body
                  .copyWith(color: AppColors.textSecondaryLight),
            ),
          )
        else
          ...dayActivities.map((act) => _buildScheduleEventCard(context, act)),
      ],
    );
  }

  Widget _buildDaysHeader(WidgetRef ref, DateTime selectedDate) {
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        final isSelected = day.year == selectedDate.year &&
            day.month == selectedDate.month &&
            day.day == selectedDate.day;

        return GestureDetector(
          onTap: () =>
              ref.read(calendarSelectedDateProvider.notifier).state = day,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: AppRadius.radiusMd,
            ),
            child: Column(
              children: [
                Text(
                  DateTimeUtils.formatDayOfWeek(day),
                  style: AppTypography.small.copyWith(
                    color: isSelected
                        ? Colors.white70
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScheduleEventCard(BuildContext context, Activity activity) {
    final isUni = activity.isUniversity;
    final color = isUni
        ? AppColors.university
        : (activity.category.name == 'study'
            ? AppColors.study
            : AppColors.personal);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(activity.title,
            style:
                AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${activity.startTime} – ${activity.endTime} • ${activity.category.label}${activity.room != null ? " (${activity.room})" : ""}',
          style:
              AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
        ),
        trailing: StatusBadge.category(
            activity.category.label, color, color.withAlpha(30)),
        onTap: () => context.push('/activity/${activity.id}'),
      ),
    );
  }
}
