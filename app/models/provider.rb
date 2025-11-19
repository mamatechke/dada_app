class Provider < ApplicationRecord
  self.table_name = "providers"
  self.primary_key = "id"

  validates :name, presence: true
  validates :category, presence: true

  scope :verified, -> { where(verified: true) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_country, ->(country) { where(country: country) if country.present? }
  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") if location.present? }
  scope :recent, -> { order(created_at: :desc) }

  CATEGORIES = [
    "Fitness & Movement",
    "Nutrition & Wellness",
    "Mental Health",
    "Menopause Specialist",
    "Holistic Care",
    "Therapy & Counseling"
  ].freeze

  def increment_contact_count!
    increment!(:contact_count)
  end
end
