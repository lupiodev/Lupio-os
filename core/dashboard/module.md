# Core Module: Dashboard & Analytics

## Purpose
Provides aggregated metrics and activity data for dashboard views.

## Pattern

Dashboard data is assembled by the API from existing tables. No separate analytics tables unless event volume requires it.

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/dashboard/summary` | Key metrics | Bearer |
| GET | `/dashboard/activity` | Recent activity | Bearer |
| GET | `/dashboard/charts/:metric` | Chart data | Bearer |

## Summary Response Shape

```json
{
  "metrics": {
    "totalUsers": 1240,
    "activeUsers": 893,
    "totalProducts": 47,
    "recentActivity": 23
  },
  "period": "last_30_days",
  "generatedAt": "2024-01-15T10:00:00Z"
}
```

## Caching
- Summary endpoint: cache for 5 minutes per org
- Chart data: cache for 1 hour
- Invalidate on relevant mutation events
