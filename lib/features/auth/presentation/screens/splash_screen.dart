import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../domain/models/auth_state.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final authState = ref.read(authNotifierProvider);
      if (authState is Authenticated) {
        context.go('/my-day');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 80),
            const SizedBox(height: 24),
            Text(
              'ROUTINE FLOW',
              style: AppTypography.heading1.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Personal + University Routine',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
