class University {
  final String id;
  final String name;
  final String shortCode;
  final String domain;
  final String logoUrl;

  const University({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.domain,
    required this.logoUrl,
  });
}

class Course {
  final String id;
  final String departmentId;
  final String universityId;
  final String code;
  final String title;
  final double creditHours;
  final String instructor;
  final String room;

  const Course({
    required this.id,
    required this.departmentId,
    required this.universityId,
    required this.code,
    required this.title,
    required this.creditHours,
    required this.instructor,
    required this.room,
  });
}

class Exam {
  final String id;
  final String courseCode;
  final String courseTitle;
  final DateTime examDate;
  final String room;
  final double weightage;

  const Exam({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.examDate,
    required this.room,
    required this.weightage,
  });
}
