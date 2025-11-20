module Admin
  class PageSectionsController < BaseController
    before_action :set_page_section, only: [ :edit, :update ]

    def index
      @page_sections = PageSection.by_order
    end

    def edit
      # Edit view will be section-specific based on section_name
    end

    def update
      # Process content_data based on section type
      content_data = process_content_data(@page_section.section_name, params[:page_section][:content_data])

      if @page_section.update(page_section_params.merge(content_data: content_data, updated_by_id: current_user.id))
        redirect_to admin_page_sections_path, notice: "Page section was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_page_section
      @page_section = PageSection.find(params[:id])
    end

    def page_section_params
      params.require(:page_section).permit(:active, :section_order)
    end

    def process_content_data(section_name, raw_data)
      case section_name
      when "hero"
        {
          badge_text: raw_data[:badge_text],
          headline: raw_data[:headline],
          description: raw_data[:description],
          feature_highlights: raw_data[:feature_highlights].to_s.split("\n").map(&:strip).reject(&:blank?)
        }
      when "stories"
        {
          section_title: raw_data[:section_title],
          section_subtitle: raw_data[:section_subtitle],
          stories: parse_json_field(raw_data[:stories])
        }
      when "resources"
        {
          section_title: raw_data[:section_title],
          section_subtitle: raw_data[:section_subtitle],
          resources: parse_json_field(raw_data[:resources])
        }
      when "chatbot"
        {
          section_title: raw_data[:section_title],
          section_subtitle: raw_data[:section_subtitle],
          demo_messages: parse_json_field(raw_data[:demo_messages]),
          suggested_prompts: raw_data[:suggested_prompts].to_s.split("\n").map(&:strip).reject(&:blank?)
        }
      else
        raw_data
      end
    end

    def parse_json_field(field_value)
      return [] if field_value.blank?
      JSON.parse(field_value)
    rescue JSON::ParserError
      []
    end
  end
end
