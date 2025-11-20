class Web::ChatbotController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :authenticate_user!, only: [:send_message]

  def index
    @preview_mode = !user_signed_in?

    if user_signed_in?
      @conversation = current_user.conversations.last || current_user.conversations.create!
      @messages = @conversation.messages.recent
    end
  end

  def send_message
    @conversation = current_user.conversations.last || current_user.conversations.create!
    user_input = params[:message]

    if user_input.blank?
      render json: { error: "Message cannot be empty" }, status: :unprocessable_entity
      return
    end

    ai_service = DadaAiService.new(@conversation)
    response = ai_service.send_message(user_input)

    render json: {
      user_message: user_input,
      assistant_message: response
    }
  rescue StandardError => e
    Rails.logger.error("Chatbot Error: #{e.message}")
    render json: { error: "Something went wrong" }, status: :internal_server_error
  end
end

