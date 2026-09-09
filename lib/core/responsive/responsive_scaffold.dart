import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_typography.dart';
import '../../features/auth/domain/models/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../shared/widgets/app_logo.dart';
import 'breakpoints.dart';

class ResponsiveScaffold extends ConsumerWidget {
  final Widget child;
  final int currentIndex;
  final VoidCallback? onFabPressed;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.onFabPressed,
  });

  void _onNavigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/my-day');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/tasks');
        break;
      case 3:
        context.go('/university');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveBreakpoints.isExpanded(context);
    final isTablet = ResponsiveBreakpoints.isMedium(context);
    final authState = ref.watch(authNotifierProvider);
    final userName =
        authState is Authenticated ? authState.user.name : 'Student';
    final userDept = authState is Authenticated
        ? '${authState.user.department} • ${authState.user.universityName}'
        : 'CSE • DUET';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'S';

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Sidebar Navigation for Desktop
            Container(
              width: 260,
              decoration: const BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(
                  right: BorderSide(color: AppColors.borderDark, width: 1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const AppLogo(size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'RoutineFlow',
                          style: AppTypography.heading3.copyWith(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _navItem(context, 0, Icons.wb_sunny_rounded, 'My Day'),
                  _navItem(
                      context, 1, Icons.calendar_month_rounded, 'Calendar'),
                  _navItem(
                      context, 2, Icons.check_circle_outline_rounded, 'Tasks'),
                  _navItem(context, 3, Icons.school_rounded, 'University'),
                  _navItem(context, 4, Icons.person_rounded, 'Profile'),
                  const Spacer(),
                  _buildAdminLink(context),
                  const Divider(color: AppColors.borderDark),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary,
                          child: Text(userInitial,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userName,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textPrimaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                userDept,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondaryDark,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Main Content Area
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    }

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (idx) => _onNavigate(context, idx),
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppColors.surfaceDark,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              unselectedIconTheme:
                  const IconThemeData(color: AppColors.textSecondaryDark),
              selectedLabelTextStyle: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: AppTypography.caption.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: AppLogo(size: 28),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.wb_sunny_outlined),
                  selectedIcon: Icon(Icons.wb_sunny_rounded),
                  label: Text('My Day'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: Text('Calendar'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle_rounded),
                  label: Text('Tasks'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school_rounded),
                  label: Text('University'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: Text('Profile'),
                ),
              ],
            ),
            const VerticalDivider(
                thickness: 1, width: 1, color: AppColors.borderDark),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Mobile Bottom Navigation
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) => _onNavigate(context, idx),
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withAlpha(50),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined,
                color: AppColors.textSecondaryDark),
            selectedIcon:
                Icon(Icons.wb_sunny_rounded, color: AppColors.primary),
            label: 'My Day',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined,
                color: AppColors.textSecondaryDark),
            selectedIcon:
                Icon(Icons.calendar_month_rounded, color: AppColors.primary),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline,
                color: AppColors.textSecondaryDark),
            selectedIcon:
                Icon(Icons.check_circle_rounded, color: AppColors.primary),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon:
                Icon(Icons.school_outlined, color: AppColors.textSecondaryDark),
            selectedIcon: Icon(Icons.school_rounded, color: AppColors.primary),
            label: 'University',
          ),
          NavigationDestination(
            icon:
                Icon(Icons.person_outline, color: AppColors.textSecondaryDark),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _navItem(
      BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        tileColor:
            isSelected ? AppColors.primary.withAlpha(40) : Colors.transparent,
        leading: Icon(
          icon,
          color:
              isSelected ? AppColors.primaryLight : AppColors.textSecondaryDark,
        ),
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.textSecondaryDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => _onNavigate(context, index),
      ),
    );
  }

  Widget _buildAdminLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        leading: const Icon(Icons.admin_panel_settings_outlined,
            color: AppColors.university),
        title: Text(
          'Campus Admin',
          style: AppTypography.caption.copyWith(
            color: AppColors.university,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => context.push('/admin/university'),
      ),
    );
  }
}
