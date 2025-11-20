# Seed Admin User
puts "Creating Admin User..."
admin_user = User.find_or_initialize_by(email: "admin@dada.com")
if admin_user.new_record?
  admin_user.password = "admin123"
  admin_user.password_confirmation = "admin123"
  admin_user.role = :admin
  admin_user.save!
  puts "✅ Admin user created: admin@dada.com / admin123"
else
  admin_user.update(role: :admin) unless admin_user.admin?
  puts "✅ Admin user already exists"
end

# Seed Circles
puts "Creating Circles..."
circles_data = [
  { name: "Hot Flash Support", description: "Share tips and find solidarity during hot flashes", stage_focus: "Perimenopause" },
  { name: "Sleep Warriors", description: "Better rest is possible - let's figure it out together", stage_focus: "Perimenopause" },
  { name: "Menopause & Work", description: "Navigating career while managing symptoms", stage_focus: "Menopause" },
  { name: "Post-Menopause Wellness", description: "Thriving in this new chapter", stage_focus: "Post-menopause" },
  { name: "Supporting Our Sisters", description: "For allies who want to understand and help", stage_focus: "Ally" }
]

circles_data.each do |circle_attrs|
  Circle.find_or_create_by!(name: circle_attrs[:name]) do |circle|
    circle.description = circle_attrs[:description]
    circle.stage_focus = circle_attrs[:stage_focus]
  end
end

puts "Creating Contents..."
contents_data = [
  { title: "Understanding Hot Flashes", body: "Hot flashes are one of the most common symptoms...", content_type: "article", stage_tags: ["Perimenopause", "Menopause"], symptom_tags: ["Hot flashes"], published: true },
  { title: "Sleep Better During Menopause", body: "Quality sleep is essential for managing menopause symptoms...", content_type: "guide", stage_tags: ["Perimenopause", "Menopause"], symptom_tags: ["Trouble sleeping"], published: true },
  { title: "Managing Mood Changes", body: "Hormonal changes can affect your emotional wellbeing...", content_type: "article", stage_tags: ["Perimenopause"], symptom_tags: ["Mood changes", "Anxiety"], published: true },
  { title: "Nutrition for Menopause", body: "What you eat can make a real difference in how you feel...", content_type: "guide", stage_tags: ["General"], published: true },
  { title: "Exercise and Menopause", body: "Staying active helps manage symptoms and boost mood...", content_type: "article", stage_tags: ["General"], symptom_tags: ["Weight changes", "Joint pain"], published: true }
]

contents_data.each do |content_attrs|
  Content.find_or_create_by!(title: content_attrs[:title]) do |content|
    content.body = content_attrs[:body]
    content.content_type = content_attrs[:content_type]
    content.stage_tags = content_attrs[:stage_tags]
    content.symptom_tags = content_attrs[:symptom_tags]
    content.published = content_attrs[:published]
  end
end

puts "Creating Providers..."
providers_data = [
  { name: "Women's Health Clinic", category: "Healthcare", description: "Specialized menopause care", country: "Kenya", verified: true },
  { name: "Menopause Support Network", category: "Support Group", description: "Peer support and education", country: "South Africa", verified: true },
  { name: "Dr. Sarah Mwangi", category: "Specialist", description: "OB/GYN with menopause focus", country: "Kenya", verified: true }
]

providers_data.each do |provider_attrs|
  Provider.find_or_create_by!(name: provider_attrs[:name]) do |provider|
    provider.category = provider_attrs[:category]
    provider.description = provider_attrs[:description]
    provider.country = provider_attrs[:country]
    provider.verified = provider_attrs[:verified]
  end
end

puts "Creating Nudges..."
nudges_data = [
  { title: "💪 Stay Hydrated Today", body: "Drinking water helps manage hot flashes. Aim for 8 glasses!", nudge_type: "wellness_tip", stage_targets: ["Perimenopause", "Menopause"], symptom_targets: ["Hot flashes"], active: true, priority: 1 },
  { title: "🌙 Better Sleep Tonight", body: "Try keeping your bedroom cool and avoiding screens before bed.", nudge_type: "wellness_tip", stage_targets: ["Perimenopause"], symptom_targets: ["Trouble sleeping"], active: true, priority: 2 },
  { title: "💕 Join a Circle", body: "Connect with women going through similar experiences.", nudge_type: "circle_invite", stage_targets: ["Perimenopause", "Menopause", "Post-menopause"], cta_text: "Browse Circles", cta_url: "/web/circles", active: true, priority: 3 },
  { title: "📚 New Resource", body: "Check out our guide on managing mood changes naturally.", nudge_type: "resource_highlight", symptom_targets: ["Mood changes", "Anxiety"], cta_text: "Read Now", cta_url: "/web/contents", active: true, priority: 2 }
]

