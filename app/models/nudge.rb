class Nudge < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  scope :active, -> { where(active: true) }
  scope :by_priority, -> { order(priority: :desc, created_at: :desc) }
  scope :for_stage, ->(stage) { where("? = ANY(stage_targets)", stage) if stage.present? }
  scope :for_symptom, ->(symptom) { where("? = ANY(symptom_targets)", symptom) if symptom.present? }

  NUDGE_TYPES = ["wellness_tip", "resource_highlight", "circle_invite", "milestone_celebration"].freeze

  def self.personalized_for(user_profile)
    nudges = active.by_priority

    if user_profile&.stage.present?
      nudges = nudges.for_stage(user_profile.stage)
    end

    if user_profile&.symptoms.present?
      user_profile.symptoms.each do |symptom|
        nudges = nudges.or(Nudge.for_symptom(symptom))
      end
    end

    nudges.limit(3)
  end
end
