class PageSection < ApplicationRecord
  belongs_to :updated_by, class_name: "User", optional: true

  validates :section_name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :by_order, -> { order(section_order: :asc) }

  SECTION_NAMES = ["hero", "stories", "resources", "chatbot"].freeze

  validates :section_name, inclusion: { in: SECTION_NAMES }

  # Serialize content_data as JSON for SQLite compatibility
  serialize :content_data, coder: JSON
end
