# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Test product' }
    description { 'Test description' }
    price { 20 }
    state { :active }
  end
end
