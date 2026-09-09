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
| **Department Timetable Admin** | "Broadcasting room changes or class rescheduling through bulletin boards or messaging groups causes confusion." | Dedicated Campus Admin Portal enables 1-click timetable broadcasting with push notification alerts to all enrolled students. |

---

## 3. Product Goals & Key Performance Indicators (KPIs)

### 3.1 Qualitative Goals
- Eliminate cognitive overload caused by juggling multiple calendar and task apps.
- Provide zero-latency, offline-capable schedule views on any device.
- Empower students to balance GPA targets with physical and mental well-being.

### 3.2 Quantitative Target Metrics
- **Daily Active Users (DAU) Engagement**: >85% of users checking "My Day" 3+ times daily.
- **Conflict Resolution Rate**: >90% of schedule clashes resolved in under 2 clicks.
- **Offline Reliability**: 100% offline data retention with zero lost edits on network reconnect.

---

## 4. Detailed Feature Breakdown

### 4.1 "My Day" Unified Daily Engine
- **Current Activity Card**: Prominently highlights the active task or university class with countdown timer, room number, instructor name, and completion controls.
- **Next Up Banner**: Previews the upcoming commitment with remaining preparation time.
- **Conflict Alert Card**: Flags overlapping activities (e.g., study session clashing with an urgent lab class) and suggests 1-tap resolutions.
- **Free-Time Detection Widget**: Identifies 45m+ gaps between university lectures and suggests high-impact focus sessions.
- **Daily Progress Bar**: Live circular indicator showing percentage of completed daily items.

### 4.2 University Academic Suite
- **Class Timetable Sync**: Automatically organizes weekly recurring lecture slots by course code, section, faculty, and classroom.
- **Exam Countdown & Syllabus Tracker**: Displays upcoming midterm and final exams with percentage weightage and room allocations.
- **Assignment Deadline Manager**: Countdown timers for assignment submissions with direct submission links.
- **Campus Noticeboard**: Official department announcements and emergency timetable changes.

### 4.3 Habits & Streak Architecture
- **Multi-Frequency Habits**: Daily, 5-day weekday, and custom frequency routines.
- **Streak & Longest Streak Tracking**: Motivation engine rewarding consistent daily completion.
- **Time-of-Day Categorization**: Morning, Afternoon, Evening, and All-Day habit filtering.

### 4.4 AI Planner Studio (Powered by Gemini 1.5 Flash)
- **Daily Routine Synthesis**: Evaluates pending to-do tasks, wake/sleep preferences, and fixed university classes to generate an optimized focus schedule.
- **Exam Sprint Auto-Scheduler**: Spreads revision topics across open free-time slots in the 14 days preceding an exam.

### 4.5 Monetization & Subscription Tiers
- **Free Student Tier**: Core schedule sync, manual logging, basic conflict detection, up to 3 active habits.
- **Pro Student ($4.99/mo or $39.99/yr)**: Unlimited habits & goals, full AI Daily Planner, Exam Sprint optimizer, and multi-device cloud backup.
- **Campus Enterprise**: Direct university LMS integration, automated timetable ingestion, and official faculty office hour booking.
