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

ActiveRecord::Schema.define(version: 20151027225215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "rodovias", force: :cascade do |t|
    t.string   "br"
    t.string   "uf"
    t.string   "codigo"
    t.string   "local_de_i"
    t.string   "local_de_f"
    t.integer  "km_inicial"
    t.integer  "km_final"
    t.decimal  "extensao",                                                  precision: 8
    t.string   "superficie"
    t.string   "federal_co"
    t.string   "federal__1"
    t.string   "federal__2"
    t.string   "estadual_c"
    t.string   "superfic_1"
    t.string   "mpv_082_20"
    t.string   "concessao_"
    t.geometry "geom",       limit: {:srid=>0, :type=>"multi_line_string"}
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  create_table "useres", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "useres", ["email"], name: "index_useres_on_email", unique: true, using: :btree
  add_index "useres", ["reset_password_token"], name: "index_useres_on_reset_password_token", unique: true, using: :btree

  create_table "via_caracteristic_categorys", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "importance"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "via_caracteristics", force: :cascade do |t|
    t.string    "name"
    t.string    "description"
    t.integer   "via_caracteristic_categorys_id"
    t.geography "geom",                           limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at",                                                                              null: false
    t.datetime  "updated_at",                                                                              null: false
    t.integer   "rodovia_id"
    t.float     "distance"
    t.float     "km"
    t.geography "geom_b",                         limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.float     "distance_end"
    t.float     "km_end"
  end

  add_index "via_caracteristics", ["rodovia_id"], name: "index_via_caracteristics_on_rodovia_id", using: :btree

end
