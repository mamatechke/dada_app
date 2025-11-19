# DADA Deployment Instructions for Render

## ✅ Deployment Fix Applied

**Issue Fixed:** The npm error has been resolved by adding:
- `Procfile` for Render
- `package.json` to satisfy npm requirement
- `bin/render-build.sh` build script
- `render.yaml` configuration

**See `RENDER_DEPLOYMENT.md` for detailed step-by-step instructions.**

## Quick Setup

### 1. Environment Variables

Add these in your Render dashboard:

**DATABASE_URL** (Required)
```
postgresql://postgres.[project-ref]:[password]@[host].supabase.com:6543/postgres
```
Get from Supabase Dashboard → Project Settings → Database → Connection String (Session pooler)

**RAILS_MASTER_KEY** (Required)
Located in `config/master.key` file

**RAILS_ENV**
```
production
```

**RACK_ENV**
```
production
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

### 2. Build & Deploy Commands

**Build Command:**
```bash
./bin/render-build.sh
```

**Start Command:**
```bash
bundle exec puma -C config/puma.rb
```

Or use the included `render.yaml` file for automatic configuration.

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
