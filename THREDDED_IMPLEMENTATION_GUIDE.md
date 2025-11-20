# Thredded Implementation Guide

## Overview

This guide explains how to complete the Thredded installation to replace the custom circles implementation with a battle-tested forum solution that includes built-in moderation.

## What Has Been Prepared

### ✅ Completed

1. **Gemfile Updated**: Added `gem "thredded", "~> 1.0"`
2. **Thredded Configuration**: Created `config/initializers/thredded.rb` with:
   - User class configuration
   - Anonymous display name handling
   - Moderator and admin permissions
   - Email settings
   - Layout integration
3. **Routes Prepared**: Added comments in `config/routes.rb` with mounting instructions

## Installation Steps

### Step 1: Install Dependencies

```bash
bundle install
```

This will install Thredded and all its dependencies.

### Step 2: Run Thredded Generator

```bash
rails generate thredded:install
```

This generator will:
- Create Thredded migrations
- Create initializer files (we already have one, so you can keep ours or merge)
- Set up views for customization
- Create seed data

Answer "yes" when prompted to run migrations.

### Step 3: Run Database Migrations

```bash
rails db:migrate
```

This will create all Thredded tables:
- `thredded_messageboards` (your "circles")
- `thredded_topics` (discussion threads)
- `thredded_posts` (individual posts)
- `thredded_users` (user forum data)
- Plus moderation and notification tables

### Step 4: Mount Thredded Routes

In `config/routes.rb`, find this line:

```ruby
# mount Thredded::Engine => '/circles'
```

Uncomment it:

```ruby
mount Thredded::Engine => '/circles'
```

### Step 5: Comment Out Custom Circles Routes

In the same file, comment out the custom circles routes:

```ruby
# namespace :web do
#   resources :circles, only: [ :index, :show ] do
#     resources :posts, only: [ :create ]
#   end
# end
```

### Step 6: Seed Thredded Messageboards

Create messageboards (circles) to replace your custom ones. Add to `db/seeds.rb`:

```ruby
puts "Creating Thredded Messageboards (Circles)..."
circles_data = [
  { name: "Hot Flash Support", description: "Share tips and find solidarity during hot flashes" },
  { name: "Sleep Warriors", description: "Better rest is possible - let's figure it out together" },
  { name: "Menopause & Work", description: "Navigating career while managing symptoms" },
  { name: "Post-Menopause Wellness", description: "Thriving in this new chapter" },
  { name: "Supporting Our Sisters", description: "For allies who want to understand and help" }
]

circles_data.each do |circle_attrs|
  Thredded::Messageboard.find_or_create_by!(name: circle_attrs[:name]) do |mb|
    mb.description = circle_attrs[:description]
  end
end
```

Then run:

```bash
rails db:seed
```

### Step 7: Remove Custom Circles Implementation

After Thredded is working, remove these files:

```bash
rm app/models/circle.rb
rm app/models/post.rb
rm app/controllers/web/circles_controller.rb
rm app/controllers/web/posts_controller.rb
rm -r app/views/web/circles/
```

Remove these migrations (after Thredded migrations are run):

```bash
rm db/migrate/*_create_circles.rb
rm db/migrate/*_create_posts.rb
```

## Customization

### Styling Thredded to Match DADA

Thredded uses its own views which you can customize. After running the generator, Thredded views will be in:

```
app/views/thredded/
```

#### Option 1: Customize Thredded Views

Edit the generated views to use DADA's Tailwind classes:

```
app/views/thredded/
├── messageboards/
│   ├── index.html.erb          # List of all circles
│   └── show.html.erb           # Single circle with topics
├── topics/
│   ├── index.html.erb          # List of topics in a circle
│   ├── show.html.erb           # Single topic with posts
│   └── new.html.erb            # Create new topic form
└── posts/
    ├── _post.html.erb          # Single post display
    └── _form.html.erb          # Post/reply form
```

Replace Thredded's default CSS classes with DADA Tailwind classes:
- `bg-dada-background` instead of default backgrounds
- `text-dada-primary` for primary actions
- `text-dada-text dark:text-white` for text
- `bg-white dark:bg-zinc-800` for cards

#### Option 2: Add Custom CSS

Create `app/assets/stylesheets/thredded_overrides.css`:

```css
/* Thredded DADA Theme Overrides */
.thredded--main-section {
  @apply bg-dada-background dark:bg-dada-darkBg;
}

.thredded--messageboard-group {
  @apply bg-white dark:bg-zinc-800 rounded-lg shadow;
}

.thredded--post {
  @apply bg-white dark:bg-zinc-800 rounded-lg p-6 mb-4;
}

.thredded--button {
  @apply bg-dada-primary hover:bg-dada-accent text-white font-semibold px-4 py-2 rounded-lg transition;
}
```

### Anonymous Display Names

Thredded is configured to show anonymous handles from `user.user_profile.anonymous_handle`.

The configuration in `config/initializers/thredded.rb`:

```ruby
Thredded.user_display_name_method = lambda do |user|
  user.user_profile&.anonymous_handle || "Anonymous#{user.id}"
end
```

This means:
- Users will see their `anonymous_handle` instead of email
- If no handle exists, shows "Anonymous123" format
- User identity remains protected

### Moderation Setup

Thredded includes built-in moderation features. The configuration uses your existing role system:

