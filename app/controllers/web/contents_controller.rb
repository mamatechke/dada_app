module Web
  class ContentsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :show]

    def index
      @contents = Content.published

      if user_signed_in?
        # Logged-in users see all published content (public + private)
      else
        # Anonymous users only see public content
        @contents = @contents.public_content
      end

      if params[:stage].present?
        @contents = @contents.for_stage(params[:stage])
      elsif user_signed_in? && current_user.user_profile&.stage.present?
        @contents = @contents.for_stage(current_user.user_profile.stage)
      end

      if params[:symptom].present?
        @contents = @contents.for_symptom(params[:symptom])
      end

      locale = user_signed_in? ? (current_user.user_profile&.locale || "en") : "en"
      @contents = @contents.for_locale(locale)
                          .recent
                          .limit(20)
    end

    def show
      @content = Content.find(params[:id])

      # Check if content is private and user is not logged in
      if @content.visibility == "private" && !user_signed_in?
        redirect_to new_user_session_path, alert: "Please sign in to access this content."
        return
      end

      @content.increment_view_count!
      @related_contents = Content.published
                                 .for_stage(@content.stage_tags&.first)
                                 .where.not(id: @content.id)
                                 .recent
                                 .limit(3)

      # Filter related content based on user authentication
      @related_contents = @related_contents.public_content unless user_signed_in?
    end

    def track_view
      @content = Content.find(params[:id])
      @content.increment_view_count!
      head :ok
    end
  end
end
