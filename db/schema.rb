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

ActiveRecord::Schema.define(:version => 20120629161850) do

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "sset"
  end

  create_table "disciplines", :force => true do |t|
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "documents", :force => true do |t|
    t.integer  "genre_id"
    t.integer  "level"
    t.integer  "punits"
    t.integer  "sunits"
    t.integer  "words"
    t.text     "abstract"
    t.text     "block"
    t.text     "code"
    t.text     "complex"
    t.text     "content"
    t.text     "course"
    t.text     "date"
    t.text     "dgroup"
    t.integer  "discipline_id"
    t.text     "dob"
    t.text     "education"
    t.text     "figures"
    t.text     "formulae"
    t.text     "gender"
    t.text     "grade"
    t.text     "l1"
    t.text     "listlikes"
    t.text     "lists"
    t.text     "macrotype"
    t.text     "module"
    t.text     "quotes"
    t.float    "sp"
    t.text     "student_id"
    t.text     "tables"
    t.text     "texts"
    t.text     "title"
    t.float    "ws"
    t.text     "xml"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "documents", ["level"], :name => "index_documents_on_level"

  create_table "genres", :force => true do |t|
    t.text     "name"
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
    t.text     "text"
    t.text     "clean"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
