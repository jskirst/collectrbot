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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130504202645) do

  create_table "pages", :force => true do |t|
    t.string "title"
    t.text   "url"
    t.text   "content"
  end

  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.datetime "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_pages", :force => true do |t|
    t.string   "user_id"
    t.integer  "page_id"
    t.integer  "viewed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "shared"
    t.datetime "favorited"
    t.datetime "archived"
    t.datetime "trashed"
  end

  add_index "user_pages", ["user_id", "page_id"], :name => "index_user_pages_on_user_id_and_page_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.datetime "limited"
    t.datetime "locked"
    t.datetime "deactivated"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
