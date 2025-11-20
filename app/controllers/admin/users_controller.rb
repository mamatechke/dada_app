module Admin
  class UsersController < BaseController
    before_action :set_user, only: [ :show, :edit, :update, :destroy ]

    def index
      @users = User.includes(:user_profile).order(created_at: :desc)

      if params[:role].present?
        @users = @users.where(role: params[:role])
      end

      if params[:search].present?
        @users = @users.where("email LIKE ?", "%#{params[:search]}%")
      end
    end

    def show
      @user_posts = @user.posts.includes(:circle).order(created_at: :desc).limit(10)
      @saved_contents = @user.saved_content_items.limit(10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete your own account."
        return
      end

      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully deleted."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
