# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :product
  belongs_to :user

  before_validation :generate_activation_number, on: :create
  before_validation :generate_pin, on: :create

  validates :activation_number, presence: true, uniqueness: true
  validates :pin, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[requested activated canceled] }

  scope :requested, -> { where(status: :requested) }
  scope :activated, -> { where(status: :activated) }
  scope :canceled, -> { where(status: :canceled) }

  private

  def generate_activation_number
    activation_number = SecureRandom.hex(4)
    self.activation_number ||= activation_number
    generate_activation_number if self.class.exists?(activation_number:)
  end

  def generate_pin
    pin = SecureRandom.hex(6)
    self.pin ||= pin
    generate_pin if self.class.exists?(pin:)
  end
end
