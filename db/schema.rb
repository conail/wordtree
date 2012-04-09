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

ActiveRecord::Schema.define(:version => 20120227114646) do

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.string   "student_id"
    t.string   "code"
    t.string   "date"
    t.string   "module"
    t.string   "dgroup"
    t.string   "grade"
    t.integer  "words"
    t.integer  "sunits"
    t.integer  "punits"
    t.string   "macrotype"
    t.text     "content"
    t.text     "xml"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "level"
    t.string   "genre_family"
    t.string   "discipline"
    t.string   "tables"
    t.string   "figures"
    t.string   "block"
    t.string   "quotes"
    t.string   "formulae"
    t.string   "lists"
    t.string   "listlikes"
    t.string   "abstract"
    t.string   "ws"
    t.string   "sp"
    t.string   "gender"
    t.string   "dob"
    t.string   "l1"
    t.string   "education"
    t.string   "course"
    t.string   "texts"
    t.string   "complex"
  end

  add_index "documents", ["level"], :name => "index_documents_on_level"

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "remainders", :force => true do |t|
    t.string   "term"
    t.text     "body"
    t.integer  "sentence_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sentences", :force => true do |t|
    t.integer  "document_id"
    t.text     "text",        :limit => 255
    t.text     "clean",       :limit => 255
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trees", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "words", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
