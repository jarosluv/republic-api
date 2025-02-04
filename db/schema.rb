# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_04_171126) do
  create_table "business_entities", force: :cascade do |t|
    t.integer "business_owner_id", null: false
    t.string "name"
    t.integer "available_shares"
    t.decimal "share_price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_owner_id"], name: "index_business_entities_on_business_owner_id"
  end

  create_table "business_owners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buy_orders", force: :cascade do |t|
    t.integer "business_entity_id", null: false
    t.integer "buyer_id", null: false
    t.string "status", default: "pending", null: false
    t.integer "share_quantity", null: false
    t.decimal "share_price", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_entity_id", "buyer_id"], name: "index_buy_orders_on_business_entity_id_and_buyer_id"
    t.index ["business_entity_id"], name: "index_buy_orders_on_business_entity_id"
    t.index ["buyer_id"], name: "index_buy_orders_on_buyer_id"
    t.index ["status"], name: "index_buy_orders_on_status"
  end

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.decimal "available_funds", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "business_entities", "business_owners"
  add_foreign_key "buy_orders", "business_entities"
  add_foreign_key "buy_orders", "buyers"
end
