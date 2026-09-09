import '../models/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals({required String userId});
  Future<Goal> createGoal(Goal goal);
  Future<Goal> updateGoal(Goal goal);
  Future<void> deleteGoal(String id);
}
