class Share < ApplicationRecord
  belongs_to :user

  enum :visibility, { public: 1, private: 2 }, prefix: true

  TYPES = [
    ["Text", "text"],
    ["Image", "image"],
    ["Video", "video"]
  ].freeze

  validates :share_type, presence: true
  validates :visibility, presence: true
end
