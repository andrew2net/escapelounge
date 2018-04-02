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

ActiveRecord::Schema.define(version: 20180401224812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "game_assets", force: :cascade do |t|
    t.string "name"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.index ["game_id"], name: "index_game_assets_on_game_id"
  end

  create_table "game_step_solutions", force: :cascade do |t|
    t.bigint "game_step_id"
    t.string "solution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question"
    t.index ["game_step_id"], name: "index_game_step_solutions_on_game_step_id"
  end

  create_table "game_steps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "answer_input_type", default: 0, null: false
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "short_description"
    t.integer "status"
    t.integer "difficulty"
    t.boolean "visible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_length"
    t.text "instructions"
    t.string "instructions_pdf_file_name"
    t.string "instructions_pdf_content_type"
    t.integer "instructions_pdf_file_size"
    t.datetime "instructions_pdf_updated_at"
    t.string "background_file_name"
    t.string "background_content_type"
    t.integer "background_file_size"
    t.datetime "background_updated_at"
    t.string "banner_file_name"
    t.string "banner_content_type"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "games_grades", id: false, force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "grade_id", null: false
    t.index ["game_id"], name: "index_games_grades_on_game_id"
    t.index ["grade_id"], name: "index_games_grades_on_grade_id"
  end

  create_table "grades", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grades_subscription_plans", id: false, force: :cascade do |t|
    t.bigint "grade_id", null: false
    t.bigint "subscription_plan_id", null: false
    t.index ["grade_id"], name: "index_grades_subscription_plans_on_grade_id"
    t.index ["subscription_plan_id"], name: "index_grades_subscription_plans_on_subscription_plan_id"
  end

  create_table "hints", id: :serial, force: :cascade do |t|
    t.string "description"
    t.integer "game_step_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "hints_user_games", id: false, force: :cascade do |t|
    t.bigint "hint_id", null: false
    t.bigint "user_game_id", null: false
    t.index ["hint_id"], name: "index_hints_user_games_on_hint_id"
    t.index ["user_game_id"], name: "index_hints_user_games_on_user_game_id"
  end

  create_table "image_response_options", force: :cascade do |t|
    t.bigint "game_step_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["game_step_id"], name: "index_image_response_options_on_game_step_id"
  end

  create_table "step_answers", force: :cascade do |t|
    t.bigint "user_game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer"
    t.bigint "game_step_solution_id"
    t.index ["game_step_solution_id"], name: "index_step_answers_on_game_step_solution_id"
    t.index ["user_game_id"], name: "index_step_answers_on_user_game_id"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "name"
    t.string "stripe_id"
    t.decimal "price", precision: 5, scale: 2
    t.integer "period", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_games", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at", null: false
    t.integer "paused_at"
    t.datetime "finished_at"
    t.integer "result"
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
    t.string "stripe_id"
    t.string "subscription_id"
    t.datetime "period_end"
    t.bigint "subscription_plan_id"
    t.boolean "start_popup", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["subscription_plan_id"], name: "index_users_on_subscription_plan_id"
  end

  add_foreign_key "game_assets", "games"
  add_foreign_key "game_step_solutions", "game_steps"
  add_foreign_key "image_response_options", "game_steps"
  add_foreign_key "step_answers", "game_step_solutions"
  add_foreign_key "step_answers", "user_games"
  add_foreign_key "users", "subscription_plans"
end
