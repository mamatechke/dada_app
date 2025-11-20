# Migration Fix Instructions

## Issue
The migration failed because of a duplicate index on `user_profiles.user_id`.

## Fix Applied
Updated `20251120165300_create_user_profiles.rb` to use inline unique index instead of adding it separately.

## How to Proceed

### Option 1: Reset Database (RECOMMENDED for development)
```bash
# This will drop all tables and recreate from scratch
rails db:drop db:create db:migrate db:seed
```

### Option 2: Rollback Failed Migration
```bash
# Check migration status
rails db:migrate:status

# If user_profiles table partially exists, drop it manually:
rails console
# In console:
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS user_profiles")
exit

# Then retry migration
rails db:migrate db:seed
```

### Option 3: Skip Problem Migration (NOT RECOMMENDED)
```bash
# Mark the migration as completed without running it
# Only if the table already exists with correct structure
rails db:migrate:up VERSION=20251120165300
rails db:migrate
```

## Verify After Fix
```bash
# Check all tables exist
rails console
# In console:
ActiveRecord::Base.connection.tables
# Should include: user_profiles, circles, posts, contents, providers, nudges, saved_contents, conversations, messages

# Verify seed data loaded
Circle.count  # Should be 5
Content.count # Should be 5
Provider.count # Should be 3
Nudge.count   # Should be 4
```

## If Still Having Issues

The safest approach for development is:
```bash
# Complete fresh start
rm db/development.sqlite3
rm db/test.sqlite3
rails db:create db:migrate db:seed
```
