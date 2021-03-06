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

ActiveRecord::Schema.define(version: 20210422060141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

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
    t.text     "country"
    t.integer  "year"
    t.text     "genres"
    t.text     "videos"
    t.text     "styles"
    t.text     "artists"
    t.text     "pricing"
    t.text     "thumb"
  end

  add_index "records", ["query_id"], name: "index_records_on_query_id", using: :btree

  add_foreign_key "records", "queries"
end
