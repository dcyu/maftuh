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

ActiveRecord::Schema.define(version: 20141207223433) do

  create_table "checkpoints", force: true do |t|
    t.string   "en_name"
    t.string   "ar_name"
    t.string   "lat"
    t.string   "lng"
    t.text     "en_description"
    t.text     "ar_description"
    t.boolean  "open"
    t.integer  "district_id"
    t.string   "category"
    t.string   "staffing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "en_name"
    t.string   "ar_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "body"
    t.string   "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "checkpoint_id"
    t.string   "tweet_id"
  end

end
