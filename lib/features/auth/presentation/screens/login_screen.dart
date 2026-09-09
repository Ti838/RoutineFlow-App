import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/models/auth_state.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'student@routineflow.app');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  final List<Map<String, dynamic>> _testUsers = [
    {
      'role': 'Regular Student',
      'user': UserModel(
        id: 'test_student_1',
        name: 'Alex Morgan',
        email: 'alex@routineflow.app',
        universityName: 'Dhaka University of Eng & Tech',
        department: 'Computer Science & Engineering',
        semester: '6th Semester',
        studentId: '2024-CSE-042',
        isPremium: false,
      ),
      'icon': Icons.school,
      'color': AppColors.primary,
      'desc': 'Free Tier • Daily schedule, routines & habits',
    },
    {
      'role': 'Pro Student',
      'user': UserModel(
        id: 'test_student_2',
        name: 'Sarah Khan',
        email: 'sarah@routineflow.app',
        universityName: 'Dhaka University of Eng & Tech',
        department: 'Software Engineering',
        semester: '4th Semester',
        studentId: '2025-SE-019',
        isPremium: true,
      ),
      'icon': Icons.workspace_premium,
      'color': AppColors.study,
      'desc': 'PRO Tier • AI Routine Planner, Smart Rescheduling',
    },
    {
      'role': 'Class Representative (CR)',
      'user': UserModel(
        id: 'test_cr_3',
        name: 'Rahul Roy (CR)',
        email: 'rahul.cr@routineflow.app',
        universityName: 'Dhaka University of Eng & Tech',
        department: 'Computer Science & Engineering',
        semester: '6th Semester',
        studentId: '2024-CSE-001',
        isPremium: true,
      ),
      'icon': Icons.campaign,
      'color': AppColors.warning,
      'desc': 'CR Access • Batch announcements, routine updates',
    },
    {
      'role': 'Faculty / Advisor',
      'user': UserModel(
        id: 'test_faculty_4',
        name: 'Dr. M. Rahman',
        email: 'rahman.faculty@duet.ac.bd',
        universityName: 'Dhaka University of Eng & Tech',
        department: 'Dept of CSE',
        semester: 'Faculty & Coordinator',
        studentId: 'FAC-CSE-108',
        isPremium: true,
      ),
      'icon': Icons.psychology,
      'color': AppColors.university,
      'desc': 'Faculty • Lecture timetables, student advising',
    },
    {
      'role': 'Campus Administrator',
      'user': UserModel(
        id: 'test_admin_5',
        name: 'University Registrar',
        email: 'admin@routineflow.app',
        universityName: 'Dhaka University of Eng & Tech',
        department: 'Central Timetable Office',
        semester: 'Admin Operations',
        studentId: 'ADMIN-001',
        isPremium: true,
      ),
      'icon': Icons.admin_panel_settings,
      'color': AppColors.error,
      'desc': 'Super Admin • Department routine publishing',
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }
    await ref.read(authNotifierProvider.notifier).login(email, password);
    final state = ref.read(authNotifierProvider);
    if (state is Authenticated && mounted) {
      context.go('/my-day');
    }
  }

  Future<void> _loginAsTestUser(UserModel user) async {
    await ref.read(authNotifierProvider.notifier).loginWithTestUser(user);
    if (mounted) {
      context.go('/my-day');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 64)),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'ROUTINE FLOW',
                    style: AppTypography.heading1.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Select a 1-Tap Test User to inspect all features on your device:',
                    style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 5 Quick Test User Cards
                  ..._testUsers.map((item) {
                    final role = item['role'] as String;
                    final user = item['user'] as UserModel;
                    final icon = item['icon'] as IconData;
                    final color = item['color'] as Color;
                    final desc = item['desc'] as String;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: AppRadius.radiusMd,
                        border: Border.all(color: color.withAlpha(80)),
                      ),
                      child: InkWell(
                        onTap: () => _loginAsTestUser(user),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icon, color: color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(user.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: color.withAlpha(30),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(role, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(desc, style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontSize: 11)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMutedLight),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR CUSTOM LOGIN', style: AppTypography.caption.copyWith(color: AppColors.textMutedLight)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  CustomTextField(
                    controller: _emailController,
                    label: 'Email or Phone',
                    hint: 'Enter your email or phone',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    text: 'Login with Custom Account',
                    height: 48,
                    isLoading: isLoading,
                    onPressed: _submitLogin,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
