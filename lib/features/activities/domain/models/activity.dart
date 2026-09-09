import 'package:equatable/equatable.dart';
import '../../../../shared/models/activity_category.dart';
import '../../../../shared/models/priority.dart';
import '../../../../shared/models/recurrence_type.dart';

enum ActivityStatus {
  pending,
  inProgress,
  completed,
  missed,
  skipped,
  cancelled;

  String get label {
    switch (this) {
      case ActivityStatus.pending:
        return 'Pending';
      case ActivityStatus.inProgress:
        return 'In Progress';
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.missed:
        return 'Missed';
      case ActivityStatus.skipped:
        return 'Skipped';
      case ActivityStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Activity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final String? location;
  final ActivityCategory category;
  final Priority priority;
  final ActivityStatus status;
  final RecurrenceType recurrence;
  final int reminderMinutes;
  final String? notes;
  final bool isUniversity;
  final String? courseCode;
  final String? facultyName;
  final String? room;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Activity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.location,
    required this.category,
    this.priority = Priority.medium,
    this.status = ActivityStatus.pending,
    this.recurrence = RecurrenceType.none,
    this.reminderMinutes = 15,
    this.notes,
    this.isUniversity = false,
    this.courseCode,
    this.facultyName,
    this.room,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == ActivityStatus.completed;
  bool get isInProgress => status == ActivityStatus.inProgress;
  bool get isSkipped => status == ActivityStatus.skipped;
  bool get isCancelled => status == ActivityStatus.cancelled;

  Activity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? durationMinutes,
    String? location,
    ActivityCategory? category,
    Priority? priority,
    ActivityStatus? status,
    RecurrenceType? recurrence,
    int? reminderMinutes,
    String? notes,
    bool? isUniversity,
    String? courseCode,
    String? facultyName,
    String? room,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      recurrence: recurrence ?? this.recurrence,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      notes: notes ?? this.notes,
      isUniversity: isUniversity ?? this.isUniversity,
      courseCode: courseCode ?? this.courseCode,
      facultyName: facultyName ?? this.facultyName,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'user_1',
      title: json['title'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      location: json['location'] as String?,
      category: ActivityCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ActivityCategory.other,
      ),
      priority: Priority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => Priority.medium,
      ),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ActivityStatus.pending,
      ),
      recurrence: RecurrenceType.values.firstWhere(
        (e) => e.name == json['recurrence'],
        orElse: () => RecurrenceType.none,
      ),
      reminderMinutes: json['reminderMinutes'] as int? ?? 15,
      notes: json['notes'] as String?,
      isUniversity: json['isUniversity'] as bool? ?? false,
      courseCode: json['courseCode'] as String?,
      facultyName: json['facultyName'] as String?,
      room: json['room'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'durationMinutes': durationMinutes,
    'location': location,
    'category': category.name,
    'priority': priority.name,
    'status': status.name,
    'recurrence': recurrence.name,
    'reminderMinutes': reminderMinutes,
    'notes': notes,
    'isUniversity': isUniversity,
    'courseCode': courseCode,
    'facultyName': facultyName,
    'room': room,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id, userId, title, description, date, startTime, endTime,
    durationMinutes, location, category, priority, status,
    recurrence, reminderMinutes, notes, isUniversity, courseCode,
    facultyName, room, createdAt, updatedAt
  ];
}
