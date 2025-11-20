# Thredded configuration
Thredded.user_class = "User"
Thredded.user_name_column = :email

# Use anonymous handles for display
Thredded.user_display_name_method = lambda do |user|
  user.user_profile&.anonymous_handle || "Anonymous#{user.id}"
end

# Moderators
Thredded.moderator_column = :role
Thredded.admin_column = :role

# Custom moderator check
Thredded.moderator? = lambda do |user|
  user && (user.moderator? || user.admin?)
end

# Custom admin check
Thredded.admin? = lambda do |user|
  user && user.admin?
end

# Email notifications (can be configured later)
Thredded.email_from = "noreply@dada.com"
Thredded.email_outgoing_prefix = "[DADA Circles]"

# Avatar display
Thredded.avatar_url = lambda do |user|
  # Return nil to use default letter avatars
  nil
end

# Layout
Thredded.layout = "application"
