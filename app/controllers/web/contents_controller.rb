module Web
  class ContentsController < ApplicationController
    before_action :authenticate_user!

    def index
      @contents = Content.published

      if params[:stage].present?
        @contents = @contents.for_stage(params[:stage])
      elsif current_user.user_profile&.stage.present?
        @contents = @contents.for_stage(current_user.user_profile.stage)
      end

      if params[:symptom].present?
        @contents = @contents.for_symptom(params[:symptom])
      end

      @contents = @contents.for_locale(current_user.user_profile&.locale || "en")
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
