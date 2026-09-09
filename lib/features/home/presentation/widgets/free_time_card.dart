import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/services/free_time_service.dart';

class FreeTimeCard extends StatelessWidget {
  final List<FreeTimeSlot> freeSlots;

  const FreeTimeCard({super.key, required this.freeSlots});

  @override
  Widget build(BuildContext context) {
    if (freeSlots.isEmpty) return const SizedBox.shrink();

    final firstSlot = freeSlots.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.freeTimeContainer.withAlpha(120),
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.freeTime.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.freeTime,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.coffee_outlined, color: Colors.white, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free Time Slot',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.freeTime,
                  ),
                ),
                Text(
                  '${firstSlot.formattedRange} (${firstSlot.durationMinutes} min available)',
                  style: AppTypography.small.copyWith(color: AppColors.textPrimaryLight),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: const Text('Use Slot', style: TextStyle(color: AppColors.freeTime, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
