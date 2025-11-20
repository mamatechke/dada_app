module Web
  class ContentsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :show]

    def index
      @contents = Content.published

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
      @content.increment_view_count!
      @related_contents = Content.published
                                 .for_stage(@content.stage_tags&.first)
                                 .where.not(id: @content.id)
                                 .recent
                                 .limit(3)
    end

    def track_view
      @content = Content.find(params[:id])
      @content.increment_view_count!
      head :ok
    end
  end
end
