class Wishlist < ApplicationRecord
  include Tokenable

  belongs_to :user
  has_many :items

  validates :name, presence: true

  scope :created_by, ->(user) { where(user_id: user.id) }
end
