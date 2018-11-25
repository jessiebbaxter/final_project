# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_25_022805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.string "source_url"
    t.integer "price_cents", default: 0, null: false
    t.bigint "varient_id"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.index ["seller_id"], name: "index_inventories_on_seller_id"
    t.index ["varient_id"], name: "index_inventories_on_varient_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "qty", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.index ["inventory_id"], name: "index_order_items_on_inventory_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "state", default: "pending"
    t.integer "amount_cents", default: 0, null: false
    t.jsonb "payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "brand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating"
    t.integer "review_count"
    t.string "photo"
  end

  create_table "quick_buy_items", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.index ["inventory_id"], name: "index_quick_buy_items_on_inventory_id"
    t.index ["product_id"], name: "index_quick_buy_items_on_product_id"
    t.index ["user_id"], name: "index_quick_buy_items_on_user_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shippings", force: :cascade do |t|
    t.integer "minimum_spend"
    t.integer "shipping_speed"
    t.string "rule"
    t.integer "cost_cents", default: 0, null: false
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_shippings_on_seller_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "facebook_picture_url"
    t.string "first_name"
    t.string "last_name"
    t.string "token"
    t.datetime "token_expiry"
    t.string "customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "varients", force: :cascade do |t|
    t.string "name"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.index ["product_id"], name: "index_varients_on_product_id"
  end

  add_foreign_key "inventories", "sellers"
  add_foreign_key "inventories", "varients"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "quick_buy_items", "products"
  add_foreign_key "quick_buy_items", "users"
  add_foreign_key "shippings", "sellers"
  add_foreign_key "varients", "products"
end
