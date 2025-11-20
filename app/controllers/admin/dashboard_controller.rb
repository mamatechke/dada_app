module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        users_count: User.count,
        contents_count: Content.count,
        circles_count: Circle.count,
        posts_count: Post.count,
        providers_count: Provider.count
      }

      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_posts = Post.includes(:circle, :user).order(created_at: :desc).limit(10)
      @recent_contents = Content.order(created_at: :desc).limit(5)
    end
  end
end
