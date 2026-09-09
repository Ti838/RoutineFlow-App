enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly;

  String get label {
    switch (this) {
      case RecurrenceType.none:
        return 'One-time';
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
    }
  }
}
