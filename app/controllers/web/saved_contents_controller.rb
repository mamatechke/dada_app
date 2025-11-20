module Web
  class SavedContentsController < ApplicationController
    before_action :authenticate_user!

    def index
      @saved_contents = current_user.saved_content_items.recent.limit(50)
    end

    def create
      @content = Content.find(params[:content_id])
      @saved_content = current_user.saved_contents.build(content: @content)

      if @saved_content.save
        respond_to do |format|
          format.html { redirect_to web_content_path(@content), notice: "Content saved successfully!" }
          format.json { render json: { saved: true }, status: :created }
        end
      else
        respond_to do |format|
          format.html { redirect_to web_content_path(@content), alert: "Could not save content." }
          format.json { render json: { error: "Could not save" }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @saved_content = current_user.saved_contents.find(params[:id])
      @saved_content.destroy

      respond_to do |format|
        format.html { redirect_to web_saved_contents_path, notice: "Content removed from saved items." }
        format.json { render json: { saved: false }, status: :ok }
      end
    end
  end
end
