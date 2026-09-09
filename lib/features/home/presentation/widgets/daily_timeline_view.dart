import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../activities/domain/models/activity.dart';

class DailyTimelineView extends StatelessWidget {
  final List<Activity> activities;

  const DailyTimelineView({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            const Icon(Icons.event_available_outlined,
                size: 40, color: AppColors.textMutedLight),
            const SizedBox(height: 12),
            Text(
              'No activities scheduled for this day',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final act = activities[index];
          final isUni = act.isUniversity;

          Color indicatorColor = AppColors.primary;
          Color bgBadgeColor = AppColors.primaryContainer;
          String catLabel = act.category.label;

          if (isUni) {
            indicatorColor = AppColors.university;
            bgBadgeColor = AppColors.universityContainer;
          } else if (act.category.name == 'study') {
            indicatorColor = AppColors.study;
            bgBadgeColor = AppColors.studyContainer;
          } else if (act.category.name == 'health') {
            indicatorColor = AppColors.personal;
            bgBadgeColor = AppColors.personalContainer;
          }

          return InkWell(
            onTap: () => context.push('/activity/${act.id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Dot Indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Time Range
                  SizedBox(
                    width: 95,
                    child: Text(
                      '${act.startTime} – ${act.endTime}',
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      act.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration:
                            act.isCompleted ? TextDecoration.lineThrough : null,
                        color:
                            act.isCompleted ? AppColors.textMutedLight : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category Tag
                  StatusBadge.category(catLabel, indicatorColor, bgBadgeColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
