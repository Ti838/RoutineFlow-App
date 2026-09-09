import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/university_models.dart';
import '../../domain/repositories/university_repository.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final List<University> _universities = [
    const University(
      id: 'a0000000-0000-0000-0000-000000000001',
      name: 'Apex Institute of Technology',
      shortCode: 'AIT',
      domain: 'ait.edu',
      logoUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=200',
    ),
    const University(
      id: 'a0000000-0000-0000-0000-000000000002',
      name: 'Metropolitan University',
      shortCode: 'MU',
      domain: 'metro.edu',
      logoUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=200',
    ),
  ];

  final List<Course> _courses = [
    const Course(
      id: 'd0000000-0000-0000-0000-000000000001',
      departmentId: 'c0000000-0000-0000-0000-000000000001',
      universityId: 'a0000000-0000-0000-0000-000000000001',
      code: 'CSE 301',
      title: 'Algorithms & Data Structures',
      creditHours: 3.0,
      instructor: 'Prof. Ada Lovelace',
      room: 'Lab 402',
    ),
    const Course(
      id: 'd0000000-0000-0000-0000-000000000002',
      departmentId: 'c0000000-0000-0000-0000-000000000001',
      universityId: 'a0000000-0000-0000-0000-000000000001',
      code: 'CSE 320',
      title: 'Database Systems',
      creditHours: 3.0,
      instructor: 'Prof. Edgar Codd',
      room: 'Auditorium A',
    ),
    const Course(
      id: 'd0000000-0000-0000-0000-000000000003',
      departmentId: 'c0000000-0000-0000-0000-000000000001',
      universityId: 'a0000000-0000-0000-0000-000000000001',
      code: 'MAT 205',
      title: 'Linear Algebra & Calculus',
      creditHours: 3.0,
      instructor: 'Prof. Carl Gauss',
      room: 'Room 305',
    ),
  ];

  final List<Exam> _exams = [
    Exam(
      id: 'exam-1',
      courseCode: 'CSE 301',
      courseTitle: 'Algorithms Midterm Exam',
      examDate: DateTime.now().add(const Duration(days: 8, hours: 10)),
      room: 'Auditorium Central',
      weightage: 30.0,
    ),
    Exam(
      id: 'exam-2',
      courseCode: 'CSE 320',
      courseTitle: 'Database Systems Quiz 2',
      examDate: DateTime.now().add(const Duration(days: 14, hours: 14)),
      room: 'Lab 402',
      weightage: 15.0,
    ),
  ];

  @override
  Future<List<University>> getUniversities() async => _universities;

  @override
  Future<List<Course>> getEnrolledCourses({required String userId}) async => _courses;

  @override
  Future<List<Exam>> getUpcomingExams({required String universityId}) async => _exams;

  @override
  Future<void> enrollInCourse({required String userId, required String courseId}) async {}

  @override
  Future<void> dropCourse({required String userId, required String courseId}) async {}
}

final universityRepositoryProvider = Provider<UniversityRepository>((ref) {
  return UniversityRepositoryImpl();
});
