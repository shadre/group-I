ActiveRecord::Schema.define(version: 20160727195230) do
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "wishlist_id"
    t.index ["wishlist_id"], name: "index_items_on_wishlist_id", using: :btree
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_reservations_on_item_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "wishlists", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "token",       null: false
    t.index ["token"], name: "index_wishlists_on_token", using: :btree
    t.index ["user_id"], name: "index_wishlists_on_user_id", using: :btree
  end

  add_foreign_key "items", "wishlists"
  add_foreign_key "reservations", "items"
  add_foreign_key "wishlists", "users"
end
