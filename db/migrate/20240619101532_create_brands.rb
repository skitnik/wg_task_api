# frozen_string_literal: true

class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.string :state, default: 'active'

      t.timestamps
    end
  end
end
