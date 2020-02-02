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

ActiveRecord::Schema.define(version: 20151115075236) do

  create_table "queries", force: :cascade do |t|
    t.text     "query_string"
    t.integer  "total_pages"
    t.integer  "completed_page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", force: :cascade do |t|
    t.float    "rating"
    t.integer  "count"
    t.integer  "want"
    t.integer  "discogs_id"
    t.string   "title"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",       default: 0
    t.integer  "query_id"
    t.decimal  "median_price"
    t.decimal  "high_price"
  end

  add_index "records", ["query_id"], name: "index_records_on_query_id"

end
