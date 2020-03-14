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

ActiveRecord::Schema.define(version: 20180406000312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "doc"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "priority"
    t.string   "original_name"
    t.index ["task_id"], name: "index_attachments_on_task_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_comments_on_task_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "priorities", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "request_types", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "link"
    t.date     "required_by"
    t.boolean  "member_facing"
    t.integer  "reported_by_id"
    t.integer  "assigned_to_id"
    t.integer  "request_type_id"
    t.integer  "vertical_id"
    t.integer  "priority_id"
    t.integer  "status_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["priority_id"], name: "index_tasks_on_priority_id", using: :btree
    t.index ["request_type_id"], name: "index_tasks_on_request_type_id", using: :btree
    t.index ["status_id"], name: "index_tasks_on_status_id", using: :btree
    t.index ["vertical_id"], name: "index_tasks_on_vertical_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           default: "", null: false
    t.string   "password_digest", default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role_id"
    t.string   "avatar"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "login_attempts",  default: 0,  null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
  end

  create_table "verticals", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "attachments", "tasks"
  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "users"
  add_foreign_key "tasks", "priorities"
  add_foreign_key "tasks", "request_types"
  add_foreign_key "tasks", "statuses"
  add_foreign_key "tasks", "verticals"
  add_foreign_key "users", "roles"
end
