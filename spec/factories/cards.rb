# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    product { nil }
    user { nil }
    activation_number { SecureRandom.hex(4) }
    pin { SecureRandom.hex(6) }
    status { 'requested' }
    purchase_details { 'Product: Test product, Price: 20.00, Brand: Test brand' }
  end
end
