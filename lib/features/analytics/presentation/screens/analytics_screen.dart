import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productivity Analytics', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Weekly Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Completion Rate',
                  value: '84%',
                  subtext: '+6% from last week',
                  color: AppColors.study,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Study Hours',
                  value: '28.5 hrs',
                  subtext: '4.1 hrs / day avg',
                  color: AppColors.primary,
                  icon: Icons.timer_outlined,
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
                Text('Daily Adherence (This Week)', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
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

          // Category Distribution
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
                Text('Time Distribution by Category', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                _distributionRow('Study & Academic', 0.45, AppColors.study, '18h 30m'),
                const SizedBox(height: 10),
                _distributionRow('University Classes', 0.30, AppColors.university, '12h 00m'),
                const SizedBox(height: 10),
                _distributionRow('Health & Fitness', 0.15, AppColors.personal, '6h 15m'),
                const SizedBox(height: 10),
                _distributionRow('Free Time & Rest', 0.10, AppColors.freeTime, '4h 00m'),
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
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.heading2.copyWith(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(title, style: AppTypography.small.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtext, style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }

  Widget _barColumn(String day, double heightFraction, Color color) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 100 * heightFraction,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
      ],
    );
  }

  Widget _distributionRow(String label, double fraction, Color color, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.small.copyWith(fontWeight: FontWeight.w600)),
            Text(time, style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: fraction,
          backgroundColor: AppColors.borderLight,
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
