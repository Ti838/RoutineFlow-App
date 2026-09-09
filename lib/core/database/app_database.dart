import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncQueueItem {
  final int id;
  final String entityType;
  final String entityId;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  const SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entityType': entityType,
    'entityId': entityId,
    'action': action,
    'payload': payload,
    'createdAt': createdAt.toIso8601String(),
    'retryCount': retryCount,
  };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
    id: json['id'] as int,
    entityType: json['entityType'] as String,
    entityId: json['entityId'] as String,
    action: json['action'] as String,
    payload: (json['payload'] as Map<String, dynamic>?) ?? {},
    createdAt: DateTime.parse(json['createdAt'] as String),
    retryCount: json['retryCount'] as int? ?? 0,
  );
}

class AppDatabase {
  static const String _syncQueueKey = 'routineflow_sync_queue';
  static const String _activitiesKey = 'routineflow_local_activities';

  Future<List<SyncQueueItem>> getSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_syncQueueKey) ?? [];
    return raw.map((str) => SyncQueueItem.fromJson(jsonDecode(str))).toList();
  }

  Future<void> addToSyncQueue(SyncQueueItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getSyncQueue();
    list.add(item);
    await prefs.setStringList(_syncQueueKey, list.map((i) => jsonEncode(i.toJson())).toList());
  }

  Future<void> removeSyncQueueItem(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getSyncQueue();
    list.removeWhere((i) => i.id == id);
    await prefs.setStringList(_syncQueueKey, list.map((i) => jsonEncode(i.toJson())).toList());
  }

  Future<void> updateSyncQueueItem(SyncQueueItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getSyncQueue();
    final idx = list.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      list[idx] = item;
      await prefs.setStringList(_syncQueueKey, list.map((i) => jsonEncode(i.toJson())).toList());
    }
  }

  Future<void> saveLocalActivities(List<Map<String, dynamic>> activities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _activitiesKey,
      activities.map((a) => jsonEncode(a)).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> getLocalActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_activitiesKey) ?? [];
    return raw.map((str) => jsonDecode(str) as Map<String, dynamic>).toList();
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
