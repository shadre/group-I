class User < ApplicationRecord
  has_many :wishlists, dependent: :destroy
  devise :database_authenticatable, :registerable, :validatable
end
