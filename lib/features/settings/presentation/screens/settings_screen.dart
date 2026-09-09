import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _quietHours = false;
  bool _conflictAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Preferences', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          _switchTile('Push Notifications', 'Receive reminders 15 mins before classes', _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v)),
          _switchTile('Schedule Conflict Alerts', 'Real-time overlap detection for routines', _conflictAlerts, (v) => setState(() => _conflictAlerts = v)),
          _switchTile('Quiet Hours (10 PM – 7 AM)', 'Silence non-critical notifications', _quietHours, (v) => setState(() => _quietHours = v)),
          const SizedBox(height: AppSpacing.lg),
          Text('App Info', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Routine Flow App', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Version 1.0.0 (Production Cross-Platform Build)', style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile(
        title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
