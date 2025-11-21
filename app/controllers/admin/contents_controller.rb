module Admin
  class ContentsController < BaseController
    before_action :set_content, only: [ :show, :edit, :update, :destroy ]

    def index
      @contents = Content.order(created_at: :desc)

      # Filter by published status
      if params[:status].present?
        @contents = @contents.where(published: params[:status] == "published")
      end

      # Filter by content type
      if params[:content_type].present?
        @contents = @contents.where(content_type: params[:content_type])
      end

      # Search by title
      if params[:search].present?
        @contents = @contents.where("title LIKE ?", "%#{params[:search]}%")
      end

      @contents = @contents.page(params[:page]).per(20) if defined?(Kaminari)
    end

    def show
    end

    def new
      @content = Content.new
    end

    def create
      @content = Content.new(content_params)

      if @content.save
        redirect_to admin_contents_path, notice: "Content was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @content.update(content_params)
        redirect_to admin_contents_path, notice: "Content was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @content.destroy
      redirect_to admin_contents_path, notice: "Content was successfully deleted."
    end

    private

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(
        :title,
        :body,
        :content_type,
        :locale,
        :published,
        :visibility,
        stage_tags: [],
        symptom_tags: []
      )
    end
  end
end
