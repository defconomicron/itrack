# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081224025810) do

  create_table "page_views", :force => true do |t|
    t.string   "domain"
    t.string   "url"
    t.string   "ip_address"
    t.string   "cookie_id"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "longitude"
    t.string   "latitude"
    t.boolean  "new_visitor"
    t.boolean  "return_visitor"
    t.boolean  "new_visit"
    t.string   "http_user_agent"
    t.string   "http_accept_language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
