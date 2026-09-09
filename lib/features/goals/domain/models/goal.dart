class Goal {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime targetDate;
  final double progressPercentage;
  final String category;
  final bool isCompleted;

  const Goal({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.targetDate,
    this.progressPercentage = 0.0,
    this.category = 'Academic',
    this.isCompleted = false,
  });

  Goal copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? targetDate,
    double? progressPercentage,
    String? category,
    bool? isCompleted,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
