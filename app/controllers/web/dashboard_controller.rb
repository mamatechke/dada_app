module Web
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @profile = current_user.user_profile

      if @profile&.stage.present?
        @recommended_contents = Content.published
          .for_stage(@profile.stage)
          .for_locale(@profile.locale || "en")
          .recent
          .limit(6)

        @relevant_circles = Circle.for_stage(@profile.stage).by_activity.limit(4)
      else
        @recommended_contents = Content.published.for_locale("en").recent.limit(6)
        @relevant_circles = Circle.by_activity.limit(4)
      end

      @nearby_providers = if @profile&.country.present?
        Provider.verified.by_country(@profile.country).recent.limit(6)
      else
        Provider.verified.recent.limit(6)
      end

      @recent_posts = Post.recent.limit(5)
    end
  end
end
