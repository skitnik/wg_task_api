# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:state) }
    it { should validate_inclusion_of(:state).in_array(%w[inactive active]) }
  end

  describe 'associations' do
    it { should belong_to(:brand) }
    it { should have_many(:client_products) }
    it { should have_many(:users).through(:client_products) }
    it { should have_many(:cards) }
  end

  describe 'scopes' do
    describe '.active' do
      let(:inactive_brand) { create(:brand, state: 'inactive') }
      let!(:inactive_product) { create(:product, brand: inactive_brand, state: 'inactive') }
      let(:active_brand) { create(:brand, state: :active) }
      let!(:active_product) { create(:product, brand: active_brand, state: 'active') }

      it 'returns only active products' do
        expect(Product.active).to include(active_product)
        expect(Product.active).not_to include(inactive_product)
      end
    end
  end
end
