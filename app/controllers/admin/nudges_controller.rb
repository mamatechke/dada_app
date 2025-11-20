module Admin
  class NudgesController < BaseController
    before_action :set_nudge, only: [ :show, :edit, :update, :destroy ]

    def index
      @nudges = Nudge.order(priority: :asc, created_at: :desc)

      if params[:active].present?
        @nudges = @nudges.where(active: params[:active] == "true")
      end
    end

    def new
      @nudge = Nudge.new
    end

    def create
      @nudge = Nudge.new(nudge_params)

      if @nudge.save
        redirect_to admin_nudges_path, notice: "Nudge was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @nudge.update(nudge_params)
        redirect_to admin_nudges_path, notice: "Nudge was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @nudge.destroy
      redirect_to admin_nudges_path, notice: "Nudge was successfully deleted."
    end

    private

    def set_nudge
      @nudge = Nudge.find(params[:id])
    end

    def nudge_params
      params.require(:nudge).permit(
        :title,
        :body,
        :nudge_type,
        :cta_text,
        :cta_url,
        :priority,
        :active,
        stage_targets: [],
        symptom_targets: []
      )
    end
  end
end
