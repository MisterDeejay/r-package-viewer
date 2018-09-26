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

ActiveRecord::Schema.define(version: 2018_09_25_192537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors_packages", force: :cascade do |t|
    t.bigint "author_id"
    t.bigint "package_id"
    t.index ["author_id", "package_id"], name: "index_authors_packages_on_author_id_and_package_id", unique: true
    t.index ["author_id"], name: "index_authors_packages_on_author_id"
    t.index ["package_id"], name: "index_authors_packages_on_package_id"
  end

  create_table "maintainers_packages", force: :cascade do |t|
    t.bigint "maintainer_id"
    t.bigint "package_id"
    t.index ["maintainer_id", "package_id"], name: "index_maintainers_packages_on_maintainer_id_and_package_id", unique: true
    t.index ["maintainer_id"], name: "index_maintainers_packages_on_maintainer_id"
    t.index ["package_id"], name: "index_maintainers_packages_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "package_name"
    t.string "version"
    t.datetime "published_at"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
