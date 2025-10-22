module Web
  class SharesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_share, only: [:edit, :update, :destroy]

    def index
      @shares = Share.public_shares.order(created_at: :desc)
    end

    def show
      @share = Share.find_by(id: params[:id])

      if @share.nil?
        redirect_to web_shares_path, alert: "Share not found."
      elsif @share.visibility == "private" && (!user_signed_in? || @share.user != current_user)
        redirect_to new_user_session_path, alert: "Please log in to view this content."
      end
    end

    def new
      @share = current_user.shares.build
    end

    def create
      @share = current_user.shares.build(share_params)
      if @share.save
        redirect_to web_profile_path, notice: "Share created!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @share.update(share_params)
        redirect_to web_profile_path, notice: "Share updated!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @share.destroy
      redirect_to web_profile_path, notice: "Share deleted."
    end

    private

    def set_share
      @share = current_user.shares.find(params[:id])
    end

    def share_params
    params.require(:share).permit(
      :share_type,
      :visibility,
      :title,
      :content,
      :image_urls,
      :video_url
    )
    end
  end
end