```ruby
Thredded.moderator? = lambda do |user|
  user && (user.moderator? || user.admin?)
end
```

#### Moderator Capabilities

Users with `moderator` or `admin` role can:
- Edit any post
- Delete any post
- Lock/unlock topics
- Pin/unpin topics
- Move topics between messageboards
- Ban users from specific messageboards

#### Access Moderation Panel

Moderators see additional controls on posts:
- **Edit** button on any post
- **Delete** button on any post
- **Moderate** menu with advanced actions

#### Moderation Actions Available

1. **Lock Topic**: Prevents new replies
2. **Pin Topic**: Keeps topic at top of list
3. **Move Topic**: Transfer to different messageboard
4. **Delete Post**: Remove permanently (soft delete available)
5. **Ban User**: Prevent user from posting in messageboard

### Moderation Dashboard

Create a custom admin moderation view at `app/views/admin/moderation/index.html.erb`:

```erb
<h1>Moderation Dashboard</h1>

<%= link_to "View All Posts", thredded.moderation_posts_path %>
<%= link_to "Reported Posts", thredded.moderation_posts_path(filter: 'reported') %>
<%= link_to "Manage Users", admin_users_path %>
```

### Post Reporting

Thredded includes a built-in reporting system:

1. **Users Can Report Posts**: Click "Report" button on any post
2. **Moderators Get Notified**: Via email (configure in initializer)
3. **Review Reports**: In moderation panel

To customize reporting, edit:
- `app/views/thredded/posts/_report_form.html.erb`
- Report reasons in `config/initializers/thredded.rb`

## Testing the Installation

### 1. Access Circles

Navigate to: `http://localhost:3000/circles`

You should see the list of messageboards (circles).

### 2. Create a Topic

Click on a circle, then "New Topic" button.

### 3. Post Anonymously

Verify that your `anonymous_handle` is displayed instead of your email.

### 4. Test Moderation (as Admin)

Login as admin and verify you can:
- Edit any post
- Delete posts
- Lock topics
- Pin topics

### 5. Test Reporting

As a regular user, click "Report" on a post and submit a report.

## Troubleshooting

### Issue: Thredded shows email instead of anonymous handle

**Solution**: Check that:
1. User has a `user_profile` with `anonymous_handle`
2. Initializer is correctly configured
3. Server was restarted after changing initializer

### Issue: Moderation controls not showing

**Solution**: Check that:
1. User role is `moderator` or `admin`
2. `Thredded.moderator?` lambda is configured
3. User is logged in

### Issue: Routes conflict

**Solution**: Ensure:
1. Custom circles routes are commented out
2. Thredded mount comes BEFORE web namespace
3. Server was restarted

### Issue: Styling looks wrong

**Solution**:
1. Generate Thredded views: `rails generate thredded:views`
2. Edit views to use Tailwind classes
3. Add custom CSS overrides
4. Clear browser cache

## Next Steps After Installation

1. **Customize Views**: Edit Thredded views to match DADA design perfectly
2. **Add Email Notifications**: Configure Thredded email settings for post notifications
3. **Setup Moderation Workflow**: Define guidelines for moderators
4. **Add Analytics**: Track engagement in circles
5. **Create Welcome Topics**: Seed initial topics in each circle to encourage participation

## Database Schema

### Thredded Tables Created

```
thredded_messageboards          # Your "circles"
thredded_messageboard_users     # User memberships
thredded_topics                 # Discussion threads
thredded_posts                  # Individual posts
thredded_user_details           # User forum preferences
thredded_user_post_notifications
thredded_user_messageboard_preferences
thredded_messageboard_groups    # For organizing circles
thredded_user_topic_follows     # Topic subscriptions
thredded_user_topic_read_states # Track what user has read
thredded_post_moderation_records # Moderation history
```

### Custom Tables to Remove

After Thredded is installed and working:

```
circles                         # Remove
posts                           # Remove
```

## Configuration Reference

### Key Configuration Options

Located in `config/initializers/thredded.rb`:

```ruby
# User integration
Thredded.user_class = "User"
Thredded.user_name_column = :email

# Display name (anonymous)
Thredded.user_display_name_method = lambda do |user|
  user.user_profile&.anonymous_handle || "Anonymous#{user.id}"
end

# Permissions
Thredded.moderator? = lambda { |user| user&.moderator? }
Thredded.admin? = lambda { |user| user&.admin? }

# Email
Thredded.email_from = "noreply@dada.com"
Thredded.email_outgoing_prefix = "[DADA Circles]"

# Notifications (enable if desired)
Thredded.notifiers = [
  Thredded::EmailNotifier.new,
  # Thredded::ActivityNotifier.new (for in-app notifications)
]

# Layout
Thredded.layout = "application"

# Avatars
Thredded.avatar_url = lambda { |user| nil } # Uses letter avatars
```

## Summary

Thredded provides:
- ✅ Battle-tested forum software
- ✅ Built-in moderation tools
- ✅ Anonymous posting support
- ✅ Email notifications
- ✅ Post reporting system
- ✅ User preferences
- ✅ Topic subscriptions
- ✅ Read/unread tracking
- ✅ Mobile-responsive design

This replaces your custom circles implementation with a more robust, feature-complete solution that's actively maintained and includes everything needed for safe, moderated community discussions.
