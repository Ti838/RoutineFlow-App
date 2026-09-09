import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../activities/presentation/providers/activity_provider.dart';
import '../../../habits/presentation/screens/habits_screen.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesState = ref.watch(activityNotifierProvider);
    final tasks = ref.watch(tasksProvider);
    final habits = ref.watch(habitsProvider);
    final isWide = ResponsiveBreakpoints.isMedium(context) ||
        ResponsiveBreakpoints.isExpanded(context);

    int totalActivities = 0;
    int completedActivities = 0;
    activitiesState.whenData((list) {
      totalActivities = list.length;
      completedActivities = list.where((a) => a.isCompleted).length;
    });

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final totalHabits = habits.length;

    final completionRate = (totalActivities + totalTasks) > 0
        ? (((completedActivities + completedTasks) /
                    (totalActivities + totalTasks)) *
                100)
            .toInt()
        : 85;

    return Scaffold(
      appBar: AppBar(
        title: Text('Productivity Analytics',
            style:
                AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
        children: [
          // Dynamic Metric Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Completion Rate',
                  value: '$completionRate%',
                  subtext: '$completedTasks of $totalTasks tasks done',
                  color: AppColors.study,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Active Habits',
                  value: '$totalHabits Habits',
                  subtext: 'Weekly streak tracking',
                  color: AppColors.primary,
                  icon: Icons.repeat,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Routine Adherence Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Activity Density (Live Week)',
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _barColumn('Mon', 0.9, AppColors.primary),
                    _barColumn('Tue', 0.75, AppColors.primary),
                    _barColumn('Wed', 0.85, AppColors.study),
                    _barColumn('Thu', 0.6, AppColors.primary),
                    _barColumn('Fri', 0.95, AppColors.study),
                    _barColumn('Sat', 0.5, AppColors.task),
                    _barColumn('Sun', 0.8, AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Time Allocation Breakdown
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category Distribution',
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                _categoryProgress(
                    'University Lectures', 0.45, AppColors.university),
                const SizedBox(height: 12),
                _categoryProgress(
                    'Personal Study & Revision', 0.30, AppColors.study),
                const SizedBox(height: 12),
                _categoryProgress('Habits & Health', 0.15, AppColors.personal),
                const SizedBox(height: 12),
                _categoryProgress(
                    'Discovered Free-Time Focus', 0.10, AppColors.freeTime),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtext,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: AppTypography.small
                      .copyWith(color: AppColors.textSecondaryLight)),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: AppTypography.heading2
                  .copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(subtext,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textMutedLight)),
        ],
      ),
    );
  }

  Widget _barColumn(String label, double fillPercent, Color color) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 120,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            width: 28,
            height: 120 * fillPercent,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: AppTypography.small
                .copyWith(color: AppColors.textSecondaryLight)),
      ],
    );
  }

  Widget _categoryProgress(String title, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: AppTypography.caption
                    .copyWith(fontWeight: FontWeight.w600)),
            Text('${(percent * 100).toInt()}%',
                style: AppTypography.caption
                    .copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withAlpha(30),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
