class Content < ApplicationRecord
  self.table_name = "contents"
  self.primary_key = "id"

  scope :published, -> { where(published: true) }
  scope :for_stage, ->(stage) { where("? = ANY(stage_tags)", stage) if stage.present? }
  scope :for_symptom, ->(symptom) { where("? = ANY(symptom_tags)", symptom) if symptom.present? }
  scope :for_locale, ->(locale) { where(locale: locale || "en") }
  scope :recent, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :body, presence: true

  CONTENT_TYPES = ["article", "video", "guide", "tip"].freeze
  STAGES = ["Perimenopause", "Menopause", "Post-menopause", "General", "Ally"].freeze
  SYMPTOMS = [
    "Hot flashes", "Trouble sleeping", "Mood changes", "Anxiety",
    "Brain fog", "Irregular periods", "Vaginal dryness", "Low libido",
    "Weight changes", "Joint pain"
  ].freeze

  def increment_view_count!
    increment!(:view_count)
  end
end
