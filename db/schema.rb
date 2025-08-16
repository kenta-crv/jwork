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

ActiveRecord::Schema.define(version: 2025_08_16_185810) do

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

  create_table "contracts", force: :cascade do |t|
    t.string "agree"
    t.string "co"
    t.string "president_first"
    t.string "president_last"
    t.string "tel"
    t.string "address"
    t.string "url"
    t.string "recruit_url"
    t.string "work"
    t.string "qualifications"
    t.string "number"
    t.string "period"
    t.string "remarks"
    t.string "person_first"
    t.string "person_last"
    t.string "email"
    t.string "cc"
    t.string "post_title"
    t.string "experience"
    t.string "recruit_url_2"
    t.string "pdf"
    t.string "contract_date"
    t.string "unit_price"
    t.string "refund"
    t.string "payment"
    t.string "salary"
    t.string "employment_conditions"
    t.string "document_screening"
    t.string "conversion"
    t.string "application"
    t.string "driver_licence"
    t.string "housing"
    t.string "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
