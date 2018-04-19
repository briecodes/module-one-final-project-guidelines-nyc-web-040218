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

ActiveRecord::Schema.define(version: 8) do

  create_table "authors", force: :cascade do |t|
    t.string "author"
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer "book_id"
    t.integer "author_id"
  end

  create_table "book_categories", force: :cascade do |t|
    t.integer "book_id"
    t.integer "category_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "pub_date"
    t.integer "page_count"
    t.string "description"
    t.float "avg_rating"
    t.integer "ratings_count"
    t.text "url"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category"
  end

  create_table "queries", force: :cascade do |t|
    t.integer "search_term_id"
  end

  create_table "query_results", force: :cascade do |t|
    t.integer "query_id"
    t.integer "book_id"
  end

  create_table "search_terms", force: :cascade do |t|
    t.string "search_term"
  end

end
