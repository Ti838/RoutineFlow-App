import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _isSubmitted
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: AppLogo(size: 64)),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Reset Link Sent', style: AppTypography.heading2),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'We sent password reset instructions to ${_emailController.text.trim()}',
                          style: AppTypography.body
                              .copyWith(color: AppColors.textSecondaryLight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        PrimaryButton(
                          text: 'Back to Login',
                          onPressed: () => context.go('/login'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: AppLogo(size: 64)),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Forgot Password', style: AppTypography.heading1),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Enter your registered email address and we will send you a reset link.',
                          style: AppTypography.body
                              .copyWith(color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        PrimaryButton(
                          text: 'Send Reset Link',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
