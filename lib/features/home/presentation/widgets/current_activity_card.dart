import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../activities/domain/models/activity.dart';

class CurrentActivityCard extends StatelessWidget {
  final Activity? activity;

  const CurrentActivityCard({super.key, this.activity});

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.study, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'No active ongoing activity right now.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      );
    }

    final act = activity!;
    final isUni = act.isUniversity;

    return InkWell(
      onTap: () => context.push('/activity/${act.id}'),
      borderRadius: AppRadius.radiusLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: isUni ? AppColors.university.withAlpha(60) : AppColors.study.withAlpha(60), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: (isUni ? AppColors.university : AppColors.study).withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isUni ? AppColors.university : AppColors.study).withAlpha(25),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Icon(
                        isUni ? Icons.school : Icons.book_outlined,
                        size: 20,
                        color: isUni ? AppColors.university : AppColors.study,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.title,
                          style: AppTypography.heading3.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${act.startTime} – ${act.endTime}',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge.ongoing(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.play_circle_fill, color: AppColors.study, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '1h 24m left',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.study,
                      ),
                    ),
                  ],
                ),
                if (act.location != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        act.location!,
                        style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
