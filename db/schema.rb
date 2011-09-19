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

ActiveRecord::Schema.define(:version => 20110919081822) do

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disciplines_documents", :id => false, :force => true do |t|
    t.integer "discipline_id"
    t.integer "document_id"
  end

  create_table "documents", :force => true do |t|
    t.integer  "student_id"
    t.string   "code"
    t.string   "title"
    t.integer  "level"
    t.date     "date"
    t.string   "module"
    t.string   "genre_old"
    t.string   "discipline_old"
    t.string   "dgroup"
    t.string   "grade"
    t.integer  "words"
    t.integer  "sunits"
    t.integer  "punits"
    t.string   "macrotype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
  end

  create_table "genre_memberships", :force => true do |t|
    t.integer  "genre_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "term_mappings", :force => true do |t|
    t.integer  "term_id"
    t.integer  "document_id"
    t.integer  "pos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
