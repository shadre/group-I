class Wishlist < ApplicationRecord
  include Tokenable

  belongs_to :user
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :token, presence: true, uniqueness: true

  scope :created_by, ->(user) { where(user_id: user.id) }
end
