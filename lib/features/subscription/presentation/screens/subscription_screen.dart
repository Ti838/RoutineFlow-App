import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../widgets/payment_modal.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Routine Flow Pro'),
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildHeroBanner(),
          const SizedBox(height: AppSpacing.lg),
          _buildPlanCard(
            context: context,
            title: 'Free Student Tier',
            price: '\$0 / month',
            planId: 'free',
            amountCents: 0,
            features: const [
              'Unified Daily Calendar',
              'Manual Class & Personal Routine Logging',
              'Basic Schedule Conflict Alerts',
              'Up to 3 Active Habits',
            ],
            isCurrent: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildPlanCard(
            context: context,
            title: 'Pro Student (Monthly)',
            price: '\$4.99 / month',
            planId: 'pro_monthly',
            amountCents: 499,
            isPopular: true,
            features: const [
              'Everything in Free',
              'Full AI Daily Planner & Smart Rescheduler',
              'Exam Sprint Auto-Study Planner',
              'Unlimited Habits & Goals',
              'Offline-First Cloud Multi-Device Sync',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildPlanCard(
            context: context,
            title: 'Pro Student (Yearly)',
            price: '\$39.99 / year',
            planId: 'pro_yearly',
            amountCents: 3999,
            badge: 'Save 30%',
            features: const [
              'All Monthly Pro Features',
              '2 Months Free Equivalent',
              'Beta Access to Next-Gen AI Models',
              'Priority University Timetable Sync',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.university],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Column(
        children: [
          Icon(Icons.workspace_premium_rounded, size: 48, color: Colors.white),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Supercharge Your Academic Life',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Unlock full AI scheduling, exam sprint optimization, and multi-device cloud sync.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String planId,
    required int amountCents,
    required List<String> features,
    bool isCurrent = false,
    bool isPopular = false,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isPopular ? AppColors.primary : AppColors.borderDark,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              if (badge != null || isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPopular ? AppColors.primary : AppColors.success,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(badge ?? 'Most Popular', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
          const SizedBox(height: AppSpacing.md),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark))),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            text: isCurrent ? 'Current Active Plan' : 'Subscribe Now',
            onPressed: isCurrent
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => PaymentCheckoutModal(
                        planName: title,
                        planId: planId,
                        amountCents: amountCents,
                        currency: 'USD',
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
