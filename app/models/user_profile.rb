class UserProfile < ApplicationRecord
  self.table_name = "user_profiles"
  self.primary_key = "id"

  belongs_to :user, foreign_key: "user_id", primary_key: "id"

  validates :user_id, presence: true, uniqueness: true
  validates :anonymous_handle, uniqueness: true, allow_nil: true

  STAGES = ["Perimenopause", "Menopause", "Post-menopause", "Not sure", "Ally"].freeze

  before_create :generate_anonymous_handle

  private

  def generate_anonymous_handle
    return if anonymous_handle.present?

    adjectives = %w[Wise Gentle Strong Brave Kind Calm Radiant Peaceful Vibrant Joyful]
    nouns = %w[Butterfly Sunflower Ocean Star Moon River Mountain Garden Dawn Light]

    loop do
      handle = "#{adjectives.sample}#{nouns.sample}#{rand(100..999)}"
      self.anonymous_handle = handle
      break unless UserProfile.exists?(anonymous_handle: handle)
    end
  end
end
