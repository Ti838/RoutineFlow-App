import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive/responsive_scaffold.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/my_day_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import '../../features/habits/presentation/screens/habits_screen.dart';
import '../../features/university/presentation/screens/university_screen.dart';
import '../../features/ai/presentation/screens/ai_planner_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/activities/presentation/screens/activity_details_screen.dart';
import '../../features/admin/presentation/screens/university_admin_screen.dart';
import '../../features/admin/presentation/screens/super_admin_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        int index = 0;
        final loc = state.uri.path;
        if (loc.startsWith('/calendar')) index = 1;
        if (loc.startsWith('/tasks')) index = 2;
        if (loc.startsWith('/university')) index = 3;
        if (loc.startsWith('/profile')) index = 4;
        return ResponsiveScaffold(currentIndex: index, child: child);
      },
      routes: [
        GoRoute(
          path: '/my-day',
          pageBuilder: (context, state) => const NoTransitionPage(child: MyDayScreen()),
        ),
        GoRoute(
          path: '/calendar',
          pageBuilder: (context, state) => const NoTransitionPage(child: CalendarScreen()),
        ),
        GoRoute(
          path: '/tasks',
          pageBuilder: (context, state) => const NoTransitionPage(child: TasksScreen()),
        ),
        GoRoute(
          path: '/habits',
          pageBuilder: (context, state) => const NoTransitionPage(child: HabitsScreen()),
        ),
        GoRoute(
          path: '/university',
          pageBuilder: (context, state) => const NoTransitionPage(child: UniversityScreen()),
        ),
        GoRoute(
          path: '/ai-planner',
          pageBuilder: (context, state) => const NoTransitionPage(child: AIPlannerScreen()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => const NoTransitionPage(child: AnalyticsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/activity/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ActivityDetailsScreen(activityId: id);
      },
    ),
    GoRoute(
      path: '/admin/university',
      builder: (context, state) => const UniversityAdminScreen(),
    ),
    GoRoute(
      path: '/admin/super',
      builder: (context, state) => const SuperAdminScreen(),
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) => appRouter);
