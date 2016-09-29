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

ActiveRecord::Schema.define(version: 20160502200442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree

  create_table "project_leaders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_leaders", ["user_id"], name: "index_project_leaders_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "stage",             default: 1
    t.string   "title",                         null: false
    t.text     "description",                   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "vacant_id",                     null: false
    t.integer  "project_leader_id"
  end

  add_index "projects", ["project_leader_id"], name: "index_projects_on_project_leader_id", using: :btree
  add_index "projects", ["vacant_id"], name: "index_projects_on_vacant_id", using: :btree

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  create_table "support_tickets", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "email",                      null: false
    t.text     "message",                    null: false
    t.boolean  "reviewed",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string  "firstname",                   limit: 255
    t.string  "lastname",                    limit: 255
    t.boolean "isadmin",                                 default: false, null: false
    t.boolean "isvolunteer",                             default: false, null: false
    t.string  "email",                                                   null: false
    t.string  "password_digest"
    t.boolean "email_confirmed",                         default: false
    t.string  "confirm_token"
    t.string  "username",                                                null: false
    t.integer "my_draft_comments_count",                 default: 0
    t.integer "my_published_comments_count",             default: 0
    t.integer "my_comments_count",                       default: 0
    t.integer "draft_comcoms_count",                     default: 0
    t.integer "published_comcoms_count",                 default: 0
    t.integer "deleted_comcoms_count",                   default: 0
    t.integer "spam_comcoms_count",                      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "vacants", force: :cascade do |t|
    t.string  "full_address"
    t.string  "block"
    t.string  "lot"
    t.string  "zip_code"
    t.string  "city"
    t.string  "neighborhood"
    t.string  "police_district"
    t.integer "council_district"
    t.decimal "longitude"
    t.decimal "latitude"
    t.string  "owner"
    t.string  "use"
    t.string  "mailing_address"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "project_leaders", "users"
  add_foreign_key "projects", "project_leaders"
  add_foreign_key "projects", "vacants"
end
