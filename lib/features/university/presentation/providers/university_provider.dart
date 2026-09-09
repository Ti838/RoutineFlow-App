import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/university_repository_impl.dart';
import '../../domain/models/university_models.dart';

final universityCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repo = ref.watch(universityRepositoryProvider);
  return repo.getEnrolledCourses(userId: 'current_user');
});

final universityExamsProvider = FutureProvider<List<Exam>>((ref) async {
  final repo = ref.watch(universityRepositoryProvider);
  return repo.getUpcomingExams(universityId: 'current_university');
});

class UniversityNotice {
  final String id;
  final String title;
  final String department;
  final String date;
  final bool isUrgent;

  const UniversityNotice({
    required this.id,
    required this.title,
    required this.department,
    required this.date,
    this.isUrgent = false,
  });
}

final universityNoticesProvider = StateProvider<List<UniversityNotice>>((ref) {
  return [
    const UniversityNotice(
      id: 'notice-1',
      title: 'Midterm Examination Schedule Fall 2026 Officially Published',
      department: 'Office of the Controller of Examinations',
      date: 'Today, 10:30 AM',
      isUrgent: true,
    ),
    const UniversityNotice(
      id: 'notice-2',
      title: 'Lab 402 Maintenance: Algorithms Practical Session Relocation',
      department: 'Dept of Computer Science & Engineering',
      date: 'Yesterday',
      isUrgent: false,
    ),
    const UniversityNotice(
      id: 'notice-3',
      title: 'Central Library 24/7 Extended Reading Room Access for Midterms',
      department: 'University Library Committee',
      date: '3 days ago',
      isUrgent: false,
    ),
  ];
});
