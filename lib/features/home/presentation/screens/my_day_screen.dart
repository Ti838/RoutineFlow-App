import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../activities/presentation/screens/create_edit_activity_sheet.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/models/auth_state.dart';
import '../providers/my_day_provider.dart';
import '../widgets/current_activity_card.dart';
import '../widgets/next_up_card.dart';
import '../widgets/free_time_card.dart';
import '../widgets/conflict_card.dart';
import '../widgets/daily_timeline_view.dart';
import '../widgets/daily_progress_widget.dart';

class MyDayScreen extends ConsumerWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myDayAsync = ref.watch(myDayStateProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final currentFilter = ref.watch(myDayFilterProvider);
    final authState = ref.watch(authNotifierProvider);

    final userName = authState is Authenticated ? authState.user.name : 'Timon';
    final isDesktop = ResponsiveBreakpoints.isExpanded(context);
    final isTablet = ResponsiveBreakpoints.isMedium(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Row(
                children: [
                  const AppLogo(size: 32),
                  const SizedBox(width: 10),
                  Text('Routine Flow', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No unread schedule notifications.'),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.auto_awesome_outlined, color: AppColors.primary),
                  onPressed: () => context.push('/ai-planner'),
                ),
              ],
            ),
      body: myDayAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading schedule: $err')),
        data: (myDay) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : AppSpacing.lg,
              vertical: isDesktop ? 24 : AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Desktop Header Search & Profile Bar
                if (isDesktop) _buildDesktopTopBar(context, userName),

                // Greeting & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning, $userName 👋', style: AppTypography.heading2),
                        const SizedBox(height: 2),
                        Text(
                          "Here's your day at a glance",
                          style: AppTypography.body.copyWith(color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                    if (isDesktop)
                      ElevatedButton.icon(
                        onPressed: () => CreateEditActivitySheet.show(context, defaultDate: selectedDate),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Activity'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Horizontal Date Carousel
                _buildDateSelector(ref, selectedDate),
                const SizedBox(height: AppSpacing.lg),

                // Filter Chips (ALL, PERSONAL, UNIVERSITY)
                _buildFilterChips(ref, currentFilter),
                const SizedBox(height: AppSpacing.lg),

                // Adaptive Content Layout
                if (isDesktop || isTablet)
                  _buildDesktopTabletLayout(context, myDay)
                else
                  _buildMobileLayout(context, myDay),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopTopBar(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20, color: AppColors.textSecondaryLight),
                  SizedBox(width: 8),
                  Text('Search anything...', style: TextStyle(color: AppColors.textMutedLight)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No unread schedule notifications.'),
                      duration: Duration(seconds: 2),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryContainer,
            child: Text(userName.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(WidgetRef ref, DateTime selectedDate) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => ref.read(selectedDateProvider.notifier).state = date,
            child: Container(
              width: 58,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateTimeUtils.formatDayOfWeek(date),
                    style: AppTypography.small.copyWith(
                      color: isSelected ? Colors.white70 : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref, MyDayFilter currentFilter) {
    return Row(
      children: [
        _filterChip(ref, 'All', MyDayFilter.all, currentFilter),
        const SizedBox(width: 8),
        _filterChip(ref, 'Personal', MyDayFilter.personal, currentFilter),
        const SizedBox(width: 8),
        _filterChip(ref, 'University', MyDayFilter.university, currentFilter),
      ],
    );
  }

  Widget _filterChip(WidgetRef ref, String label, MyDayFilter filter, MyDayFilter current) {
    final selected = filter == current;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primaryContainer,
      onSelected: (_) => ref.read(myDayFilterProvider.notifier).state = filter,
    );
  }

  Widget _buildMobileLayout(BuildContext context, MyDayState myDay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current Activity Card
        Text('CURRENT', style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CurrentActivityCard(activity: myDay.currentActivity),
        const SizedBox(height: AppSpacing.lg),

        // Next Up Card
        Text('NEXT UP', style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        NextUpCard(activity: myDay.nextUpActivity),
        const SizedBox(height: AppSpacing.lg),

        // Free Time Slot
        if (myDay.freeTimeSlots.isNotEmpty) ...[
          FreeTimeCard(freeSlots: myDay.freeTimeSlots),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Conflicts
        if (myDay.conflicts.isNotEmpty) ...[
          ConflictCard(conflicts: myDay.conflicts),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Timeline
        Text("TODAY'S TIMELINE", style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DailyTimelineView(activities: myDay.timelineActivities),
        const SizedBox(height: AppSpacing.lg),

        // Today's Progress
        DailyProgressWidget(
          completed: myDay.completedCount,
          total: myDay.totalCount,
          progress: myDay.completionProgress,
        ),
        const SizedBox(height: 80), // FAB spacing
      ],
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context, MyDayState myDay) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Timeline & Progress
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TODAY'S TIMELINE", style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DailyTimelineView(activities: myDay.timelineActivities),
              const SizedBox(height: AppSpacing.lg),
              DailyProgressWidget(
                completed: myDay.completedCount,
                total: myDay.totalCount,
                progress: myDay.completionProgress,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        // Right Column: Current, Next Up, Free Time, Conflicts
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CURRENT ACTIVITY', style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CurrentActivityCard(activity: myDay.currentActivity),
              const SizedBox(height: AppSpacing.lg),

              Text('NEXT UP', style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              NextUpCard(activity: myDay.nextUpActivity),
              const SizedBox(height: AppSpacing.lg),

              if (myDay.freeTimeSlots.isNotEmpty) ...[
                FreeTimeCard(freeSlots: myDay.freeTimeSlots),
                const SizedBox(height: AppSpacing.lg),
              ],

              if (myDay.conflicts.isNotEmpty) ...[
                ConflictCard(conflicts: myDay.conflicts),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
