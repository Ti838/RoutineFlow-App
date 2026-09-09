import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/sync/sync_engine.dart';
import '../../domain/models/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../data/repositories/activity_repository_impl.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final syncEngine = ref.watch(syncEngineProvider);
  return ActivityRepositoryImpl(syncEngine: syncEngine);
});

class ActivityNotifier extends StateNotifier<AsyncValue<List<Activity>>> {
  final ActivityRepository _repository;

  ActivityNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadActivities();
  }

  Future<void> loadActivities() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getActivities();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addActivity(Activity activity) async {
    try {
      await _repository.createActivity(activity);
      await loadActivities();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      await _repository.updateActivity(activity);
      await loadActivities();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteActivity(String id) async {
    try {
      await _repository.deleteActivity(id);
      await loadActivities();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markCompleted(String id) async {
    try {
      await _repository.updateStatus(id, ActivityStatus.completed);
      await loadActivities();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markSkipped(String id) async {
    try {
      await _repository.updateStatus(id, ActivityStatus.skipped);
      await loadActivities();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, AsyncValue<List<Activity>>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return ActivityNotifier(repo);
});
