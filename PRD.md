# ROUTINE FLOW — Product Requirements Document (PRD)

<p align="center">
  <img src="assets/images/logo.png" alt="Routine Flow Logo" width="100" height="100" />
</p>

## 1. Executive Summary & Product Vision

### 1.1 Brand Philosophy
> **"Personal Routine + University Routine = One Unified Daily Schedule"**

The modern university student lives in a fragmented digital landscape:
- University class schedules and room changes are posted in PDFs or LMS portals.
- Personal habits and workouts are tracked in habit tracker apps.
- Daily tasks and study deadlines are kept in separate to-do lists.
- Exam countdowns and assignment submissions are scattered across chat groups.

**ROUTINE FLOW** eliminates schedule fragmentation by synthesizing every academic obligation and personal habit into a single, cohesive, chronological daily timeline.

### 1.2 Core Product Question
Every feature in Routine Flow is engineered to answer one fundamental question with extreme clarity:
> **"What should I do now, and what do I need to do next?"**

---

## 2. Problem Statement & User Pain Points

| User Persona | Core Problem | How Routine Flow Solves It |
| :--- | :--- | :--- |
| **University Student (Timon)** | "My classes change rooms, I have assignments due, and I struggle to find uninterrupted time to study without conflicting with my fitness or personal routines." | Unifies LMS timetables with personal tasks, alerts on schedule conflicts in advance, and discovers free-time study windows. |
| **Working Student / Freelancer** | "I work part-time around my university lectures. When a class is rescheduled, my work shifts get disrupted." | Real-time clash detection alerts the user immediately and recommends optimal rescheduling slots. |
| **Class Representative (CR)** | "Broadcasting room changes or exam dates through chaotic chat groups leads to missed deadlines." | Dedicated Batch Announcement & Chat Channels with pinned deadlines and automatic schedule updates. |
| **Department Timetable Admin** | "Broadcasting room changes or class rescheduling through bulletin boards causes campus confusion." | Centralized Routine Management enabling 1-click timetable broadcasting with push notification alerts to all enrolled students. |

---

## 3. Product Goals & Key Performance Indicators (KPIs)

### 3.1 Qualitative Goals
- Eliminate cognitive overload caused by juggling multiple calendar and task apps.
- Provide zero-latency, offline-capable schedule views on any device.
- Empower students to balance GPA targets with physical and mental well-being.
- Enable frictionless peer collaboration and class communications without distractions.

### 3.2 Quantitative Target Metrics
- **Daily Active Users (DAU) Engagement**: >85% of users checking "My Day" 3+ times daily.
- **Conflict Resolution Rate**: >90% of schedule clashes resolved in under 2 clicks.
- **Offline Reliability**: 100% offline data retention with zero lost edits on network reconnect.
- **Free-to-Paid Conversion**: 5-8% conversion to Routine Flow Pro via local/global payments.

---

## 4. Comprehensive Feature Ecosystem

### 4.1 "My Day" Unified Daily Cockpit
- **Current Activity Card**: Prominently highlights the active task or university class with countdown timer, room number, instructor name, and completion controls.
- **Next Up Banner**: Previews the upcoming commitment with remaining preparation time.
- **Conflict Alert Card**: Flags overlapping activities (e.g., study session clashing with an urgent lab class) and suggests 1-tap resolutions.
- **Free-Time Detection Widget**: Identifies 45m+ gaps between university lectures and suggests high-impact focus sessions.
- **Daily Progress Bar**: Live circular indicator showing percentage of completed daily items.

### 4.2 University Academic Suite
- **Class Timetable Sync**: Automatically organizes weekly recurring lecture slots by course code, section, faculty, and classroom.
- **Exam Countdown Hub**: Categorizes Midterms, Finals, and Quizzes with real-time countdown clocks.
- **Assignment & Lab Tracker**: Prioritized submission deadlines with milestone checkboxes.

### 4.3 Habits & Productivity Engine
- **Flexible & Fixed Habits**: Daily routines (e.g., Morning Workout, Reading, Code Practice) with recurring alarms.
- **Streak Tracker & Heatmaps**: Visual consistency analytics with fire streaks and motivational badges.
- **Smart Task Management**: Time-blocked task lists with priority tags (High, Medium, Low).

### 4.4 Real-Time Class Chat & Collaboration
- **Batch Announcement Channel**: CR-managed broadcast channel for important class notices and schedule revisions.
- **Course Discussion Rooms**: Topic-specific chat channels for each enrolled course (e.g., `CSE-201: Data Structures`).
- **Peer Direct Messaging**: 1-on-1 messaging and study-partner matching.
- **File & Resource Sharing**: Upload lecture slides, class notes, and past question papers.

### 4.5 AI Intelligent Planner (Edge & Cloud Assisted)
- **OCR Routine Ingestion**: Upload photo or PDF of class timetable -> Gemini/OCR parses and populates the routine automatically.
- **Exam Study Blueprinting**: Enter syllabus topics -> AI breaks down daily 45-minute revision blocks into free schedule gaps.
- **Smart Schedule Rebalancing**: Auto-adjusts personal habits when surprise makeup classes are scheduled.

### 4.6 Payment Gateways & Monetization Suite
- **Local Payment Gateways (Bangladesh & Regional)**:
  - **bKash Tokenized Checkout**: 1-click recurring or monthly MFS payments.
  - **Nagad Direct Gateway**: Fast mobile wallet checkout.
  - **SSLCommerz / Shurjopay**: Multi-card (Visa, Mastercard, Amex, DBBL Nexus) support.
- **International & App Store Payments**:
  - **Stripe Elements**: Credit/Debit card subscriptions worldwide.
  - **Google Play In-App Billing** & **Apple StoreKit**: Native operating system subscriptions.
- **Tier Structure**:
  - **Free Tier**: Complete local routine management, habits, tasks, offline storage.
  - **Pro Tier ($1.99 / ৳150 mo)**: AI Timetable OCR, Smart Exam Planner, Cloud Backup, Unlimited Study Groups.
  - **Institutional Tier**: Campus-wide site license for university departments.

---

## 5. Non-Functional Requirements
- **Performance**: Cold start $< 800\text{ms}$, frame rendering at stable 60 FPS (120 FPS on supported high-refresh screens).
- **Offline Capability**: 100% core features functional with no network connection.
- **Security**: Data isolation enforced at database engine level via Row-Level Security (RLS) and encrypted local storage.
