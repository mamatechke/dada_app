class Circle < ApplicationRecord
  self.table_name = "circles"
  self.primary_key = "id"

  has_many :posts, dependent: :destroy

  validates :name, presence: true

  scope :for_stage, ->(stage) { where(stage_focus: stage) if stage.present? }
  scope :by_activity, -> { order(post_count: :desc, updated_at: :desc) }

  def increment_post_count!
    increment!(:post_count)
  end

  def increment_member_count!
    increment!(:member_count)
  end
end
