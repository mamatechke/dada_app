class User < ApplicationRecord
  has_many :shares, dependent: :destroy
  has_one :user_profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :saved_contents, dependent: :destroy
  has_many :saved_content_items, through: :saved_contents, source: :content
  has_many :conversations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_user_profile

  private

  def create_user_profile
    build_user_profile.save
  end
end
