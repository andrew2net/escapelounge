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

ActiveRecord::Schema.define(version: 20171006094552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_step_solutions", force: :cascade do |t|
    t.bigint "game_step_id"
    t.string "solution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_step_id"], name: "index_game_step_solutions_on_game_step_id"
  end

  create_table "game_steps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "short_description"
    t.integer "status"
    t.integer "difficulty"
    t.integer "age_range"
    t.boolean "visible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_length"
    t.text "instructions"
    t.string "instructions_pdf_file_name"
    t.string "instructions_pdf_content_type"
    t.integer "instructions_pdf_file_size"
    t.datetime "instructions_pdf_updated_at"
  end

  create_table "hints", id: :serial, force: :cascade do |t|
    t.string "description"
    t.integer "game_step_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_games", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.bigint "game_id"
    t.datetime "game_start_at"
    t.integer "pause_at"
    t.integer "timezone_offset", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["game_id"], name: "index_users_on_game_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_step_solutions", "game_steps"
  add_foreign_key "users", "games"
end
