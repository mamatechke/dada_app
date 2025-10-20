class Web::ContentsController < ApplicationController
  class ContentsController < ApplicationController
    def index
      stage = params[:stage]

      # This assumes you have tags or categories on your content
      @contents = if stage.present?
           Content.tagged_with(stage)
      else
           Content.all
      end
    end
  end

  def show
  end
end
