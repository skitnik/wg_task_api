# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, :price, :state, presence: true
  validates :state, inclusion: { in: %w[inactive active] }

  belongs_to :brand
  has_many :client_products
  has_many :users, through: :client_products
  has_many :cards

  scope :active, -> { joins(:brand).where(state: :active, brands: { state: :active }) }
end
