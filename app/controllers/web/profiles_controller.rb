module Web
  class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def show
      @user = current_user
      @shares = current_user.shares.order(created_at: :desc)
    end
  end
end
