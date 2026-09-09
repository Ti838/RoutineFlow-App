import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    if (SupabaseConfig.isConfigured) {
      return Supabase.instance.client;
    }
  } catch (_) {}
  return null;
});

final currentUserIdProvider = Provider<String>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client?.auth.currentUser?.id ?? 'demo-user-123';
});
