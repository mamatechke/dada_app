class Message < ApplicationRecord
  belongs_to :conversation

  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  validates :content, presence: true

  scope :recent, -> { order(created_at: :asc) }
end
