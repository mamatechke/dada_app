class User < ApplicationRecord
  has_many :shares, dependent: :destroy
  has_one :user_profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :saved_contents, dependent: :destroy
  has_many :saved_content_items, through: :saved_contents, source: :content
  has_many :conversations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, moderator: 1, admin: 2 }

  after_create :create_user_profile

  def admin?
    role == "admin"
  end

  def moderator?
    role == "moderator" || admin?
  end

  private

  def create_user_profile
    build_user_profile.save
  end
end
