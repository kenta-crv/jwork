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

ActiveRecord::Schema.define(version: 2026_07_04_095252) do

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

  create_table "alcohols", force: :cascade do |t|
    t.datetime "post"
    t.string "check"
    t.string "health"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_alcohols_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "company"
    t.string "position"
    t.string "person"
    t.string "tel"
    t.string "email"
    t.string "mobile"
    t.string "address"
    t.string "url"
    t.datetime "meeting"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "industry"
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

  create_table "contracts", force: :cascade do |t|
    t.string "company"
    t.string "name"
    t.string "tel"
    t.string "email"
    t.string "address"
    t.string "url"
    t.string "service"
    t.string "period"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inspections", force: :cascade do |t|
    t.datetime "post"
    t.string "brakes"
    t.string "steering"
    t.string "tires"
    t.string "lighting"
    t.string "battely"
    t.string "engine"
    t.string "coolant"
    t.string "wiper"
    t.string "exhaust"
    t.string "underbody"
    t.string "remarks"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inspections_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "content"
    t.string "working_time"
    t.string "area"
    t.string "purchase_price"
    t.string "sales_price"
    t.string "delivery"
    t.string "payment"
    t.string "remarks"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rental"
    t.index ["client_id"], name: "index_jobs_on_client_id"
  end

  create_table "journals", force: :cascade do |t|
    t.datetime "post"
    t.string "dialy"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer "client_id"
    t.integer "user_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_offers_on_client_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "company"
    t.string "post_title"
    t.string "representative_name"
    t.string "contact_name"
    t.string "tel"
    t.string "address"
    t.string "url"
    t.string "message"
    t.string "agree"
    t.string "contract_date"
    t.string "question_people"
    t.string "question_attractive"
    t.string "question_open"
    t.string "question_prediction"
    t.string "agree_1"
    t.string "agree_2"
    t.string "agree_3"
    t.string "agree_4"
    t.string "agree_5"
    t.string "agree_6"
    t.string "agree_7"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_partners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true
  end

  create_table "recruits", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "unit_price"
    t.string "reward"
    t.string "working_hours"
    t.string "working_days"
    t.string "area"
    t.string "payment"
    t.string "japanese_skill"
    t.string "require"
    t.string "contract_type"
    t.string "car_details"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recommend"
    t.integer "point"
    t.string "genre"
    t.string "visa"
  end

  create_table "situations", force: :cascade do |t|
    t.string "status"
    t.string "next"
    t.string "body"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_situations_on_client_id"
  end

  create_table "user_step_mails", force: :cascade do |t|
    t.integer "user_id"
    t.string "mail_type"
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_step_mails_on_user_id"
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
    t.string "contract_date"
    t.string "account_name"
    t.string "image_1"
    t.string "image_2"
    t.string "image_3"
    t.string "image_4"
    t.string "image_5"
    t.string "image_6"
    t.string "bank"
    t.string "branch"
    t.string "bank_number"
    t.string "bank_name"
    t.string "status"
    t.datetime "next_call_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alcohols", "users"
  add_foreign_key "inspections", "users"
  add_foreign_key "jobs", "clients"
  add_foreign_key "journals", "users"
  add_foreign_key "situations", "clients"
  add_foreign_key "user_step_mails", "users"
end
