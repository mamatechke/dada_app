class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @page_sections = PageSection.active.by_order.index_by(&:section_name)
    @hero = @page_sections["hero"]
    @stories = @page_sections["stories"]
    @resources = @page_sections["resources"]
    @chatbot = @page_sections["chatbot"]
  end
end
