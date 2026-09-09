import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import '../supabase/supabase_client_provider.dart';

class SyncEngine {
  final AppDatabase _db;
  final SupabaseClient? _supabase;
  bool _isSyncing = false;
  Timer? _syncTimer;
  int _nextId = 1;

  SyncEngine({required AppDatabase db, SupabaseClient? supabase})
      : _db = db,
        _supabase = supabase {
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncAll());
  }

  void dispose() {
    _syncTimer?.cancel();
  }

  Future<void> enqueueSync({
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final item = SyncQueueItem(
      id: _nextId++,
      entityType: entityType,
      entityId: entityId,
      action: action,
      payload: payload,
      createdAt: DateTime.now(),
    );

    await _db.addToSyncQueue(item);
    unawaited(syncAll());
  }

  Future<void> syncAll() async {
    if (_isSyncing || _supabase == null) return;
    _isSyncing = true;

    try {
      final queueItems = await _db.getSyncQueue();
      for (final item in queueItems) {
        bool success = false;
        try {
          switch (item.action) {
            case 'insert':
            case 'update':
              await _supabase!.from(item.entityType).upsert(item.payload);
              success = true;
              break;
            case 'delete':
              await _supabase!.from(item.entityType).delete().eq('id', item.entityId);
              success = true;
              break;
          }
        } catch (e) {
          debugPrint('Sync failed for item ${item.id}: $e');
          final updated = SyncQueueItem(
            id: item.id,
            entityType: item.entityType,
            entityId: item.entityId,
            action: item.action,
            payload: item.payload,
            createdAt: item.createdAt,
            retryCount: item.retryCount + 1,
          );
          await _db.updateSyncQueueItem(updated);
        }

        if (success) {
          await _db.removeSyncQueueItem(item.id);
        }
      }
    } catch (e) {
      debugPrint('Sync engine execution error: $e');
    } finally {
      _isSyncing = false;
    }
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final engine = SyncEngine(db: db, supabase: supabase);
  ref.onDispose(() => engine.dispose());
  return engine;
});
