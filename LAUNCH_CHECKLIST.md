# DADA MVP - Launch Checklist

## Pre-Deployment Setup (Do This First)

### 1. Render Environment Variables
In your Render dashboard, add these environment variables:

- [ ] **DATABASE_URL**
  - Go to Supabase → Project Settings → Database → Connection String
  - Copy the "URI" format (starts with `postgres://`)
  - Replace `[YOUR-PASSWORD]` with your actual database password

- [ ] **RAILS_MASTER_KEY**
  - Located in `config/master.key` in your local project
  - Copy the entire key (should be a long string)

- [ ] **RAILS_ENV** = `production`
- [ ] **RAILS_SERVE_STATIC_FILES** = `true`
- [ ] **RAILS_LOG_TO_STDOUT** = `true`

### 2. Update Gemfile.lock
- [ ] Commit the updated Gemfile (pg gem added)
- [ ] Push to GitHub
- [ ] Render will automatically install dependencies

## Post-Deployment Testing

### Test 1: User Registration & Onboarding
- [ ] Go to https://dada-app.onrender.com/
- [ ] Click "Sign Up"
- [ ] Create a new account
- [ ] Complete all 5 onboarding steps:
  - Step 1: Welcome
  - Step 2: Select stage (try "Perimenopause")
  - Step 3: Select symptoms (pick 2-3)
  - Step 4: Select country (Kenya)
  - Step 5: Review and submit
- [ ] Verify you land on the dashboard
- [ ] Check that dashboard shows your stage at the top

### Test 2: Dashboard
- [ ] Dashboard displays "Content Library", "Community Circles", "Verified Providers" stats
- [ ] "For You" section shows relevant articles
- [ ] "Community" section shows relevant circles
- [ ] "Verified Providers Near You" shows Kenya providers
- [ ] All links work correctly

### Test 3: Content Library
- [ ] Click "Content" in navbar
- [ ] Verify 5 articles are displayed
- [ ] Click on "Understanding Hot Flashes" article
- [ ] Article displays correctly with full text
- [ ] Click back and try filtering by "Perimenopause"
- [ ] Related content appears at bottom of article page

### Test 4: Community Circles
- [ ] Click "Circles" in navbar
- [ ] Verify 5 circles are displayed
- [ ] Click on "Perimenopause Support" circle
- [ ] Post form appears at top
- [ ] Create a test post (e.g., "This is a test post")
- [ ] Click "Post Anonymously"
- [ ] Post appears in feed with anonymous handle (e.g., "WiseSunflower742")
- [ ] No real email or name displayed

### Test 5: Provider Marketplace
- [ ] Click "Providers" in navbar
- [ ] Verify 10 providers are displayed
- [ ] All have "Verified" badges
- [ ] Click on "Dr. Amina Odhiambo"
- [ ] Provider profile displays with contact info
- [ ] Try filtering by "Mental Health" category
- [ ] Relevant providers appear

### Test 6: Navigation
- [ ] Click "Dashboard" to return to home
- [ ] Click profile avatar in navbar
- [ ] Profile page loads (may show shares)
- [ ] Click "Sign Out" from mobile menu
- [ ] Redirects to marketing home page
- [ ] Log back in
- [ ] Automatically redirects to dashboard

## Data Verification

### Supabase Database
- [ ] Login to Supabase dashboard
- [ ] Go to Table Editor
- [ ] Check `user_profiles` table has your test user
- [ ] Verify `anonymous_handle` was generated
- [ ] Check `stage`, `symptoms`, `country` are saved
- [ ] Check `posts` table has your test post
- [ ] Verify `contents` table has 5 articles
- [ ] Verify `circles` table has 5 circles
- [ ] Verify `providers` table has 10 providers

## Common Issues & Fixes

### Issue: "ActiveRecord::NoDatabaseError"
**Fix**: DATABASE_URL environment variable not set in Render
- Go to Render → Environment → Add DATABASE_URL

### Issue: "Secret key base is not set"
**Fix**: RAILS_MASTER_KEY environment variable not set
- Go to Render → Environment → Add RAILS_MASTER_KEY

### Issue: "Could not find table 'contents'"
**Fix**: Database tables not created in Supabase
- Go to Supabase SQL Editor
- Re-run the seed SQL queries from DEPLOYMENT.md

### Issue: No content/circles/providers showing
**Fix**: Seed data not loaded
- Go to Supabase SQL Editor
- Run the INSERT statements from the implementation

### Issue: "Undefined method 'page'"
**Fix**: Already handled - pagination removed

### Issue: Dark mode not working
**Fix**: Browser issue - try hard refresh (Ctrl+Shift+R)

## Success Criteria ✅

You're ready for user testing when:

- [ ] Users can sign up and complete onboarding
- [ ] Dashboard shows personalized content
- [ ] Users can browse and read 5+ articles
- [ ] Users can join circles and post anonymously
- [ ] Users can browse and view provider profiles
- [ ] All navigation links work
- [ ] Mobile responsive on phone screen
- [ ] No console errors in browser
- [ ] No 500 errors in Render logs

## Metrics to Track (After Launch)

Week 1 Goals:
- 10-20 signups
- 60%+ onboarding completion rate
- 5+ posts in circles
- 50+ content views
- 10+ provider profile views

Log in to Supabase to run these queries:

```sql
-- Total users
SELECT COUNT(*) FROM user_profiles;

-- Onboarding completion by stage
SELECT stage, COUNT(*) FROM user_profiles GROUP BY stage;

-- Most viewed content
SELECT title, view_count FROM contents ORDER BY view_count DESC LIMIT 5;

-- Posts per circle
SELECT c.name, COUNT(p.id) as post_count
FROM circles c
LEFT JOIN posts p ON p.circle_id = c.id
GROUP BY c.name;

-- Provider contact tracking
SELECT name, category, contact_count
FROM providers
ORDER BY contact_count DESC
LIMIT 5;
```

## Ready to Launch? 🚀

Once all checkboxes above are ticked, you're ready to:

1. Share the link with your first beta testers
2. Get feedback on the user journey
3. Monitor Supabase for usage patterns
4. Iterate based on real user data

**Next MVP Phase**: Heart Nudges, AI chatbot, payment integration
