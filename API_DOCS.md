# 📡 Routine Flow: API Specifications & Integration Contracts

<p align="center">
  <img src="assets/images/logo.png" alt="Routine Flow Logo" width="100" height="100" />
</p>

## 1. Overview
This document outlines the REST, Edge Function, and WebSocket endpoint specifications for Routine Flow backend services.

---

## 2. Authentication Endpoints

### 2.1 Sign Up with Email & University ID
- **Endpoint**: `POST /auth/v1/signup`
- **Request Body**:
  ```json
  {
    "email": "student@university.edu",
    "password": "SecurePassword123!",
    "data": {
      "full_name": "Timon Roy",
      "university_id": "univ_ait_01",
      "department_id": "dept_cse_01",
      "student_id": "2024-CSE-042"
    }
  }
  ```
- **Response `201 Created`**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsIn...",
    "token_type": "bearer",
    "expires_in": 3600,
    "user": {
      "id": "usr_99812",
      "email": "student@university.edu"
    }
  }
  ```

---

## 3. Academic Routine & Course Endpoints

### 3.1 Fetch Department Class Routine
- **Endpoint**: `GET /rest/v1/course_offerings`
- **Headers**: `Authorization: Bearer <JWT>`, `apikey: <ANON_KEY>`
- **Query Params**: `department_id=eq.dept_cse_01&term_id=eq.term_fall_2026`
- **Response `200 OK`**:
  ```json
  [
    {
      "id": "offering_cse301_a",
      "course_code": "CSE-301",
      "course_name": "Database Systems",
      "instructor_name": "Dr. Rahman",
      "day_of_week": 1,
      "start_time": "09:00:00",
      "end_time": "10:30:00",
      "room_number": "Room 402",
      "building": "Academic Complex"
    }
  ]
  ```

---

## 4. AI Intelligence Endpoints (Edge Function)

### 4.1 Parse Timetable from Image/PDF (OCR)
- **Endpoint**: `POST /functions/v1/ai-planner`
- **Headers**: `Authorization: Bearer <JWT>`
- **Request Body**:
  ```json
  {
    "action": "parse_routine",
    "image_base64": "data:image/png;base64,iVBORw0KGgo...",
    "semester": "Fall 2026"
  }
  ```
- **Response `200 OK`**:
  ```json
  {
    "slots": [
      {
        "course_code": "CSE-301",
        "title": "Database Systems",
        "day": "Monday",
        "start_time": "09:00",
        "end_time": "10:30",
        "room": "Room 402"
      }
    ],
    "confidence_score": 0.98
  }
  ```

### 4.2 Generate Smart Exam Revision Plan
- **Endpoint**: `POST /functions/v1/ai-planner`
- **Request Body**:
  ```json
  {
    "action": "generate_study_plan",
    "exam_date": "2026-10-15",
    "course_name": "Algorithms",
    "topics": ["Dynamic Programming", "Graph Traversal", "Greedy"],
    "daily_study_hours": 2
  }
  ```

---

## 5. Payment & Checkout Endpoints

### 5.1 Initialize bKash / Nagad Checkout
- **Endpoint**: `POST /functions/v1/payment-checkout`
- **Request Body**:
  ```json
  {
    "gateway": "bkash",
    "plan_id": "pro_monthly",
    "amount": 150,
    "currency": "BDT",
    "callback_url": "https://routineflow.app/payment/callback"
  }
  ```
- **Response `200 OK`**:
  ```json
  {
    "payment_id": "BK_TRANS_882194",
    "redirect_url": "https://checkout.sandbox.bka.sh/v1.2.0-beta/tokenized/wrapper?paymentID=BK_TRANS_882194",
    "status": "Initiated"
  }
  ```
