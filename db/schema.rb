# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131203110246) do

  create_table "challenges", force: true do |t|
    t.string   "title"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reward"
    t.integer  "building_id"
    t.integer  "room_id"
  end

  create_table "participations", force: true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["challenge_id"], name: "index_participations_on_challenge_id"
  add_index "participations", ["user_id"], name: "index_participations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
