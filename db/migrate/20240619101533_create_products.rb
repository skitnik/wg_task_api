# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :state, default: 'active'
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
