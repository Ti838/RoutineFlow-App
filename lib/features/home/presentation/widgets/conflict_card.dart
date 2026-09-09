import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/services/conflict_detection_service.dart';

class ConflictCard extends StatelessWidget {
  final List<ScheduleConflict> conflicts;

  const ConflictCard({Key? key, required this.conflicts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conflicts.isEmpty) return const SizedBox.shrink();

    final conflict = conflicts.first;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.conflictContainer.withAlpha(150),
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.conflict.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.conflict,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${conflicts.length} Schedule Conflict Detected',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.conflict,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            conflict.message,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Suggestion: ${conflict.suggestedResolution}',
            style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
