class Post < ApplicationRecord
  self.table_name = "posts"
  self.primary_key = "id"

  belongs_to :circle
  belongs_to :user

  validates :content, presence: true
  validates :anonymous_handle, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(likes_count: :desc, created_at: :desc) }

  after_create :update_circle_stats

  def increment_likes!
    increment!(:likes_count)
  end

  private

  def update_circle_stats
    circle.increment_post_count! if circle
  end
end
