class CreateWishlists < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlists do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end
