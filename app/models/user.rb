class User < ApplicationRecord
  has_many :wishlists
  devise :database_authenticatable, :registerable, :validatable
end
