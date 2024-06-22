# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :role, default: 2
      t.decimal :payout_rate, default: 0

      t.timestamps
    end
  end
end
