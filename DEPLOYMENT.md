# DADA Deployment Instructions for Render

## Prerequisites
- Render account
- Supabase project (already configured)
- PostgreSQL database URL from Supabase

## Environment Variables for Render

Add these environment variables in your Render dashboard:

1. **DATABASE_URL** (Required)
   ```
   postgres://[username]:[password]@[host]:[port]/[database]
   ```
   Get this from your Supabase project settings under Database > Connection string > URI

2. **RAILS_MASTER_KEY** (Required)
   Located in `config/master.key` file

3. **RAILS_ENV**
   ```
   production
   ```

4. **RAILS_SERVE_STATIC_FILES**
   ```
   true
   ```

5. **RAILS_LOG_TO_STDOUT**
   ```
   true
   ```

## Supabase Configuration

Your Supabase database already has these tables:
- `user_profiles`
- `contents`
- `circles`
- `posts`
- `providers`

Sample data has been seeded including:
- 5 community circles
- 5 educational content articles
- 10 verified providers in Kenya

## Build Command for Render
```bash
bundle install && bundle exec rake assets:precompile && bundle exec rake assets:clean
```

## Start Command for Render
```bash
bundle exec puma -C config/puma.rb
```

## Post-Deployment Checklist

1. Verify DATABASE_URL is set correctly
2. Check that users can sign up and log in
3. Test onboarding flow (all 5 steps)
4. Verify dashboard loads with seeded content
5. Test creating a post in a circle (anonymous posting)
6. Check content library and provider listings

## Troubleshooting

### Database Connection Issues
- Verify DATABASE_URL format is correct
- Ensure Supabase database is not paused
- Check that pg gem is installed

### Missing Content
- Run seed data SQL directly in Supabase SQL editor if content is missing
- Queries are available in the migration history

### Authentication Issues
- Verify RAILS_MASTER_KEY matches config/master.key
- Check Devise configuration in config/initializers/devise.rb
