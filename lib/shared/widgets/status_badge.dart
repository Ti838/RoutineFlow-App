import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.ongoing() => const StatusBadge(
        label: 'Ongoing',
        backgroundColor: AppColors.studyContainer,
        textColor: AppColors.study,
        icon: Icons.play_arrow_rounded,
      );

  factory StatusBadge.completed() => const StatusBadge(
        label: 'Completed',
        backgroundColor: AppColors.primaryContainer,
        textColor: AppColors.primary,
        icon: Icons.check_circle_outline,
      );

  factory StatusBadge.conflict() => const StatusBadge(
        label: 'Conflict',
        backgroundColor: AppColors.conflictContainer,
        textColor: AppColors.conflict,
        icon: Icons.warning_amber_rounded,
      );

  factory StatusBadge.category(String label, Color color, Color bg) => StatusBadge(
        label: label,
        backgroundColor: bg,
        textColor: color,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.badge.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
