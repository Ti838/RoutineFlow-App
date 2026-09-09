# ROUTINE FLOW - API & Data Contract Documentation

## 1. Supabase Edge Functions

### `POST /functions/v1/ai-planner`
Generates an optimized daily schedule interleaving university classes and study tasks.

#### Request Headers
```http
Authorization: Bearer <SUPABASE_ANON_KEY>
Content-Type: application/json
```

#### Request Body
```json
{
  "feature": "daily_routine",
  "userId": "user-uuid-123",
  "preferences": {
    "wakeTime": "07:00",
    "sleepTime": "23:00",
    "studyIntensity": "balanced"
  },
  "existingActivities": [
    {
      "id": "act-1",
      "title": "CSE 301: Algorithms",
      "startTime": "2026-09-10T09:30:00Z",
      "endTime": "2026-09-10T11:00:00Z",
      "isAcademic": true
    }
  ],
  "pendingTasks": [
    {
      "id": "task-1",
      "title": "Submit Assignment 2",
      "priority": "urgent",
      "estimatedMinutes": 60
    }
  ]
}
```

#### Response (200 OK)
```json
{
  "recommendations": [
    {
      "title": "Study: Submit Assignment 2",
      "startTime": "2026-09-10T14:30:00Z",
      "endTime": "2026-09-10T15:30:00Z",
      "type": "study",
      "reason": "Scheduled in open afternoon focus window avoiding CSE 301 class.",
      "priority": "urgent"
    }
  ],
  "productivityScore": 89,
  "insights": "Balanced schedule generated maximizing focus intervals."
}
```
