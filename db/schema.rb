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

ActiveRecord::Schema[7.1].define(version: 2026_01_02_131029) do
  create_table "api_keys", force: :cascade do |t|
    t.string "name"
    t.string "key_digest"
    t.boolean "active"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
  end

  create_table "asanas", force: :cascade do |t|
    t.string "title"
    t.text "benefits"
    t.text "contraindications"
    t.text "alternatives_and_options"
    t.text "counterposes"
    t.text "meridians_and_organs"
    t.text "joints"
    t.string "recommended_time"
    t.text "other_notes"
    t.text "into_pose"
    t.text "out_of_pose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "session_id"
    t.text "similar_yang_asanas"
    t.index ["session_id"], name: "index_asanas_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "device_id"
  end

  create_table "timers", force: :cascade do |t|
    t.integer "duration"
    t.integer "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["session_id"], name: "index_timers_on_session_id"
  end

  add_foreign_key "asanas", "sessions"
  add_foreign_key "timers", "sessions"
end
