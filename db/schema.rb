# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_621_133_258) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'brands', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.string 'state', default: 'active'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'cards', force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.bigint 'user_id', null: false
    t.string 'activation_number'
    t.string 'pin'
    t.string 'status', default: 'requested'
    t.text 'purchase_details'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_cards_on_product_id'
    t.index ['user_id'], name: 'index_cards_on_user_id'
  end

  create_table 'client_products', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'product_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_client_products_on_product_id'
    t.index ['user_id'], name: 'index_client_products_on_user_id'
  end

  create_table 'logs', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'action'
    t.string 'record_type'
    t.integer 'record_id'
    t.text 'details'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_logs_on_user_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.decimal 'price'
    t.string 'state', default: 'active'
    t.bigint 'brand_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['brand_id'], name: 'index_products_on_brand_id'
  end

  create_table 'user_products', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'product_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_user_products_on_product_id'
    t.index ['user_id'], name: 'index_user_products_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.integer 'role', default: 2
    t.decimal 'payout_rate', default: '0.0'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'cards', 'products'
  add_foreign_key 'cards', 'users'
  add_foreign_key 'client_products', 'products'
  add_foreign_key 'client_products', 'users'
  add_foreign_key 'logs', 'users'
  add_foreign_key 'products', 'brands'
  add_foreign_key 'user_products', 'products'
  add_foreign_key 'user_products', 'users'
end
