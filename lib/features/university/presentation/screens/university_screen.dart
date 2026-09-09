import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

enum UniversityTab { classes, exams, deadlines, notices }

final universityTabProvider = StateProvider<UniversityTab>((ref) => UniversityTab.classes);

class UniversityScreen extends ConsumerWidget {
  const UniversityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(universityTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('University', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Segmented Tab Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabChip(ref, 'Classes', UniversityTab.classes, currentTab),
                  const SizedBox(width: 8),
                  _tabChip(ref, 'Exams', UniversityTab.exams, currentTab),
                  const SizedBox(width: 8),
                  _tabChip(ref, 'Deadlines', UniversityTab.deadlines, currentTab),
                  const SizedBox(width: 8),
                  _tabChip(ref, 'Notices', UniversityTab.notices, currentTab),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildTabContent(currentTab),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(WidgetRef ref, String label, UniversityTab tab, UniversityTab currentTab) {
    final isSelected = tab == currentTab;
    return GestureDetector(
      onTap: () => ref.read(universityTabProvider.notifier).state = tab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondaryDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(UniversityTab tab) {
    switch (tab) {
      case UniversityTab.classes:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _classCard(
              code: 'CSE 301',
              name: 'Algorithms & Data Structures',
              faculty: 'Prof. Ada Lovelace',
              room: 'Lab 402',
              time: 'Mon, Wed 09:30 AM - 11:00 AM',
            ),
            const SizedBox(height: 12),
            _classCard(
              code: 'BBA 201',
              name: 'Principles of Management',
              faculty: 'Prof. Edgar Codd',
              room: 'Auditorium B',
              time: 'Mon, Wed 02:00 PM - 03:30 PM',
            ),
          ],
        );
      case UniversityTab.exams:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _examCard(
              code: 'CSE 301',
              title: 'Midterm Examination',
              date: 'Oct 15, 2026 • 10:00 AM',
              room: 'Auditorium Central',
              weight: '30%',
            ),
          ],
        );
      case UniversityTab.deadlines:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _deadlineCard(
              code: 'CSE 301',
              title: 'Graph Traversal Project Submission',
              dueDate: 'Due in 3 days (11:59 PM)',
            ),
          ],
        );
      case UniversityTab.notices:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _noticeCard(
              title: 'Fall 2026 Midterm Routine Published',
              date: '2 hours ago',
              dept: 'Academic Registrar',
            ),
          ],
        );
    }
  }

  Widget _classCard({
    required String code,
    required String name,
    required String faculty,
    required String room,
    required String time,
  }) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
              Text(room, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
            ],
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 4),
          Text(faculty, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(fontSize: 12, color: AppColors.study)),
        ],
      ),
    );
  }

  Widget _examCard({
    required String code,
    required String title,
    required String date,
    required String room,
    required String weight,
  }) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
              Text('Weight: \$weight', style: const TextStyle(fontSize: 12, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 6),
          Text(date, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
          Text(room, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }

  Widget _deadlineCard({
    required String code,
    required String title,
    required String dueDate,
  }) {
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
          Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 6),
          Text(dueDate, style: const TextStyle(fontSize: 12, color: AppColors.error)),
        ],
      ),
    );
  }

  Widget _noticeCard({
    required String title,
    required String date,
    required String dept,
  }) {
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
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 4),
          Text('\$dept • \$date', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}
