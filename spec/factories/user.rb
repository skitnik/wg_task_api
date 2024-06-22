# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    trait :admin do
      email { 'admin@example.com' }
      role { :admin }
    end

    trait :client do
      email { 'client@example.com' }
      role { :client }
    end
  end
end
