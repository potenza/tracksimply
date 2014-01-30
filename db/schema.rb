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

ActiveRecord::Schema.define(version: 20140129215212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "conversions", force: true do |t|
    t.integer  "visit_id"
    t.decimal  "revenue",    precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversions", ["visit_id"], name: "index_conversions_on_visit_id", using: :btree

  create_table "costs", force: true do |t|
    t.string   "type"
    t.integer  "tracking_link_id"
    t.decimal  "amount",           precision: 10, scale: 2
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "costs", ["tracking_link_id"], name: "index_costs_on_tracking_link_id", using: :btree

  create_table "expenses", force: true do |t|
    t.integer  "tracking_link_id"
    t.datetime "paid_at"
    t.decimal  "amount",           precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visit_id"
    t.integer  "import_id"
  end

  add_index "expenses", ["import_id"], name: "index_expenses_on_import_id", using: :btree
  add_index "expenses", ["tracking_link_id"], name: "index_expenses_on_tracking_link_id", using: :btree

  create_table "import_formats", force: true do |t|
    t.string   "file_type"
    t.integer  "date_column"
    t.integer  "url_column"
    t.integer  "cost_column"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", force: true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.integer  "import_format_id"
    t.string   "name"
    t.string   "file"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["site_id"], name: "index_imports_on_site_id", using: :btree
  add_index "imports", ["user_id"], name: "index_imports_on_user_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracking_links", force: true do |t|
    t.integer  "site_id"
    t.string   "landing_page_url"
    t.string   "campaign"
    t.string   "source"
    t.string   "medium"
    t.string   "ad_content"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracking_links", ["site_id"], name: "index_tracking_links_on_site_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "auth_token"
    t.boolean  "admin",                           default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",                       default: "UTC"
  end

  create_table "visitors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", force: true do |t|
    t.integer  "visitor_id"
    t.integer  "tracking_link_id"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["data"], name: "visits_gin_data", using: :gin
  add_index "visits", ["tracking_link_id"], name: "index_visits_on_tracking_link_id", using: :btree
  add_index "visits", ["visitor_id"], name: "index_visits_on_visitor_id", using: :btree

end
