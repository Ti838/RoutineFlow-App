import '../models/university_models.dart';

abstract class UniversityRepository {
  Future<List<University>> getUniversities();
  Future<List<Course>> getEnrolledCourses({required String userId});
  Future<List<Exam>> getUpcomingExams({required String universityId});
  Future<void> enrollInCourse({required String userId, required String courseId});
  Future<void> dropCourse({required String userId, required String courseId});
}
