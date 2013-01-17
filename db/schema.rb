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

ActiveRecord::Schema.define(:version => 20130117144347) do

  create_table "people", :force => true do |t|
    t.string   "first_name", :limit => 50,                     :null => false
    t.string   "last_name",  :limit => 50,                     :null => false
    t.string   "slug",       :limit => 101
    t.string   "email"
    t.string   "password",   :limit => 60
    t.text     "info"
    t.boolean  "is_admin",                  :default => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "sponsors", :force => true do |t|
    t.string   "title",                      :null => false
    t.text     "text"
    t.string   "image_url",  :limit => 2000, :null => false
    t.string   "url",        :limit => 2000
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

end
