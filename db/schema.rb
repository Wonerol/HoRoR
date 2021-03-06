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

ActiveRecord::Schema.define(version: 20140917152148) do

  create_table "armies", force: true do |t|
    t.integer  "monster_id"
    t.integer  "monster_amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ai_controlled"
    t.integer  "residual_dmg"
  end

  create_table "monsters", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "flavour_text", limit: 255
    t.integer  "cost"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "hp"
    t.integer  "min_damage"
    t.integer  "max_damage"
    t.integer  "speed"
  end

  add_index "monsters", ["name"], name: "index_monsters_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.integer  "gold"
    t.integer  "gold_prize"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
