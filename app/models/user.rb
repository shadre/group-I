class User < ApplicationRecord
  has_many :wishlists, dependent: :destroy
  devise :database_authenticatable, :registerable, :validatable

  MINIMUM_PASSWORD_LENGTH = 6
end
