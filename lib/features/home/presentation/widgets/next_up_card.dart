import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../activities/domain/models/activity.dart';

class NextUpCard extends StatelessWidget {
  final Activity? activity;

  const NextUpCard({super.key, this.activity});

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Text(
          'No more scheduled activities for today.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
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
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isUni ? AppColors.university : AppColors.primary).withAlpha(20),
                borderRadius: AppRadius.radiusMd,
              ),
              child: Icon(
                isUni ? Icons.school_outlined : Icons.event_note,
                color: isUni ? AppColors.university : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    act.title,
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${act.startTime} – ${act.endTime}${act.room != null ? " • ${act.room}" : ""}',
                    style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMutedLight),
          ],
        ),
      ),
    );
  }
}
