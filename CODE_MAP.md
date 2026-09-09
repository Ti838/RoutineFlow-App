# ROUTINE FLOW — Codebase Architecture & File Index

## 1. Directory Structure

```
ROUTINEFLOW-APP/
├── assets/                       # Image assets, official branding & icons
│   ├── icons/app_icon.png        # Official application launcher icon
│   └── images/logo.png           # Official Routine Flow logo
│
├── lib/
│   ├── app/                      # Central application initialization
│   │   ├── app.dart              # MaterialApp.router root widget
│   │   ├── config/               # App configuration & feature toggling
│   │   │   ├── app_config.dart
│   │   │   └── feature_flags.dart
│   │   ├── constants/            # Global constants & asset paths
│   │   │   ├── app_assets.dart
│   │   │   └── app_keys.dart
│   │   ├── router/
│   │   │   └── app_router.dart   # GoRouter navigation & ShellRoute declarations
│   │   └── theme/                # Centralized Material 3 Design System
│   │       ├── app_colors.dart   # Color palette & category themes
│   │       ├── app_radius.dart   # Standard border radiuses
│   │       ├── app_spacing.dart  # Standard 4-point spacing scale
│   │       ├── app_theme.dart    # Light & Dark ThemeData definitions
│   │       └── app_typography.dart # Font styles & hierarchies
│   │
│   ├── core/                     # Core cross-cutting infrastructure
│   │   ├── database/
│   │   │   └── app_database.dart # Local SQLite persistence & sync queue
│   │   ├── responsive/
│   │   │   ├── breakpoints.dart  # Mobile / Tablet / Desktop width thresholds
│   │   │   ├── responsive_layout.dart
│   │   │   └── responsive_scaffold.dart # Adaptive BottomNav & Sidebar
│   │   ├── security/
│   │   │   └── token_storage.dart # Encrypted credentials storage
│   │   ├── services/
│   │   │   ├── conflict_detection_service.dart # Mathematical schedule overlap engine
│   │   │   ├── free_time_service.dart          # Free interval discovery engine
│   │   │   └── notification_service.dart       # Class & exam reminder scheduler
│   │   ├── supabase/
│   │   │   ├── supabase_config.dart            # Backend URL & Anon Key config
│   │   │   └── supabase_client_provider.dart  # Riverpod Supabase singleton
│   │   ├── sync/
│   │   │   └── sync_engine.dart  # Bi-directional offline sync engine
│   │   └── utils/
│   │       ├── date_time_utils.dart # Date formatting & combining utilities
│   │       └── recurrence_engine.dart # RRULE daily/weekly recurrence builder
│   │
│   ├── features/                 # Modular feature domains
│   │   ├── activities/           # Routine & Class Management
│   │   │   ├── data/repositories/activity_repository_impl.dart
│   │   │   ├── domain/models/activity.dart
│   │   │   ├── domain/repositories/activity_repository.dart
│   │   │   └── presentation/screens/
│   │   │       ├── activity_details_screen.dart
│   │   │       └── create_edit_activity_sheet.dart
│   │   ├── admin/                # Campus Administration Portal
│   │   │   └── presentation/screens/
│   │   │       ├── university_admin_screen.dart
│   │   │       └── super_admin_screen.dart
│   │   ├── ai/                   # AI Planner User Interface
│   │   │   └── presentation/screens/ai_planner_screen.dart
│   │   ├── ai_planner/           # AI Client Service
│   │   │   └── data/services/ai_planner_service.dart
│   │   ├── analytics/            # Productivity Metrics & fl_chart
│   │   │   └── presentation/screens/analytics_screen.dart
│   │   ├── auth/                 # Authentication, Login & Registration
│   │   │   ├── data/repositories/auth_repository_impl.dart
│   │   │   ├── domain/models/auth_state.dart
│   │   │   ├── domain/repositories/auth_repository.dart
│   │   │   ├── presentation/providers/auth_provider.dart
│   │   │   └── presentation/screens/
│   │   │       ├── splash_screen.dart
│   │   │       ├── onboarding_screen.dart
│   │   │       ├── login_screen.dart
│   │   │       ├── register_screen.dart
│   │   │       └── forgot_password_screen.dart
│   │   ├── calendar/             # Full Calendar Views
│   │   │   └── presentation/screens/calendar_screen.dart
│   │   ├── goals/                # Semester GPA & Target Goals
│   │   │   ├── data/repositories/goal_repository_impl.dart
│   │   │   ├── domain/models/goal.dart
│   │   │   └── domain/repositories/goal_repository.dart
│   │   ├── habits/               # Habit Streaks & Tracker
│   │   │   ├── data/repositories/habit_repository_impl.dart
│   │   │   ├── domain/repositories/habit_repository.dart
│   │   │   └── presentation/screens/habits_screen.dart
│   │   ├── home/                 # My Day Unified Dashboard
│   │   │   ├── presentation/providers/my_day_provider.dart
│   │   │   ├── presentation/screens/my_day_screen.dart
│   │   │   └── presentation/widgets/
│   │   │       ├── current_activity_card.dart
│   │   │       ├── next_up_card.dart
│   │   │       ├── conflict_card.dart
│   │   │       ├── free_time_card.dart
│   │   │       ├── daily_timeline_view.dart
│   │   │       └── daily_progress_widget.dart
│   │   ├── profile/              # User Profile & University Status
│   │   │   └── presentation/screens/profile_screen.dart
│   │   ├── settings/             # Settings, Theme & Notification Preferences
│   │   │   └── presentation/screens/settings_screen.dart
│   │   ├── subscription/         # Monetization & Mock Payments
│   │   │   ├── data/services/mock_payment_service.dart
│   │   │   ├── presentation/screens/subscription_screen.dart
│   │   │   └── presentation/widgets/payment_modal.dart
│   │   ├── tasks/                # Tasks & Assignments
│   │   │   ├── data/repositories/task_repository_impl.dart
│   │   │   ├── domain/repositories/task_repository.dart
│   │   │   └── presentation/screens/tasks_screen.dart
│   │   └── university/           # Classes, Exams & Deadlines
│   │       ├── data/repositories/university_repository_impl.dart
│   │       ├── domain/models/university_models.dart
│   │       ├── domain/repositories/university_repository.dart
│   │       └── presentation/screens/university_screen.dart
│   │
│   └── shared/                   # Shared reusable UI primitives
│       ├── models/
│       │   ├── activity_category.dart
│       │   ├── priority.dart
│       │   ├── recurrence_type.dart
│       │   └── user_model.dart
│       └── widgets/
│           ├── app_logo.dart
│           ├── custom_text_field.dart
│           ├── empty_state_view.dart
│           ├── primary_button.dart
│           └── status_badge.dart
│
├── supabase/                     # Backend Database Migrations & Edge Functions
│   ├── functions/ai-planner/index.ts # Deno TypeScript AI Planner Function
│   └── migrations/
│       ├── 001_initial_schema.sql    # Multi-tenant schema definitions
│       ├── 002_rls_policies.sql      # Row-Level Security isolation policies
│       └── 003_seed_data.sql         # Seed universities, courses & plans
│
└── test/unit/                    # Automated Unit Tests
    ├── conflict_detection_test.dart
    ├── free_time_detection_test.dart
    ├── payment_service_test.dart
    └── recurrence_engine_test.dart
```
