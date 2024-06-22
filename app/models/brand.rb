# frozen_string_literal: true

class Brand < ApplicationRecord
  validates :name, :state, presence: true
  validates :state, inclusion: { in: %w[inactive active] }

  has_many :products, dependent: :destroy
  scope :active, -> { where(state: :active) }
end
