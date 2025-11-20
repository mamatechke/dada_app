class DadaAiService
  SYSTEM_PROMPT = <<~PROMPT
    You are DADA, a compassionate menopause companion for African women. You provide:
    - Culturally-sensitive guidance rooted in African traditions
    - Empathetic support with warmth and understanding
    - Evidence-based menopause information
    - Connection to community and resources

    Your tone is warm, sisterly, and empowering. You use "Sis" affectionately.
    Keep responses concise (2-3 paragraphs) and actionable.
  PROMPT

  def initialize(conversation)
    @conversation = conversation
  end

  def send_message(user_input)
    @conversation.messages.create!(role: "user", content: user_input)

    context = build_context
    response = generate_response(context, user_input)

    @conversation.messages.create!(role: "assistant", content: response)

    response
  rescue StandardError => e
    Rails.logger.error("DADA AI Error: #{e.message}")
    fallback_response
  end

  private

  def build_context
    recent_messages = @conversation.messages.recent.last(10)

    recent_messages.map do |msg|
      { role: msg.role, content: msg.content }
    end
  end

  def generate_response(context, user_input)
    if ENV["OPENAI_API_KEY"].present?
      generate_openai_response(context, user_input)
    else
      generate_rule_based_response(user_input)
    end
  end

  def generate_openai_response(context, user_input)
    client = RubyLlm.create_client(:openai, api_key: ENV["OPENAI_API_KEY"])

    messages = [
      { role: "system", content: SYSTEM_PROMPT },
      *context
    ]

    response = client.chat(
      model: "gpt-3.5-turbo",
      messages: messages,
      temperature: 0.7,
      max_tokens: 300
    )

    response.dig("choices", 0, "message", "content") || fallback_response
  rescue StandardError => e
    Rails.logger.error("OpenAI Error: #{e.message}")
    generate_rule_based_response(user_input)
  end

  def generate_rule_based_response(user_input)
    input_lower = user_input.downcase

    if input_lower.include?("hot flash") || input_lower.include?("hot flush")
      "Hi Sis 💛 Hot flashes are very common during menopause. Try keeping cool water nearby, dressing in layers, and avoiding triggers like spicy foods. Would you like tips on natural remedies?"
    elsif input_lower.include?("sleep") || input_lower.include?("insomnia")
      "Sleep troubles are so frustrating, Sis. Try keeping your bedroom cool, avoiding screens an hour before bed, and establishing a calming bedtime routine. Herbal teas like chamomile can help too!"
    elsif input_lower.include?("mood") || input_lower.include?("anxiety") || input_lower.include?("depress")
      "Your feelings are completely valid, Sis 💕 Hormonal changes can really affect our emotions. Regular exercise, connecting with other women, and talking to someone you trust can help. You're not alone in this!"
    elsif input_lower.include?("weight") || input_lower.include?("exercise")
      "Staying active is wonderful, Sis! Even 20-30 minutes of walking daily can help manage symptoms and boost your mood. Strength training is also great for bone health during menopause."
    else
      "Thank you for sharing, Sis 💛 I'm here to support you through your menopause journey. Feel free to ask me about symptoms, wellness tips, or finding resources. What's most on your mind today?"
    end
  end

  def fallback_response
    "I'm here for you, Sis 💛 I'm having a little trouble right now, but I'm always ready to support you. Try asking me about hot flashes, sleep, mood changes, or exercise during menopause!"
  end
end
