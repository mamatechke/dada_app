module Web
  class ProvidersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :show]

    def index
      @providers = Provider.verified

      if params[:category].present?
        @providers = @providers.by_category(params[:category])
      end

      if params[:country].present?
        @providers = @providers.by_country(params[:country])
      elsif user_signed_in? && current_user.user_profile&.country.present?
        @providers = @providers.by_country(current_user.user_profile.country)
      end

      @providers = @providers.recent
    end

    def show
      @provider = Provider.find(params[:id])
    end

    def track_contact
      @provider = Provider.find(params[:id])
      @provider.increment_contact_count!
      head :ok
    end
  end
end
