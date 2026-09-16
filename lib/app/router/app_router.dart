import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/my_day_screen.dart';
import '../../features/university/presentation/screens/university_screen.dart';
import '../../features/ai_planner/presentation/screens/ai_planner_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MyDayScreen(),
    ),
    GoRoute(
      path: '/university',
      builder: (context, state) => const UniversityScreen(),
    ),
    GoRoute(
      path: '/ai-planner',
      builder: (context, state) => const AiPlannerScreen(),
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) => appRouter);
