class Web::CirclesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @circles = if user_signed_in? && current_user.user_profile&.stage.present?
      Circle.for_stage(current_user.user_profile.stage).by_activity
    else
      Circle.by_activity
    end
  end

  def show
    @circle = Circle.find(params[:id])
    @posts = @circle.posts.recent.limit(50)
    @new_post = Post.new if user_signed_in?
  end
end
