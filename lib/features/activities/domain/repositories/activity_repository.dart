import '../models/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities({DateTime? date});
  Future<Activity> createActivity(Activity activity);
  Future<Activity> updateActivity(Activity activity);
  Future<void> deleteActivity(String id);
  Future<Activity> updateStatus(String id, ActivityStatus status);
}
