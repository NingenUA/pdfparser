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

ActiveRecord::Schema.define(version: 20140204173505) do

  create_table "books", force: true do |t|
    t.string   "client_num"
    t.string   "bill_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string  "user"
    t.string  "servpp"
    t.string  "ala"
    t.string  "ldarc"
    t.string  "dvao"
    t.string  "otherf"
    t.string  "gst"
    t.string  "subtotal"
    t.string  "total"
    t.integer "book_id"
  end

  create_table "individuals", force: true do |t|
    t.string  "client_number"
    t.string  "client_name"
    t.string  "tms"
    t.string  "spn"
    t.string  "ala"
    t.string  "ldc"
    t.string  "daos"
    t.string  "vas"
    t.string  "total"
    t.integer "book_id"
  end

end
