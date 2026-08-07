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

ActiveRecord::Schema[8.1].define(version: 2026_07_30_143539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "expense_splits", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.integer "expense_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["expense_id"], name: "index_expense_splits_on_expense_id"
    t.index ["user_id"], name: "index_expense_splits_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "payer_id", null: false
    t.date "spent_on"
    t.string "title"
    t.integer "trip_id", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
    t.index ["trip_id"], name: "index_expenses_on_trip_id"
  end

  create_table "join_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "status"
    t.integer "trip_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["trip_id"], name: "index_join_requests_on_trip_id"
    t.index ["user_id"], name: "index_join_requests_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role", default: "member"
    t.integer "trip_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["trip_id"], name: "index_memberships_on_trip_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "settlements", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.integer "payer_id", null: false
    t.integer "receiver_id", null: false
    t.integer "status", default: 0
    t.integer "trip_id", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_id"], name: "index_settlements_on_payer_id"
    t.index ["receiver_id"], name: "index_settlements_on_receiver_id"
    t.index ["trip_id"], name: "index_settlements_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.string "destination"
    t.date "end_date"
    t.string "join_token"
    t.string "name"
    t.date "start_date"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_trips_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "expense_splits", "expenses"
  add_foreign_key "expense_splits", "users"
  add_foreign_key "expenses", "trips"
  add_foreign_key "expenses", "users", column: "payer_id"
  add_foreign_key "join_requests", "trips"
  add_foreign_key "join_requests", "users"
  add_foreign_key "memberships", "trips"
  add_foreign_key "memberships", "users"
  add_foreign_key "settlements", "trips"
  add_foreign_key "settlements", "users", column: "payer_id"
  add_foreign_key "settlements", "users", column: "receiver_id"
  add_foreign_key "trips", "users", column: "creator_id"
end
