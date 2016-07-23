class AddTokenToWishlists < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :token, :string
    add_index :wishlists, :token
  end
end
