import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../shared/widgets/primary_button.dart';

class UniversityAdminScreen extends ConsumerStatefulWidget {
  const UniversityAdminScreen({super.key});

  @override
  ConsumerState<UniversityAdminScreen> createState() => _UniversityAdminScreenState();
}

class _UniversityAdminScreenState extends ConsumerState<UniversityAdminScreen> {
  final List<Map<String, String>> _announcements = [
    {
      'title': 'Midterm Exam Schedule Fall 2026 Published',
      'department': 'Academic Registrar',
      'date': 'Today',
      'status': 'Published'
    },
    {
      'title': 'Campus Library Extended Hours (24/7 during Finals)',
      'department': 'Central Library',
      'date': 'Yesterday',
      'status': 'Active'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('University Timetable Admin'),
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildQuickStatCards(),
          const SizedBox(height: AppSpacing.lg),
          _buildTimetableManagementSection(),
          const SizedBox(height: AppSpacing.lg),
          _buildAnnouncementsSection(),
        ],
      ),
    );
  }

  Widget _buildQuickStatCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Enrolled Students', '4,850', Icons.people_outline, AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard('Active Courses', '142', Icons.menu_book_outlined, AppColors.success),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }

  Widget _buildTimetableManagementSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Class Timetable Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: AppSpacing.xs),
          const Text('Instantly broadcast schedule adjustments, room swaps, or cancellations to enrolled students.', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Publish Schedule Update',
                  icon: Icons.send_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Timetable update broadcasted to 4,850 enrolled students.')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Official Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
        const SizedBox(height: AppSpacing.sm),
        ..._announcements.map((a) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign_outlined, color: AppColors.primaryLight, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['title']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
                        Text('${a["department"]} • ${a["date"]}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
