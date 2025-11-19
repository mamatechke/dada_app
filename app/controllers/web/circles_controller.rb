class Web::CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @circles = if current_user.user_profile&.stage.present?
      Circle.for_stage(current_user.user_profile.stage).by_activity
    else
      Circle.by_activity
    end
  end

  def show
    @circle = Circle.find(params[:id])
    @posts = @circle.posts.recent.limit(50)
    @new_post = Post.new
  end
end
