# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'enums' do
    it 'defines the enum for role' do
      should define_enum_for(:role).with_values(admin: 1, client: 2)
    end
  end

  describe 'associations' do
    it { should have_secure_password }
    it { should have_many(:client_products) }
    it { should have_many(:products).through(:client_products) }
    it { should have_many(:cards) }
  end
end
