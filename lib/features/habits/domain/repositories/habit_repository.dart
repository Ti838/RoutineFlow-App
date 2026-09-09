import '../../presentation/screens/habits_screen.dart';

abstract class HabitRepository {
  Future<List<HabitItem>> getHabits({required String userId});
  Future<HabitItem> createHabit(HabitItem habit);
  Future<HabitItem> logHabitCompletion(String habitId, DateTime date);
  Future<void> deleteHabit(String id);
}
