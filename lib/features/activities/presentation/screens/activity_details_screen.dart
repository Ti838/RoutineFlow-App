import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/activity_provider.dart';
import 'create_edit_activity_sheet.dart';

class ActivityDetailsScreen extends ConsumerWidget {
  final String activityId;

  const ActivityDetailsScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesState = ref.watch(activityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              activitiesState.whenData((list) {
                final act = list.firstWhere(
                  (a) => a.id == activityId,
                  orElse: () => list.first,
                );
                CreateEditActivitySheet.show(context, activityToEdit: act);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Activity'),
                  content: const Text('Are you sure you want to delete this activity?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(activityNotifierProvider.notifier).deleteActivity(activityId);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      body: activitiesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (activities) {
          final activity = activities.firstWhere(
            (a) => a.id == activityId,
            orElse: () => throw Exception('Activity not found'),
          );

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
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
                        StatusBadge.category(
                          activity.category.label,
                          activity.isUniversity ? AppColors.university : AppColors.primary,
                          activity.isUniversity ? AppColors.universityContainer : AppColors.primaryContainer,
                        ),
                        if (activity.isCompleted)
                          StatusBadge.completed()
                        else if (activity.isInProgress)
                          StatusBadge.ongoing(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(activity.title, style: AppTypography.heading2),
                    if (activity.description != null && activity.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        activity.description!,
                        style: AppTypography.body.copyWith(color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Time & Info Grid
              _buildInfoTile(
                context,
                icon: Icons.access_time_filled,
                iconColor: AppColors.primary,
                title: 'Scheduled Time',
                subtitle: '${activity.startTime} – ${activity.endTime} (${activity.durationMinutes} min)',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildInfoTile(
                context,
                icon: Icons.calendar_today,
                iconColor: AppColors.personal,
                title: 'Date & Recurrence',
                subtitle: '${DateTimeUtils.formatDate(activity.date)} • ${activity.recurrence.label}',
              ),
              if (activity.location != null && activity.location!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _buildInfoTile(
                  context,
                  icon: Icons.location_on,
                  iconColor: AppColors.study,
                  title: 'Location / Venue',
                  subtitle: activity.location!,
                ),
              ],
              if (activity.isUniversity && activity.facultyName != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildInfoTile(
                  context,
                  icon: Icons.person_pin,
                  iconColor: AppColors.university,
                  title: 'Faculty / Supervisor',
                  subtitle: '${activity.facultyName!} • ${activity.courseCode ?? ""}',
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Action Buttons
              if (!activity.isCompleted) ...[
                PrimaryButton(
                  text: 'Mark as Completed',
                  icon: Icons.check_circle_outline,
                  color: AppColors.study,
                  onPressed: () async {
                    await ref.read(activityNotifierProvider.notifier).markCompleted(activity.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Activity marked as completed!')),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  text: 'Skip this Activity',
                  icon: Icons.skip_next_outlined,
                  isOutlined: true,
                  onPressed: () async {
                    await ref.read(activityNotifierProvider.notifier).markSkipped(activity.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Activity marked as skipped.')),
                      );
                    }
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.studyContainer.withAlpha(120),
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: AppColors.study),
                      const SizedBox(width: 8),
                      Text('Activity Completed', style: AppTypography.bodyMedium.copyWith(color: AppColors.study, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
