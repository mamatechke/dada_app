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

puts "✅ Seed data created successfully!"
