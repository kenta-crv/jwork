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

ActiveRecord::Schema.define(version: 2025_10_20_121226) do

  create_table "access_logs", force: :cascade do |t|
    t.string "source"
    t.string "path"
    t.string "ip"
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "company"
    t.string "post_title"
    t.string "representative_name"
    t.string "contact_name"
    t.string "tel"
    t.string "address"
    t.string "url"
    t.string "message"
    t.string "recruit_url"
    t.string "visa"
    t.string "business"
    t.string "genre"
    t.string "salary"
    t.string "work_time"
    t.string "day_off"
    t.string "work_contents"
    t.string "number"
    t.string "house_agents"
    t.string "house_support"
    t.string "remarks"
    t.string "agree"
    t.string "contract_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "plan1"
    t.string "plan2"
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "status"
    t.string "next"
    t.string "body"
    t.integer "user_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_comments_on_client_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "tel"
    t.string "age"
    t.string "nationality"
    t.string "past_business"
    t.string "past_genre"
    t.string "past_year"
    t.string "qualifications"
    t.string "work_range"
    t.string "hope_work"
    t.string "hope_other"
    t.string "line"
    t.string "period"
    t.string "recommend"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "conversation"
    t.string "resume"
    t.string "available"
    t.string "different"
    t.string "call_check"
    t.string "call_impressions"
    t.string "change_the_address"
    t.string "call_available"
    t.string "speak_japanese"
    t.string "gender"
    t.string "drivers_lisence"
    t.string "car"
    t.string "address"
    t.string "change_the_address_check"
    t.string "work_now"
    t.string "experience"
    t.string "which_visa"
    t.string "japanese_level"
    t.string "visiting_in_japan"
    t.string "kanzi"
    t.string "start"
    t.string "address_detail"
    t.string "drivers_up"
    t.string "emergency_name"
    t.string "emergency_relationships"
    t.string "emergency_tel"
    t.string "agree"
    t.string "check_1"
    t.string "check_2"
    t.string "check_3"
    t.string "check_4"
    t.string "check_5"
    t.string "check_6"
    t.string "check_7"
    t.string "deliver"
    t.string "day_off"
    t.string "contact_date"
    t.string "contract_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
