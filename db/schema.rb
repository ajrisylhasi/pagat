# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_28_090327) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "sending_mail"
    t.string "lang"
  end

  create_table "deklarims", force: :cascade do |t|
    t.string "muaji"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "kerkesas", force: :cascade do |t|
    t.date "data_punes"
    t.string "lloji_pushimit"
    t.string "ditet_pushimit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "data_fillimit"
    t.date "data_mbarimit"
    t.integer "numri_diteve"
    t.boolean "finished"
    t.text "file"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_kerkesas_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id"
    t.string "kush"
    t.index ["admin_id"], name: "index_logs_on_admin_id"
  end

  create_table "pagas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "deklarim_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date_from"
    t.date "date_to"
    t.index ["deklarim_id"], name: "index_pagas_on_deklarim_id"
    t.index ["user_id"], name: "index_pagas_on_user_id"
  end

  create_table "pushims", force: :cascade do |t|
    t.date "date"
    t.text "komenti"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "specific_contracts", force: :cascade do |t|
    t.integer "monday"
    t.integer "tuesday"
    t.integer "wednesday"
    t.integer "thursday"
    t.integer "friday"
    t.integer "saturday"
    t.integer "sunday"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_specific_contracts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "idnum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "contract"
    t.float "salary"
    t.text "comment"
    t.string "salary_type"
    t.float "sales"
    t.string "email"
    t.boolean "spec_contract"
    t.text "pushimet"
    t.boolean "shkurt_pushim"
    t.integer "pushimi_vjetor"
    t.integer "pushimi_mjekesor"
  end

  create_table "works", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.float "break"
    t.boolean "pushim"
    t.integer "group_id"
    t.boolean "part_group"
    t.float "miss"
    t.index ["group_id"], name: "index_works_on_group_id"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "groups", "users"
  add_foreign_key "kerkesas", "users"
  add_foreign_key "logs", "admins"
  add_foreign_key "pagas", "deklarims"
  add_foreign_key "pagas", "users"
  add_foreign_key "specific_contracts", "users"
  add_foreign_key "works", "groups"
  add_foreign_key "works", "users"
end
