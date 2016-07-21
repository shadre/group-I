class Item < ApplicationRecord
  belongs_to :wishlist
  validates :name, presence: true
end
