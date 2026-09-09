<<<<<<< HEAD
# RoutineFlow-App
=======
<p align="center">
  <img src="assets/images/logo.png" alt="Routine Flow Logo" width="128" height="128" />
</p>

<h1 align="center">ROUTINE FLOW</h1>

<p align="center">
  <strong>Personal Routine + University Routine = One Unified Daily Schedule</strong>
</p>

<p align="center">
  <em>Answering one vital question extremely well: "What should I do now, and what do I need to do next?"</em>
</p>

<p align="center">
  <a href="#key-features"><img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-2563EB?style=for-the-badge" alt="Platforms" /></a>
  <a href="#tech-stack"><img src="https://img.shields.io/badge/Flutter-3.47.2-02569B?style=for-the-badge&logo=flutter" alt="Flutter" /></a>
  <a href="#backend--database"><img src="https://img.shields.io/badge/Supabase-PostgreSQL%20RLS-3ECF8E?style=for-the-badge&logo=supabase" alt="Supabase" /></a>
  <a href="#ai-intelligence"><img src="https://img.shields.io/badge/AI-Gemini%201.5%20Flash-8E75B2?style=for-the-badge&logo=google" alt="Gemini" /></a>
</p>

---

## 📌 Table of Contents
- [Executive Overview](#-executive-overview)
- [System Architecture](#-system-architecture)
- [Key Features](#-key-features)
- [Database & Multi-Tenant Schema](#-database--multi-tenant-schema)
- [AI Planner & Intelligence Engine](#-ai-planner--intelligence-engine)
- [Offline-First Sync Engine](#-offline-first-sync-engine)
- [Security & Row-Level Policies (RLS)](#-security--row-level-policies-rls)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Directory Structure](#-project-directory-structure)
- [Testing & Quality Assurance](#-testing--quality-assurance)
- [License & Roadmap](#-license--roadmap)

---

## 🚀 Executive Overview

**Routine Flow** is an enterprise-grade, cross-platform productivity and academic scheduling application designed for university students, faculty, and high-performance individuals.

Unlike traditional static calendar apps or isolated to-do lists, Routine Flow intelligently merges **fixed university course schedules, exam dates, assignment deadlines, personal habits, fitness routines, and deep work study blocks** into a single, cohesive, chronological timeline.

```mermaid
mindmap
  root((Routine Flow))
    Academic Intelligence
      University Timetable Sync
      Midterm & Final Exam Alerts
      Assignment Countdown
      Class Cancellation Broadcasts
    Personal Productivity
      Habit Streaks & Logging
      Task Prioritization
      Semester GPA Goals
      Free-Time Detection
    Conflict Detection Engine
      Overlap Identification
      Academic vs Personal Resolution
      Smart Rescheduling
    AI Orchestration
      Gemini 1.5 Flash Synthesis
      Exam Sprint Study Planner
      Focus Interval Optimization
```

---

## 🏛 System Architecture

Routine Flow follows **Clean Architecture** principles combined with **Feature-First modularization** and Riverpod state management:

```mermaid
graph TB
    subgraph ClientLayer ["Client Presentation Layer (Flutter Multi-Platform)"]
        UI_MyDay["My Day Dashboard"]
        UI_Cal["Unified Calendar"]
        UI_Tasks["Tasks & Deadlines"]
        UI_Habits["Habits & Streaks"]
        UI_Univ["University Timetable"]
        UI_AI["AI Planner Studio"]
        UI_Admin["Campus Admin Portal"]
    end

    subgraph StateLayer ["State & Business Logic Layer (Riverpod)"]
        Provider_Auth["AuthNotifier (RBAC)"]
        Provider_Day["MyDayNotifier"]
        Provider_Engine["Conflict & FreeTime Engines"]
        Provider_Sync["SyncEngine (Offline Queue)"]
    end

    subgraph DataLayer ["Data Access & Repository Layer"]
        Repo_Act["ActivityRepository"]
        Repo_Task["TaskRepository"]
        Repo_Habit["HabitRepository"]
        Repo_Univ["UniversityRepository"]
    end

    subgraph StorageLayer ["Persistence & Backend Infrastructure"]
        LocalDB[("Local SQLite / Drift Storage")]
        SupabaseDB[("Supabase PostgreSQL + RLS")]
        EdgeFn["Supabase Edge Function: /ai-planner"]
        LLM["Google Gemini 1.5 Flash API"]
    end

    ClientLayer --> StateLayer
    StateLayer --> DataLayer
    DataLayer --> Provider_Sync
    Provider_Sync --> LocalDB
    Provider_Sync --> SupabaseDB
    ClientLayer --> EdgeFn
    EdgeFn --> LLM
```

---

## 🌟 Key Features

| Feature | Description | Status |
| :--- | :--- | :---: |
| **Unified My Day Timeline** | Real-time chronological schedule answering "What should I do now, and next?". | ✅ Production |
| **Conflict Detection Engine** | Automatically highlights overlapping university lectures and personal tasks. | ✅ Production |
| **Free-Time Detection** | Detects gaps between scheduled classes and suggests productive focus windows. | ✅ Production |
| **Academic Multi-Tenancy** | Partitioned university routines, courses, sections, and faculty schedules. | ✅ Production |
| **AI Routine Synthesis** | Interleaves high-intensity study blocks based on wake/sleep habits. | ✅ Production |
| **Offline-First Synchronization** | Full local persistence with automatic background cloud synchronization queue. | ✅ Production |
| **Exam Sprint Planner** | Auto-generates progressive revision schedules leading up to exam dates. | ✅ Production |
| **Mock Billing & Subscriptions** | Simulated checkout for Pro Student and Campus Enterprise tiers. | ✅ Production |
| **Campus Admin Portal** | Timetable management and emergency schedule broadcast controls. | ✅ Production |

---

## 🗄 Database & Multi-Tenant Schema

Routine Flow uses a normalized PostgreSQL schema with full Row-Level Security (RLS) policies:

```mermaid
erDiagram
    UNIVERSITIES ||--o{ ACADEMIC_TERMS : hosts
    UNIVERSITIES ||--o{ DEPARTMENTS : contains
    DEPARTMENTS ||--o{ COURSES : offers
    COURSES ||--o{ COURSE_OFFERINGS : schedules
    PROFILES ||--o{ STUDENT_ENROLLMENTS : enrolls
    COURSE_OFFERINGS ||--o{ STUDENT_ENROLLMENTS : contains
    PROFILES ||--o{ ACTIVITIES : owns
    PROFILES ||--o{ TASKS : manages
    PROFILES ||--o{ HABITS : tracks
    HABITS ||--o{ HABIT_LOGS : records
    COURSE_OFFERINGS ||--o{ EXAMS : schedules
    COURSE_OFFERINGS ||--o{ DEADLINES : sets
    PROFILES ||--o{ USER_SUBSCRIPTIONS : maintains

    UNIVERSITIES {
        UUID id PK
        VARCHAR name
        VARCHAR short_code
        VARCHAR domain
    }
    PROFILES {
        UUID id PK
        VARCHAR email
        VARCHAR full_name
        ENUM role
        BOOLEAN is_premium
    }
    ACTIVITIES {
        UUID id PK
        UUID user_id FK
        VARCHAR title
        TIMESTAMPTZ start_time
        TIMESTAMPTZ end_time
        BOOLEAN is_academic
    }
    TASKS {
        UUID id PK
        UUID user_id FK
        VARCHAR title
        ENUM priority
        BOOLEAN is_completed
    }
    HABITS {
        UUID id PK
        UUID user_id FK
        VARCHAR title
        INT current_streak
    }
```

---

## 🤖 AI Planner & Intelligence Engine

The AI Planner interacts with Supabase Edge Functions and Google Gemini 1.5 Flash to automatically balance academic load with personal recovery:

```mermaid
sequenceDiagram
    autonumber
    actor User as Student
    participant App as Flutter Mobile App
    participant Edge as Supabase Edge Function
    participant AI as Gemini 1.5 Flash
    participant DB as PostgreSQL (ai_usage_logs)

    User->>App: Request AI Daily Plan (Wake: 07:00, Sleep: 23:00)
    App->>Edge: POST /functions/v1/ai-planner (Tasks + Fixed Classes)
    Edge->>AI: Synthesize Non-Conflicting Schedule
    AI-->>Edge: Return Optimized JSON Schedule
    Edge->>DB: Log Prompt & Completion Tokens
    Edge-->>App: Deliver Structured Recommendations
    App->>User: Render Interactive Routine Cards & Apply
```

---

## 🔄 Offline-First Sync Engine

Routine Flow guarantees seamless productivity even without internet connectivity:

```mermaid
flowchart TD
    Action[User Creates/Updates Activity] --> SaveLocal[Save to Local SQLite Storage]
    SaveLocal --> Enqueue[Add to Local Sync Queue]
    Enqueue --> CheckNet{Internet Available?}
    CheckNet -- Yes --> PushRemote[Execute Supabase Remote Mutation]
    PushRemote --> Success{Success?}
    Success -- Yes --> Dequeue[Remove from Sync Queue]
    Success -- No --> Retry[Increment Retry Count & Exponential Backoff]
    CheckNet -- No --> Wait[Wait for Network Connectivity Broadcast]
    Wait --> PushRemote
    Retry --> PushRemote
```

---

## 🛡 Security & Row-Level Policies (RLS)

| Resource | Student | University Admin | Super Admin |
| :--- | :---: | :---: | :---: |
| **Personal Activities / Tasks** | Full Access (Own) | No Access | Read / Audit |
| **Habits & Personal Goals** | Full Access (Own) | No Access | No Access |
| **University Classes / Timetable** | Read Campus | Manage Department | Manage Global |
| **Exam & Deadline Catalog** | Read Enrolled | Publish & Edit | Manage Global |
| **Billing & Subscription Records** | Read Own | No Access | Manage Global |

---

## 🛠 Tech Stack

- **Framework**: [Flutter 3.47.2](https://flutter.dev) / [Dart 3.13.2](https://dart.dev)
- **State Management**: [Riverpod 2.6.1](https://riverpod.dev)
- **Routing**: [GoRouter 14.8.1](https://pub.dev/packages/go_router)
- **Backend & Database**: [Supabase](https://supabase.com) + PostgreSQL 15
- **Local Persistence**: SQLite / Drift + SharedPreferences + Flutter Secure Storage
- **AI Synthesis**: Google Gemini 1.5 Flash + Deno Supabase Edge Functions
- **Networking**: [Dio 5.8.0](https://pub.dev/packages/dio)
- **Data Visualization**: [fl_chart 0.70.2](https://pub.dev/packages/fl_chart)

---

## 🏁 Getting Started

### Prerequisites
- [Flutter SDK (>=3.0.0)](https://flutter.dev/docs/get-started/install)
- [Android Studio / Android SDK](https://developer.android.com/studio)
- [Git](https://git-scm.com)

### Installation
1. **Clone repository**:
   ```bash
   git clone https://github.com/your-username/routineflow-app.git
   cd routineflow-app
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Run Static Analysis & Unit Tests**:
   ```bash
   dart analyze
   flutter test
   ```

4. **Launch on Connected Device**:
   ```bash
   flutter run
   ```

---

## 📁 Project Directory Structure

```
lib/
├── app/                  # Application configuration, theme, constants & routing
│   ├── config/           # AppConfig & FeatureFlags
│   ├── constants/        # Assets, storage keys & strings
│   ├── router/           # GoRouter route declarations
│   └── theme/            # Centralized Material 3 Design System
├── core/                 # Core architecture engines & services
│   ├── database/         # Local persistent SQLite database
│   ├── responsive/       # Mobile, Tablet & Desktop responsive scaffold
│   ├── services/         # ConflictDetection, FreeTime & Notification services
│   ├── supabase/         # Supabase client provider & configuration
│   ├── sync/             # Offline-first bi-directional sync engine
│   └── utils/            # Recurrence & DateTime utilities
├── features/             # Feature-first domain modules
│   ├── activities/       # Personal & university routine logging
│   ├── admin/            # University & Super Admin dashboards
│   ├── ai/               # AI Planner interactive interface
│   ├── analytics/        # Time distribution & productivity charts
│   ├── auth/             # Authentication, onboarding & password recovery
│   ├── calendar/         # Monthly, weekly & daily calendar views
│   ├── habits/           # Habit tracker & streak visualization
│   ├── home/             # My Day unified dashboard
│   ├── profile/          # User profile & academic status
│   ├── settings/         # App preferences & notification toggles
│   ├── subscription/     # Pro upgrade plans & mock checkout
│   ├── tasks/            # Task lists, subtasks & priority tagging
│   └── university/       # Class timetable, exams & deadlines
└── shared/               # Shared reusable widgets & models
```

---

## 🧪 Testing & Quality Assurance

Routine Flow enforces automated quality gates before any build:
- **Unit Testing**: Tests conflict detection, free-time calculation, recurrence engine, and mock payments:
  ```bash
  flutter test
  ```
- **Static Analysis**: Zero lint errors or compiler warnings:
  ```bash
  dart analyze
  ```

---

## 📄 License & Roadmap

Distributed under the **MIT License**.

### Roadmap
- [x] Phase 0: Centralized Design System & Engine Foundation
- [x] Phase 1: Supabase Multi-Tenant Schema, Offline Sync & AI Studio
- [ ] Phase 2: Live University Canvas/Moodle LMS Sync Integration
- [ ] Phase 3: WearOS & Apple Watch Companion Widget

---

<p align="center">
  Built with ❤️ for productive students and high performers worldwide.
</p>
>>>>>>> 05de492 (feat: Routine Flow production MVP with Supabase PostgreSQL, Drift offline sync, AI Planner & Official Branding)
