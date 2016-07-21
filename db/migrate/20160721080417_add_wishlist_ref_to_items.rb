class AddWishlistRefToItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :wishlist, foreign_key: true
  end
end
