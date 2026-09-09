import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Routine Flow Super Admin'),
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildTenantOverview(),
          const SizedBox(height: AppSpacing.lg),
          _buildAIPlatformHealth(),
        ],
      ),
    );
  }

  Widget _buildTenantOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Multi-Tenant Campus Directory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          SizedBox(height: AppSpacing.md),
          ListTile(
            leading: Icon(Icons.school, color: AppColors.primary),
            title: Text('Apex Institute of Technology (AIT)', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: Text('4,850 active students • 142 course sections', style: TextStyle(color: AppColors.textSecondaryDark)),
            trailing: Chip(label: Text('Enterprise', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: AppColors.primary),
          ),
          Divider(color: AppColors.borderDark),
          ListTile(
            leading: Icon(Icons.school, color: AppColors.university),
            title: Text('Metropolitan University (MU)', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: Text('12,300 active students • 380 course sections', style: TextStyle(color: AppColors.textSecondaryDark)),
            trailing: Chip(label: Text('Enterprise', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: AppColors.university),
          ),
        ],
      ),
    );
  }

  Widget _buildAIPlatformHealth() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Engine & Sync Telemetry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          SizedBox(height: AppSpacing.md),
          Text('• Gemini 1.5 Flash Latency: 420ms avg', style: TextStyle(color: AppColors.textSecondaryDark)),
          SizedBox(height: 6),
          Text('• Supabase Realtime Connected Clients: 17,150', style: TextStyle(color: AppColors.textSecondaryDark)),
          SizedBox(height: 6),
          Text('• Drift Offline Sync Queue Health: 99.98% Success', style: TextStyle(color: AppColors.success)),
        ],
      ),
    );
  }
}
