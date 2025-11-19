module Web
  class PostsController < ApplicationController
    before_action :authenticate_user!

    def create
      @circle = Circle.find(params[:circle_id])
      @post = @circle.posts.build(post_params)
      @post.user = current_user
      @post.anonymous_handle = current_user.user_profile&.anonymous_handle || "Anonymous#{rand(100..999)}"

      if @post.save
        redirect_to web_circle_path(@circle), notice: "Your post has been shared anonymously."
      else
        redirect_to web_circle_path(@circle), alert: "Unable to create post. Please try again."
      end
    end

    private

    def post_params
      params.require(:post).permit(:content)
    end
  end
end
