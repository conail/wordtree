ActiveRecord::Schema.define(:version => 20120109120852) do
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "punits"
    t.integer  "sunits"
    t.integer  "words"
    t.string   "code"
    t.string   "content"
    t.string   "date"
    t.string   "dgroup"
    t.string   "discipline_old"
    t.string   "genre_old"
    t.string   "grade"
    t.string   "level"
    t.string   "macrotype"
    t.string   "module"
    t.string   "student_id"
    t.string   "title"
    t.text     "xml"
  end

  create_table "sentences", :force => true do |t|
    t.integer  "document_id"
    t.text     "text"
    t.text     "clean"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genre_memberships", :force => true do |t|
    t.integer  "genre_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
