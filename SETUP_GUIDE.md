# ROUTINE FLOW — Comprehensive Setup & Deployment Guide

## 1. Local Development Environment

### 1.1 Prerequisites
- **Flutter SDK**: Version 3.47.2 (or any Flutter 3.x release).
- **Dart SDK**: Version 3.13.2+
- **Android Studio / Command Line Tools**: SDK Platform 34+, Android Build Tools.
- **Java**: JDK 17 recommended.

### 1.2 Installation Steps
```bash
# 1. Clone repository
git clone https://github.com/your-username/routineflow-app.git
cd routineflow-app

# 2. Fetch dependencies
flutter pub get

# 3. Verify static analysis
dart analyze

# 4. Run automated test suite
flutter test
```

---

## 2. Supabase Backend Setup

### 2.1 Database Migrations
In your Supabase project dashboard (or local Supabase CLI):
1. Navigate to **SQL Editor**.
2. Execute [`supabase/migrations/001_initial_schema.sql`](file:///c:/Users/TIMON/Desktop/ROUTINEFLOW-APP/supabase/migrations/001_initial_schema.sql) to create all tables and enums.
3. Execute [`supabase/migrations/002_rls_policies.sql`](file:///c:/Users/TIMON/Desktop/ROUTINEFLOW-APP/supabase/migrations/002_rls_policies.sql) to enable Row-Level Security.
4. Execute [`supabase/migrations/003_seed_data.sql`](file:///c:/Users/TIMON/Desktop/ROUTINEFLOW-APP/supabase/migrations/003_seed_data.sql) to populate sample universities and subscription tiers.

### 2.2 Edge Function Deployment
```bash
# Deploy AI Planner function
supabase functions deploy ai-planner --no-verify-jwt
supabase secrets set GEMINI_API_KEY="your-gemini-api-key"
```

---

## 3. Running & Debugging

### 3.1 Run on Physical Android Phone via USB
```bash
# Verify phone is connected
adb devices

# Run application in debug mode
flutter run -d <device-id>
```

### 3.2 Run on Web / Desktop
```bash
# Run on Chrome
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows
```

### 3.3 Build Release APK
```bash
flutter build apk --release
```
The output APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.
