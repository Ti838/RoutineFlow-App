enum ActivityCategory {
  study,
  university,
  personal,
  health,
  work,
  other;

  String get label {
    switch (this) {
      case ActivityCategory.study:
        return 'Study';
      case ActivityCategory.university:
        return 'University';
      case ActivityCategory.personal:
        return 'Personal';
      case ActivityCategory.health:
        return 'Health';
      case ActivityCategory.work:
        return 'Work';
      case ActivityCategory.other:
        return 'Other';
    }
  }
}
