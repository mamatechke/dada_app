# Useful SQL Queries for DADA

Run these in the Supabase SQL Editor to manage and monitor your MVP.

## Check Data Counts

```sql
-- Count all records in each table
SELECT 'users' as table_name, COUNT(*) as count FROM user_profiles
UNION ALL
SELECT 'contents', COUNT(*) FROM contents
UNION ALL
SELECT 'circles', COUNT(*) FROM circles
UNION ALL
SELECT 'posts', COUNT(*) FROM posts
UNION ALL
SELECT 'providers', COUNT(*) FROM providers;
```

## User Analytics

```sql
-- Users by menopause stage
SELECT
  stage,
  COUNT(*) as user_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM user_profiles
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY user_count DESC;
```

```sql
-- Users by country
SELECT
  country,
  COUNT(*) as user_count
FROM user_profiles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY user_count DESC;
```

```sql
-- Most common symptoms
SELECT
  UNNEST(symptoms) as symptom,
  COUNT(*) as frequency
FROM user_profiles
WHERE symptoms IS NOT NULL AND symptoms != '{}'
GROUP BY symptom
ORDER BY frequency DESC;
```

## Content Performance

```sql
-- Most viewed content
SELECT
  title,
  content_type,
  view_count,
  stage_tags,
  created_at::date
FROM contents
ORDER BY view_count DESC
LIMIT 10;
```

```sql
-- Content by stage (shows which stages have most content)
SELECT
  UNNEST(stage_tags) as stage,
  COUNT(*) as article_count
FROM contents
WHERE published = true
GROUP BY stage
ORDER BY article_count DESC;
```

```sql
-- Average views per content type
SELECT
  content_type,
  COUNT(*) as total_articles,
  ROUND(AVG(view_count), 2) as avg_views,
  MAX(view_count) as max_views
FROM contents
GROUP BY content_type;
```

## Community Engagement

```sql
-- Active circles by post count
SELECT
  c.name,
  c.stage_focus,
  c.member_count,
  c.post_count,
  COUNT(p.id) as actual_post_count
FROM circles c
LEFT JOIN posts p ON p.circle_id = c.id
GROUP BY c.id, c.name, c.stage_focus, c.member_count, c.post_count
ORDER BY actual_post_count DESC;
```

```sql
-- Recent posts (last 7 days)
SELECT
  c.name as circle_name,
  p.anonymous_handle,
  LEFT(p.content, 50) || '...' as post_preview,
  p.likes_count,
  p.created_at
FROM posts p
JOIN circles c ON c.id = p.circle_id
WHERE p.created_at >= NOW() - INTERVAL '7 days'
ORDER BY p.created_at DESC;
```

```sql
-- Posts per user (engagement metric)
SELECT
  user_id,
  COUNT(*) as post_count,
  MIN(created_at) as first_post,
  MAX(created_at) as last_post
FROM posts
GROUP BY user_id
ORDER BY post_count DESC
LIMIT 20;
```

## Provider Marketplace

```sql
-- Providers by category
SELECT
  category,
  COUNT(*) as provider_count,
  COUNT(CASE WHEN verified = true THEN 1 END) as verified_count
FROM providers
GROUP BY category
ORDER BY provider_count DESC;
```

```sql
-- Most contacted providers
SELECT
  name,
  category,
  country,
  location,
  contact_count
FROM providers
ORDER BY contact_count DESC
LIMIT 10;
```

```sql
-- Providers by country
SELECT
  country,
  COUNT(*) as provider_count,
  STRING_AGG(DISTINCT category, ', ') as categories
FROM providers
GROUP BY country;
```

## Funnel Metrics

```sql
-- Onboarding completion rate
WITH users_with_profiles AS (
  SELECT COUNT(*) as completed
  FROM user_profiles
  WHERE stage IS NOT NULL
),
total_users AS (
  SELECT COUNT(*) as total
  FROM user_profiles
)
SELECT
  completed,
  total,
  ROUND(completed * 100.0 / NULLIF(total, 0), 2) as completion_rate
FROM users_with_profiles, total_users;
```

## Data Cleanup (Use with caution!)

```sql
-- Delete test posts (if needed)
DELETE FROM posts
WHERE content LIKE '%test%' OR content LIKE '%Test%';
```

```sql
-- Reset view counts (if needed for testing)
UPDATE contents SET view_count = 0;
```

```sql
-- Reset contact counts (if needed for testing)
UPDATE providers SET contact_count = 0;
```

## Add More Sample Data

```sql
-- Add more content
INSERT INTO contents (title, body, content_type, stage_tags, symptom_tags, locale, published, view_count)
VALUES
('Your Custom Title', 'Your content here...', 'article', ARRAY['Perimenopause'], ARRAY['Hot flashes'], 'en', true, 0);
```

```sql
-- Add more providers
INSERT INTO providers (name, category, location, country, description, contact_info, verified, contact_count)
VALUES
('Provider Name', 'Fitness & Movement', 'City', 'Kenya', 'Description here', 'Contact info', true, 0);
```

```sql
-- Add more circles
INSERT INTO circles (name, description, stage_focus, member_count, post_count)
VALUES
('Circle Name', 'Description', 'Menopause', 0, 0);
```

## Monitoring Queries (Run Daily)

```sql
-- Daily activity snapshot
SELECT
  DATE(created_at) as date,
  COUNT(*) as new_posts
FROM posts
WHERE created_at >= NOW() - INTERVAL '7 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

```sql
-- Content engagement this week
SELECT
  title,
  view_count - LAG(view_count, 1, 0) OVER (PARTITION BY id ORDER BY updated_at) as views_gained
FROM contents
WHERE updated_at >= NOW() - INTERVAL '7 days'
ORDER BY views_gained DESC
LIMIT 10;
```

## Export Data (for analysis)

```sql
-- Export user profiles
COPY (
  SELECT
    id,
    stage,
    country,
    locale,
    symptoms,
    created_at
  FROM user_profiles
) TO STDOUT WITH CSV HEADER;
```

## Tips

1. Run the "Check Data Counts" query daily to monitor growth
2. Use "Funnel Metrics" to track onboarding success
3. Monitor "Most viewed content" to understand what resonates
4. Check "Active circles" to see where community is building
5. Track "Most contacted providers" to validate marketplace demand

## Setting Up Scheduled Reports

You can use Supabase SQL Editor saved queries or set up external tools like:
- Metabase (connects to Supabase)
- Google Sheets with PostgreSQL connector
- Custom dashboard with your favorite BI tool
