import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../domain/models/university_models.dart';
import '../providers/university_provider.dart';

enum UniversityTab { classes, exams, deadlines, notices }

final universityTabProvider =
    StateProvider<UniversityTab>((ref) => UniversityTab.classes);

class UniversityScreen extends ConsumerWidget {
  const UniversityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(universityTabProvider);
    final isWide = ResponsiveBreakpoints.isMedium(context) ||
        ResponsiveBreakpoints.isExpanded(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('University Routine & Hub',
            style:
                AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Responsive Tab Filter Bar
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
                  _tabChip(
                      ref, 'Deadlines', UniversityTab.deadlines, currentTab),
                  const SizedBox(width: 8),
                  _tabChip(ref, 'Official Notices', UniversityTab.notices,
                      currentTab),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildTabContent(context, ref, currentTab, isWide),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(WidgetRef ref, String label, UniversityTab tab,
      UniversityTab currentTab) {
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

  Widget _buildTabContent(
      BuildContext context, WidgetRef ref, UniversityTab tab, bool isWide) {
    switch (tab) {
      case UniversityTab.classes:
        final coursesAsync = ref.watch(universityCoursesProvider);
        return coursesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading courses: $e')),
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(
                  child: Text('No university courses enrolled yet.'));
            }
            if (isWide) {
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: courses.length,
                itemBuilder: (context, idx) =>
                    _buildCourseCard(context, courses[idx]),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: courses.length,
              itemBuilder: (context, idx) =>
                  _buildCourseCard(context, courses[idx]),
            );
          },
        );

      case UniversityTab.exams:
        final examsAsync = ref.watch(universityExamsProvider);
        return examsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading exams: $e')),
          data: (exams) {
            if (exams.isEmpty) {
              return const Center(child: Text('No upcoming exams scheduled.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: exams.length,
              itemBuilder: (context, idx) =>
                  _buildExamCard(context, exams[idx]),
            );
          },
        );

      case UniversityTab.deadlines:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _deadlineCard('Algorithms Lab Assignment 4', 'CSE 301', 'In 3 days',
                AppColors.error),
            const SizedBox(height: 12),
            _deadlineCard('Database Systems Term Project Phase 1', 'CSE 320',
                'In 6 days', AppColors.warning),
            const SizedBox(height: 12),
            _deadlineCard('Linear Algebra Problem Set 5', 'MAT 205',
                'Next week', AppColors.primary),
          ],
        );

      case UniversityTab.notices:
        final notices = ref.watch(universityNoticesProvider);
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: notices.length,
          itemBuilder: (context, idx) =>
              _buildNoticeCard(context, notices[idx]),
        );
    }
  }

  Widget _buildCourseCard(BuildContext context, Course c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.university.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.universityContainer,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Text(
                  c.code,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.university,
                  ),
                ),
              ),
              Text(
                '${c.creditHours} Credits',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondaryLight),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(c.title,
              style: AppTypography.bodyMedium
                  .copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(c.instructor,
                      style: AppTypography.small
                          .copyWith(color: AppColors.textSecondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.meeting_room_outlined,
                  size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(c.room,
                      style: AppTypography.small
                          .copyWith(color: AppColors.textSecondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, Exam e) {
    final daysLeft = e.examDate.difference(DateTime.now()).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.error.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: AppRadius.radiusMd,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysLeft',
                  style: AppTypography.heading3.copyWith(
                      color: AppColors.error, fontWeight: FontWeight.bold),
                ),
                Text('days',
                    style: AppTypography.small
                        .copyWith(color: AppColors.error, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.courseCode,
                    style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.error)),
                Text(e.courseTitle,
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('Room: ${e.room} • Weight: ${e.weightage.toInt()}%',
                    style: AppTypography.small
                        .copyWith(color: AppColors.textSecondaryLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deadlineCard(
      String title, String course, String timeLeft, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_outlined, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text(course,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondaryDark)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Text(timeLeft,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, UniversityNotice n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
            color: n.isUrgent
                ? AppColors.error.withAlpha(80)
                : Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (n.isUrgent)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('URGENT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ),
              Expanded(
                child: Text(
                  n.department,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondaryLight),
                ),
              ),
              Text(n.date,
                  style: AppTypography.small
                      .copyWith(color: AppColors.textMutedLight)),
            ],
          ),
          const SizedBox(height: 6),
          Text(n.title,
              style: AppTypography.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
