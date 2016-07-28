class Item < ApplicationRecord
  belongs_to :wishlist
  has_one :reservation, dependent: :destroy

  validates :name, presence: true

  def reserved?
    reservation.present?
  end
end