nudges_data.each do |nudge_attrs|
  Nudge.find_or_create_by!(title: nudge_attrs[:title]) do |nudge|
    nudge.body = nudge_attrs[:body]
    nudge.nudge_type = nudge_attrs[:nudge_type]
    nudge.stage_targets = nudge_attrs[:stage_targets]
    nudge.symptom_targets = nudge_attrs[:symptom_targets]
    nudge.cta_text = nudge_attrs[:cta_text]
    nudge.cta_url = nudge_attrs[:cta_url]
    nudge.active = nudge_attrs[:active]
    nudge.priority = nudge_attrs[:priority]
  end
end

puts "Creating Page Sections..."
page_sections_data = [
  {
    section_name: "hero",
    section_order: 1,
    active: true,
    content_data: {
      badge_text: "Culturally-Aware Menopause Support",
      headline: "Your Journey Through <span class='text-dada-primary'>Midlife</span> Deserves Support",
      description: "Dada offers personalized, culturally-rooted menopause guidance for African women and the diaspora. Discover insights powered by AI, connect through shared stories, and access resources designed to honor your lived experience.",
      feature_highlights: ["Culturally Relevant Content", "Personalised Guidance", "Community-Led Stories"]
    }
  },
  {
    section_name: "stories",
    section_order: 2,
    active: true,
    content_data: {
      section_title: "Real Women, Real <span class='text-dada-primary'>Journeys</span>",
      section_subtitle: "Discover how African women are navigating menopause with confidence, wisdom, and sisterhood support. Every story matters.",
      stories: [
        {
          emoji: "🌺",
          name: "Amara K.",
          location: "Lagos, Nigeria • Age 52 • Post-menopause",
          quote: "Finding sisterhood through Dada changed everything. I learned that my night sweats weren't just 'getting older' but a normal part of menopause that I could manage naturally.",
          tags: ["Night Sweats", "Natural Remedies", "Community"]
        },
        {
          emoji: "🦋",
          name: "Grace M.",
          location: "Nairobi, Kenya • Age 48 • Perimenopause",
          quote: "The AI chat helped me understand my irregular periods weren't something to worry about alone. Now I have strategies that fit my lifestyle and cultural practices.",
          tags: ["Irregular Periods", "Cultural Practices", "AI Support"]
        },
        {
          emoji: "🌻",
          name: "Fatou S.",
          location: "Accra, Ghana • Age 55 • Post-menopause",
          quote: "As a grandmother, I want to prepare my daughters. Dada gave me the language and knowledge to start these important conversations in our family.",
          tags: ["Family Conversations", "Intergenerational", "Education"]
        }
      ]
    }
  },
  {
    section_name: "resources",
    section_order: 3,
    active: true,
    content_data: {
      section_title: "Culturally‑Relevant <span class='text-dada-primary'>Resources</span>",
      section_subtitle: "Access curated content, expert guidance, and community resources tailored for African women's menopause journey.",
      resources: [
        {
          title: "Understanding Menopause in African Context",
          type: "Guide",
          tags: ["Cultural", "Traditional Medicine", "Symptoms"],
          description: "Comprehensive guide covering menopause symptoms, cultural perspectives, and traditional remedies from across Africa."
        },
        {
          title: "Managing Hot Flashes Naturally",
          type: "Video Series",
          tags: ["Hot Flashes", "Expert Advice", "Natural Remedies"],
          description: "Expert-led video series featuring African herbalists and doctors discussing natural approaches to hot flash management."
        }
      ]
    }
  },
  {
    section_name: "chatbot",
    section_order: 4,
    active: true,
    content_data: {
      section_title: "You're Not Alone on This Journey",
      section_subtitle: "Dada is here to walk beside you — offering culturally‑rooted wisdom, emotional support, and answers when you need them most.",
      demo_messages: [
        { sender: "user", text: "I'm feeling really tired all the time. Is this normal?" },
        { sender: "dada", text: "Hi Sis 💛 Feeling tired can be very normal during menopause. Let's explore if it's linked to hormonal shifts or sleep changes, okay?" },
        { sender: "dada", text: "Would you like tips on natural ways to boost your energy?" }
      ],
      suggested_prompts: [
        "What's causing my mood swings?",
        "Can I manage this naturally?",
        "Why are my periods changing?",
        "How do I talk to my daughter about this?"
      ]
    }
  }
]

page_sections_data.each do |section_attrs|
  PageSection.find_or_create_by!(section_name: section_attrs[:section_name]) do |section|
    section.section_order = section_attrs[:section_order]
    section.active = section_attrs[:active]
    section.content_data = section_attrs[:content_data]
  end
end

puts "✅ Seed data created successfully!"
