import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../auth/domain/models/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/app/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // User Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    user != null && user.name.isNotEmpty ? user.name[0].toUpperCase() : 'T',
                    style: AppTypography.heading2.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(user?.name ?? 'Timon Roy', style: AppTypography.heading3),
                          const SizedBox(width: 8),
                          if (user?.isPremium ?? true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('PRO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(user?.email ?? 'timon@routineflow.app', style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Academic Info Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school_outlined, color: AppColors.university, size: 20),
                    const SizedBox(width: 8),
                    Text('University Information', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _infoRow('Institution', user?.universityName ?? 'Dhaka University of Eng & Tech'),
                const Divider(height: 16),
                _infoRow('Department', user?.department ?? 'Computer Science & Engineering'),
                const Divider(height: 16),
                _infoRow('Semester / Batch', user?.semester ?? '6th Semester (Batch 2024)'),
                const Divider(height: 16),
                _infoRow('Student ID', user?.studentId ?? '2024-CSE-042'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Menu Options
          _menuTile(context, Icons.auto_awesome_outlined, 'AI Routine Assistant', () => context.push('/app/ai')),
          _menuTile(context, Icons.insights_outlined, 'Productivity Analytics', () => context.push('/app/analytics')),
          _menuTile(context, Icons.repeat_outlined, 'Habits & Streaks', () => context.push('/app/habits')),
          _menuTile(context, Icons.workspace_premium_outlined, 'Subscription & Pro Features', () => context.push('/app/subscription')),
          _menuTile(context, Icons.lock_outline, 'Privacy & Security Separation', () => {}),
          const SizedBox(height: AppSpacing.lg),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
        Text(value, style: AppTypography.small.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMutedLight),
        onTap: onTap,
      ),
    );
  }
}
