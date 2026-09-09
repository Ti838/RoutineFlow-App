import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

class DailyProgressWidget extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const DailyProgressWidget({
    Key? key,
    required this.completed,
    required this.total,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 5,
                  backgroundColor: Theme.of(context).dividerColor,
                  color: AppColors.primary,
                ),
                Center(
                  child: Text(
                    '$percentage%',
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Progress",
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '$completed of $total activities completed',
                  style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
