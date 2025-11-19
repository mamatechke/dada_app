# Render Deployment Instructions

## Quick Fix Applied ✅

I've fixed the deployment error by creating:
1. `Procfile` - Tells Render how to start the app
2. `package.json` - Satisfies npm requirement (empty)
3. `bin/render-build.sh` - Build script for Render
4. `render.yaml` - Render service configuration

## Render Dashboard Setup

### 1. Build & Deploy Settings

In your Render dashboard for the DADA app, configure:

**Build Command:**
```bash
./bin/render-build.sh
```

**Start Command:**
```bash
bundle exec puma -C config/puma.rb
```

### 2. Environment Variables

Set these in the Render dashboard under "Environment":

#### Required Variables

**DATABASE_URL**
```
Format: postgresql://postgres.[project-ref]:[password]@[host].supabase.com:6543/postgres

Get from Supabase Dashboard:
1. Go to Project Settings → Database
2. Copy "Connection string" and choose "Session pooler"
3. Replace [password] with your database password

Example:
postgresql://postgres.wuorcehxjfsjjbphbltd:your-password-here@aws-0-us-west-1.pooler.supabase.com:6543/postgres
```

**RAILS_MASTER_KEY**
```
Get from: config/master.key in your project
This is a secret key - keep it secure!
```

**RAILS_ENV**
```
production
```

**RACK_ENV**
```
production
```

### 3. Deploy

After setting environment variables:
1. Click "Manual Deploy" → "Deploy latest commit"
2. Watch the build logs
3. Wait for deployment to complete (~5-10 minutes)

## Expected Build Process

You should see these steps in the logs:

```
==> Building...
==> Running build command './bin/render-build.sh'
    - bundle install
    - bundle exec rake assets:precompile
    - bundle exec rake assets:clean
==> Build successful!
==> Deploying...
==> Starting: bundle exec puma -C config/puma.rb
```

## Troubleshooting

### If build fails with "bundle not found"
- Render should auto-detect Ruby and install bundler
- Check Ruby version in `.ruby-version` matches Render's Ruby

### If database connection fails
- Verify DATABASE_URL format is correct
- Check Supabase allows connections (no IP restrictions)
- Test connection string in Supabase dashboard

### If assets fail to compile
- Check for missing Tailwind CSS configuration
- Verify `tailwindcss-rails` gem is installed
- Check Rails asset pipeline is configured

### If app starts but pages error
- Check RAILS_MASTER_KEY is correct
- Verify all environment variables are set
- Check Render logs for specific errors

## Verify Deployment

Once deployed successfully:

1. Visit your Render URL (e.g., https://dada-app.onrender.com)
2. Homepage should load
3. Try signing up for a new account
4. Complete onboarding
5. Check dashboard loads with data

## Post-Deployment

### Check Database Connection
In Render dashboard, open Shell and run:
```bash
rails runner "puts ActiveRecord::Base.connection.execute('SELECT 1').to_a"
```

Should output: `[{"?column?"=>1}]`

### Verify Supabase Data
In Render shell:
```bash
rails runner "puts Content.count"
rails runner "puts Circle.count"
rails runner "puts Provider.count"
```

Should show:
- Contents: 11
- Circles: 10
- Providers: 17

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "npm not found" | ✅ Fixed with package.json |
| "Procfile missing" | ✅ Fixed with Procfile |
| "Build command failed" | Use `./bin/render-build.sh` |
| "Database connection failed" | Check DATABASE_URL format |
| "Assets not loading" | Run `rake assets:precompile` |
| "500 error on pages" | Check RAILS_MASTER_KEY |

## Next Steps After Successful Deploy

1. ✅ Test complete user signup flow
2. ✅ Verify onboarding saves data
3. ✅ Check all pages load correctly
4. ✅ Test on mobile device
5. ✅ Invite beta testers

## Need More Help?

- Check Render logs: Dashboard → Logs tab
- Check Supabase logs: Supabase Dashboard → Database → Logs
- Review Rails logs in Render shell: `tail log/production.log`

---

**You're now ready to deploy!** 🚀

Commit and push these changes, then trigger a new deployment in Render.
