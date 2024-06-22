# frozen_string_literal: true

class User < ApplicationRecord
  enum :role, { admin: 1, client: 2 }
  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: true

  has_secure_password
  has_many :client_products
  has_many :products, through: :client_products
  has_many :cards
end
