module Admin
  class ProvidersController < BaseController
    before_action :set_provider, only: [ :show, :edit, :update, :destroy ]

    def index
      @providers = Provider.order(created_at: :desc)

      if params[:verified].present?
        @providers = @providers.where(verified: params[:verified] == "true")
      end

      if params[:country].present?
        @providers = @providers.where(country: params[:country])
      end

      if params[:search].present?
        @providers = @providers.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
    end

    def new
      @provider = Provider.new
    end

    def create
      @provider = Provider.new(provider_params)

      if @provider.save
        redirect_to admin_providers_path, notice: "Provider was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @provider.update(provider_params)
        redirect_to admin_providers_path, notice: "Provider was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @provider.destroy
      redirect_to admin_providers_path, notice: "Provider was successfully deleted."
    end

    private

    def set_provider
      @provider = Provider.find(params[:id])
    end

    def provider_params
      params.require(:provider).permit(:name, :category, :description, :location, :country, :phone, :email, :website, :verified)
    end
  end
end
