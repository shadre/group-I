class AddUserRefToWishlists < ActiveRecord::Migration[5.0]
  def change
    add_reference :wishlists, :user, foreign_key: true
  end
end
