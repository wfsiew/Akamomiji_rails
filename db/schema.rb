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

ActiveRecord::Schema.define(:version => 20130224145633) do

  create_table "kitchen_sch", :force => true do |t|
    t.integer "category",               :null => false
    t.string  "name",     :limit => 30, :null => false
    t.string  "position", :limit => 30, :null => false
    t.integer "location",               :null => false
    t.integer "week",                   :null => false
    t.integer "year",                   :null => false
    t.string  "mon",      :limit => 1,  :null => false
    t.string  "tue",      :limit => 1,  :null => false
    t.string  "wed",      :limit => 1,  :null => false
    t.string  "thur",     :limit => 1,  :null => false
    t.string  "fri",      :limit => 1,  :null => false
    t.string  "sat",      :limit => 1,  :null => false
    t.string  "sun",      :limit => 1,  :null => false
  end

  create_table "reservation", :force => true do |t|
    t.date    "reserve_date",               :null => false
    t.time    "reserve_time",               :null => false
    t.string  "name",         :limit => 30, :null => false
    t.string  "pax",          :limit => 10, :null => false
    t.string  "table",        :limit => 5,  :null => false
    t.string  "phone_no",     :limit => 15, :null => false
    t.string  "remarks",      :limit => 30, :null => false
    t.integer "location",                   :null => false
  end

  create_table "service_sch", :force => true do |t|
    t.integer "category",               :null => false
    t.string  "name",     :limit => 30, :null => false
    t.string  "position", :limit => 30, :null => false
    t.integer "location",               :null => false
    t.integer "week",                   :null => false
    t.integer "year",                   :null => false
    t.string  "mon",      :limit => 1,  :null => false
    t.string  "tue",      :limit => 1,  :null => false
    t.string  "wed",      :limit => 1,  :null => false
    t.string  "thur",     :limit => 1,  :null => false
    t.string  "fri",      :limit => 1,  :null => false
    t.string  "sat",      :limit => 1,  :null => false
    t.string  "sun",      :limit => 1,  :null => false
  end

  create_table "user", :force => true do |t|
    t.integer "role",     :null => false
    t.integer "type",     :null => false
    t.string  "password", :null => false
  end

end
