# frozen_string_literal: true

FactoryBot.define do
  factory :brand do
    name { 'Test brand' }
    state { :active }
  end
end
