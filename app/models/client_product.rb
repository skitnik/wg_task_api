# frozen_string_literal: true

class ClientProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user, :product, presence: true
  validate :unique_user_product_combination

  private

  def unique_user_product_combination
    errors.add(:base, "Product #{product_id} already assigned") if ClientProduct.exists?(user_id:, product_id:)
  end
end
